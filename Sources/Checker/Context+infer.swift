extension Context {
    func infer(_ expression: borrowing Expression) throws(TypeCheckError) -> CanonicalType {
        switch expression {
        // MARK: - STLC
        case .var(let name):
            return try data[name]

        case .abstraction(let parameters, let returnExpression):
            let functionParameters = try (
                parameters.canonized() |> Function.Parameters.init(from:) <!> {
                    CanonizeError.parametersError($0, in: .lambda(
                        parameters: parameters,
                        returnExpression: returnExpression
                    ))
                }
            ) <!> TypeCheckError.canonizeError

            var localContext = self
            localContext.data.shadow(by: functionParameters)

            let returnType = try localContext.infer(returnExpression)

            return .function(
                from: Array.init § functionParameters.values,
                to: returnType
            )

        case .application(let callee, let arguments):
            let calleeType = try infer(callee)

            guard case let .function(parameterTypes, returnType) = calleeType else {
                throw .notAFunction(actual: calleeType, in: copy expression)
            }

            guard arguments.count == parameterTypes.count else {
                throw .incorrectArgumentsNumber(
                    actual: arguments.count,
                    expected: parameterTypes.count,
                    type: calleeType,
                    in: copy expression
                )
            }

            for (argument, parameterType) in zip(arguments, parameterTypes) {
                try check(argument, against: parameterType)
            }

            return returnType

        // MARK: - Bool
        case .constTrue,
             .constFalse:
            return .bool

        case .if(let condition, let then, let `else`):
            try check(condition, against: .bool)

            if extensions.contains(.typeReconstruction) {
                let thenType = try infer(then)
                let elseType = try infer(`else`)

                return try unify(actual: thenType, expected: elseType) <!> {
                    TypeCheckError.unifyError($0, in: copy expression)
                }
            } else {
                let thenType = try infer(then)
                try check(`else`, against: thenType)

                return thenType
            }

        // MARK: - Nat
        case .constInt:
            return .nat

        case .succ(let expression):
            try check(expression, against: .nat)

            return .nat

        case .pred(let expression):
            try check(expression, against: .nat)

            return .nat

        case .isZero(let expression):
            try check(expression, against: .nat)

            return .bool

        case .natRec(let n, let zero, let step):
            try check(n, against: .nat)

            let zeroType = try infer(zero)

            if extensions.contains(.typeReconstruction) {
                let stepType = try infer(step)

                _ = try unify(
                    actual: stepType,
                    expected: .function(
                        from: [.nat],
                        to: .function(from: [zeroType], to: zeroType)
                    )
                ) <!> {
                    TypeCheckError.unifyError($0, in: copy expression)
                }
            } else {
                try check(step, against: .function(
                    from: [.nat],
                    to: .function(from: [zeroType], to: zeroType)
                ))
            }

            return zeroType

        // MARK: - #unit-type
        case .constUnit:
            return .unit

        // MARK: - #pairs, #tuples
        case .tuple(let elements):
            let types = try elements.map(infer)

            return .tuple(elements: types)

        case .dotTuple(let tuple, let index):
            let tupleType = try infer(tuple)

            guard case .tuple(let elements) = tupleType else {
                throw .notATuple(actual: tupleType, in: copy expression)
            }

            guard let type = elements[safe: index - 1] else {
                throw .tupleIndexOutOfBounds(index: index, type: tupleType, in: copy expression)
            }

            return type

        // MARK: - #records
        case .record(let fields):
            return try CanonicalType.record § Dictionary(
                uniqueKeysWithValues: fields.lazy.map { label, value in
                    (key: label, value: value)
                },
                rejectingDuplicateKeysWith: { duplicates in
                    TypeCheckError.duplicateRecordFields(duplicates, in: copy expression)
                }
            )
            .mapValues(infer)

        case .dotRecord(let record, let label):
            let recordType = try infer(record)

            guard case .record(let fields) = recordType else {
                throw .notARecord(actual: recordType, in: copy expression)
            }

            guard let type = fields[label] else {
                throw .unexpectedFieldAccess(label, type: recordType, in: copy expression)
            }

            return type

        // MARK: - #let-patterns
        case .let(let cases, let inExpression):
            return try contextOfLet(cases: cases, in: expression)
                .infer(inExpression)

        // MARK: - #letrec-bindings
        case .letrec(let cases, let expression):
            return try contextOfLetrec(cases: cases, in: expression)
                .infer(expression)

        // MARK: - #type-ascriptions
        case .typeAscription(let value, let rawType):
            let ascribedType = try CanonicalType(from: rawType) <!> TypeCheckError.canonizeError
            try check(value, against: ascribedType)

            return ascribedType

        // MARK: - #sum-types
        case .inl(let left):
            guard extensions.contains(.ambiguousTypeAsBottom) else {
                throw .ambiguousSumType(in: copy expression)
            }

            let leftType = try infer(left)

            return .sum(left: leftType, right: .bottom)

        case .inr(let right):
            guard extensions.contains(.ambiguousTypeAsBottom) else {
                throw .ambiguousSumType(in: copy expression)
            }

            let rightType = try infer(right)

            return .sum(left: .bottom, right: rightType)

        // MARK: - #variants
        case .variant(let label, let data):
            guard extensions.contains(.structuralSubtyping) else {
                throw .ambiguousVariantType(in: copy expression)
            }

            let dataType = try data.map(infer)

            return .variant(cases: [label: dataType])

        case .match(let value, let cases):
            let matchContexts = try contextsOfMatch(
                value: value,
                cases: cases,
                in: expression
            )

            if extensions.contains(.typeReconstruction) {
                let caseTypes = try matchContexts.map { localContext, value throws(TypeCheckError) in
                    try localContext.infer(value)
                }

                let unifiedType = try caseTypes.fold(unify(actual:expected:)) <!> {
                    TypeCheckError.unifyError($0, in: copy expression)
                }

                return unifiedType
            } else {
                let (localContext, value) = matchContexts.first
                let firstType = try localContext.infer(value)

                for (localContext, value) in matchContexts.dropFirst() {
                    try localContext.check(value, against: firstType)
                }

                return firstType
            }

        // MARK: - #lists
        case .list(let elements):
            guard let elements = NonEmpty(rawValue: elements) else {
                guard extensions.contains(.ambiguousTypeAsBottom) else {
                    throw .ambiguousListType(in: copy expression)
                }

                return .list(.bottom)
            }

            if extensions.contains(.typeReconstruction) {
                let types = try elements.map(infer)

                let unifiedType = try types.fold(unify(actual:expected:)) <!> {
                    TypeCheckError.unifyError($0, in: copy expression)
                }

                return .list(unifiedType)
            } else {
                let firstType = try infer(elements.first)

                for element in elements.dropFirst() {
                    try check(element, against: firstType)
                }

                return .list(firstType)
            }

        case .cons(let head, let tail):
            if extensions.contains(.typeReconstruction) {
                let headType = try infer(head)
                let tailType = try infer(tail)

                return try unify(actual: .list(headType), expected: tailType) <!> {
                    TypeCheckError.unifyError($0, in: copy expression)
                }
            } else {
                let headType = try infer(head)
                try check(tail, against: .list(headType))

                return .list(headType)
            }

        case .head(let list):
            let listType = try infer(list)

            guard case .list(let elementType) = listType else {
                throw .notAList(actual: listType, in: copy expression)
            }

            return elementType

        case .tail(let list):
            let listType = try infer(list)

            guard case .list = listType else {
                throw .notAList(actual: listType, in: copy expression)
            }

            return listType

        case .isEmpty(let list):
            let listType = try infer(list)

            guard case .list = listType else {
                throw .notAList(actual: listType, in: copy expression)
            }

            return .bool

        // MARK: - #fixpoint-combinator
        case .fix(let generator):
            let generatorType = try infer(generator)

            guard case .function(let parameters, let result) = generatorType else {
                throw .notAFunction(actual: generatorType, in: copy expression)
            }

            guard let parameter = parameters.first,
                  parameters.count == 1 else {
                throw .incorrectArgumentsNumber(
                    actual: parameters.count,
                    expected: 1,
                    type: generatorType,
                    in: copy expression
                )
            }

            guard case .function = parameter else {
                throw .notAFunction(actual: parameter, in: copy expression)
            }

            if extensions.contains(.structuralSubtyping) {
                try parameter.requireSubtype(of: result) <!> TypeCheckError.subtypeError(in: expression)

                return parameter
            } else {
                return try unify(actual: parameter, expected: result) <!> {
                    TypeCheckError.unifyError($0, in: copy expression)
                }
            }

        // MARK: - #sequencing
        case .sequence(let first, let second):
            try check(first, against: .unit)

            return try infer(second)

        // MARK: - #references
        case .constMemory:
            throw .ambiguousReferenceType(in: copy expression)

        case .reference(let expression):
            return try .reference(infer(expression))

        case .dereference(let referenceExpression):
            let referenceType = try infer(referenceExpression)

            guard case .reference(let type) = referenceType else {
                throw .notAReference(actual: referenceType, in: copy expression)
            }

            return type

        case .assign(let variable, let assingee):
            let referenceType = try infer(variable)

            guard case .reference(let type) = referenceType else {
                throw .notAReference(actual: referenceType, in: copy expression)
            }

            try check(assingee, against: type)

            return .unit

        // MARK: - #panic
        case .panic:
            guard extensions.contains(.ambiguousTypeAsBottom) else {
                throw .ambiguousPanicType(in: copy expression)
            }

            return .bottom

        // MARK: - #exceptions
        case .throw(let exception):
            guard let exceptionType else {
                throw .exceptionTypeNotDeclared(in: copy expression)
            }

            try check(exception, against: exceptionType)

            guard extensions.contains(.ambiguousTypeAsBottom) else {
                throw .ambiguousThrowType(in: copy expression)
            }

            return .bottom

        case .tryWith(let attempted, let fallback):
            let attemptedType = try infer(attempted)

            if extensions.contains(.typeReconstruction) {
                let fallbackType = try infer(fallback)

                return try unify(actual: attemptedType, expected: fallbackType) <!> {
                    TypeCheckError.unifyError($0, in: copy expression)
                }
            } else {
                try check(fallback, against: attemptedType)

                return attemptedType
            }

        case .tryCatch(let attempted, let pattern, let handler):
            guard let exceptionType else {
                throw .exceptionTypeNotDeclared(in: copy expression)
            }

            let attemptedType = try infer(attempted)

            var localContext = self

            let bindings = try match(pattern, against: exceptionType)
                <!> TypeCheckError.patternError(in: copy expression)
            localContext.data.shadow(by: bindings)

            if extensions.contains(.typeReconstruction) {
                let handlerType = try localContext.infer(handler)

                return try unify(actual: attemptedType, expected: handlerType) <!> {
                    TypeCheckError.unifyError($0, in: copy expression)
                }
            } else {
                try localContext.check(handler, against: attemptedType)

                return attemptedType
            }

        // MARK: - #type-cast
        case .typeCast(let value, let rawType):
            _ = try infer(value)

            return try CanonicalType(from: rawType) <!> TypeCheckError.canonizeError

        // MARK: - #try-cast-as, #type-cast-patterns
        case .tryCastAs(let value, let rawType, let pattern, let success, let fallback):
            let localContext = try contextOfTryCastAs(
                value: value,
                rawType: rawType,
                pattern: pattern,
                in: expression
            )

            let successType = try localContext.infer(success)

            if extensions.contains(.typeReconstruction) {
                let fallbackType = try localContext.infer(fallback)

                return try unify(actual: fallbackType, expected: successType) <!> {
                    TypeCheckError.unifyError($0, in: copy expression)
                }
            } else {
                try check(fallback, against: successType)

                return successType
            }

        // MARK: - #universal-types
        case .typeAbstraction(let variables, let body):
            fatalError()

        case .typeApplication(let calle, let parameters):
            fatalError()
        }
    }
}
