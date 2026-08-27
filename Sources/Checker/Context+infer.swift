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
            localContext.data.overlay(by: functionParameters)

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
            return try letContext(from: cases, in: expression)
                .infer(inExpression)

        // MARK: - #letrec-bindings
        case .letrec(let cases, let expression):
            return try letrecContext(from: cases)
                .infer(expression)

        // MARK: - #type-ascriptions
        case .typeAscription(let value, let rawType):
            let ascribedType = try CanonicalType(from: rawType) <!> TypeCheckError.canonizeError
            try check(value, against: ascribedType)

            return ascribedType

        // MARK: - #sum-types
        case .inl(let expression),
             .inr(let expression):
            _ = try infer(expression)
            
            throw .ambiguosSumType(in: copy expression)

        // MARK: - #variants
        case .variant(_, let data):
            _ = try data.map(infer)
            
            throw .ambiguosVariantType(in: copy expression)
            
        case .match(let matchedExpression, let cases):
            let matchContexts = try matchContexts(
                matchedExpression: matchedExpression,
                cases: cases,
                in: matchedExpression
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
                throw .ambiguosList(in: copy expression)
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

            return try unify(actual: parameter, expected: result) <!> {
                TypeCheckError.unifyError($0, in: copy expression)
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
            throw .ambiguousPanicType(in: copy expression)

        // MARK: - #exceptions
        case .throw(let exception):
            guard let exceptionType else {
                throw .exceptionTypeNotDeclared(in: copy expression)
            }

            try check(exception, against: exceptionType)
            
            throw .ambiguousThrowType(in: copy expression)

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

            let bindings = try match(pattern, against: exceptionType) <!> TypeCheckError.patternError
            localContext.data.overlay(by: bindings)

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
            return .unit
//            _ = try infer(value)
//            return try CanonicalType(from: rawType) <!> TypeCheckError.canonizeError
        
        // MARK: - #try-cast-as, #type-cast-patterns
        case .tryCastAs(let value, let rawType, let pattern, let success, with: let fallback):
            return .unit
//            _ = try infer(value)
//            let castType = try CanonicalType(from: rawType) <!> TypeCheckError.canonizeError
//            let bindings = try pattern.match(against: castType) <!> TypeCheckError.patternError
//            let successType = try overlaid(by: bindings).infer(success)
//            let fallbackType = try infer(fallback)
//            return try successType.unify(with: fallbackType) <!> {
//                TypeCheckError.unifyError($0, in: copy expression)
//            }
        
        // MARK: - #universal-types
        case .typeAbstraction(let variables, let expression):
            return .unit
//            return .forall(variables: variables, type: try infer(expression))

        case .typeApplication(let expression, let rawTypes):
            return .unit
//            let polymorphicType = try infer(expression)
//            guard case .forall(let variables, let body) = polymorphicType else {
//                throw .unifyError(
//                    .unexpectedType(actual: polymorphicType, expected: .forall(variables: [], type: .auto)),
//                    in: copy expression
//                )
//            }
//            guard variables.count == rawTypes.count else {
//                throw .incorrectArgumentsNumber(
//                    actual: rawTypes.count,
//                    expected: variables.count,
//                    type: polymorphicType,
//                    in: copy expression
//                )
//            }
//            let types = try rawTypes.map(CanonicalType.init(from:)) <!> TypeCheckError.canonizeError
//            return body.substituting(Dictionary(uniqueKeysWithValues: zip(variables, types)))
        }
    }
}

private extension CanonicalType {
    func substituting(_ substitutions: [Name: CanonicalType]) -> CanonicalType {
        switch self {
        case .variable(let name): substitutions[name] ?? self
        case .function(let parameters, let result):
            .function(from: parameters.map { $0.substituting(substitutions) }, to: result.substituting(substitutions))
        case .tuple(let elements): .tuple(elements: elements.map { $0.substituting(substitutions) })
        case .record(let fields): .record(fields: fields.mapValues { $0.substituting(substitutions) })
        case .sum(let left, let right): .sum(left: left.substituting(substitutions), right: right.substituting(substitutions))
        case .variant(let cases): .variant(cases: cases.mapValues { $0?.substituting(substitutions) })
        case .list(let element): .list(element.substituting(substitutions))
        case .reference(let type): .reference(type.substituting(substitutions))
        case .forall(let variables, let type):
            .forall(variables: variables, type: type.substituting(substitutions.filter { !variables.contains($0.key) }))
        default: self
        }
    }
}
