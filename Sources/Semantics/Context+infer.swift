import Collections

extension Context {
    func infer(_ expression: borrowing Expression) throws(SemanticError) -> CanonicalType {
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
            ) <!> SemanticError.canonizeError

            var localContext = self
            localContext.data.shadow(by: functionParameters)

            let returnType = try localContext.infer(returnExpression)

            return .function(
                from: Array.init § functionParameters.values,
                to: returnType
            )

        case .application(let callee, let arguments):
            let calleeType = solver.resolve(try infer(callee))

            let parameterTypes: [CanonicalType]
            let returnType: CanonicalType

            if case let .function(parameters, result) = calleeType {
                parameterTypes = parameters
                returnType = result
            } else if extensions.contains(.typeReconstruction), case .auto = calleeType {
                parameterTypes = arguments.map { _ in .auto(.new) }
                returnType = .auto(.new)

                try solver.unify(
                    actual: calleeType,
                    expected: .function(from: parameterTypes, to: returnType)
                ) <!> SemanticError.unifyError(in: expression)
            } else {
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

            return solver.resolve(returnType)

        // MARK: - Bool
        case .constTrue,
             .constFalse:
            return .bool

        case .if(let condition, let then, let `else`):
            try check(condition, against: .bool)

            if extensions.contains(.typeReconstruction) {
                let thenType = try infer(then)
                let elseType = try infer(`else`)

                return try solver.unify(actual: thenType, expected: elseType)
                    <!> SemanticError.unifyError(in: copy expression)
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

            try check(step, against: .function(
                from: [.nat],
                to: .function(from: [zeroType], to: zeroType)
            ))

            return zeroType

        // MARK: - #unit-type
        case .constUnit:
            return .unit

        // MARK: - #pairs, #tuples
        case .tuple(let elements):
            let types = try elements.map(infer)

            return .tuple(elements: types)

        case .dotTuple(let tuple, let index):
            var tupleType = solver.resolve(try infer(tuple))

            if extensions.contains(.typeReconstruction),
               case .auto = tupleType,
               index.isPairIndex {
                let elements = [CanonicalType.auto(.new), .auto(.new)]

                tupleType = try solver.unify(actual: tupleType, expected: .tuple(elements: elements))
                    <!> SemanticError.unifyError(in: expression)
            }

            guard case .tuple(let elements) = tupleType else {
                throw .notATuple(actual: tupleType, in: copy expression)
            }

            guard let type = elements[safe: index.fromZero] else {
                throw .tupleIndexOutOfBounds(index: index, type: tupleType, in: copy expression)
            }

            return type

        // MARK: - #records
        case .record(let fields):
            return try CanonicalType.record § OrderedDictionary(
                uniqueKeysWithValues: fields,
                rejectingDuplicateKeysWith: {
                    SemanticError.duplicateRecordFields($0, in: copy expression)
                }
            )
            .mapValues(try: infer)

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
        case .letrec(let cases, let inExpression):
            return try contextOfLetrec(cases: cases, in: expression)
                .infer(inExpression)

        // MARK: - #type-ascriptions
        case .typeAscription(let value, let rawType):
            let ascribedType = try CanonicalType(from: rawType) <!> SemanticError.canonizeError
            try check(value, against: ascribedType)

            return ascribedType

        // MARK: - #sum-types
        case .inl(let left):
            let leftType = try infer(left)

            return if extensions.contains(.ambiguousTypeAsBottom) {
                .sum(left: leftType, right: .bottom)
            } else if extensions.contains(.typeReconstruction) {
                .sum(left: leftType, right: .auto(.new))
            } else {
                throw .ambiguousSumType(in: copy expression)
            }

        case .inr(let right):
            let rightType = try infer(right)

            return if extensions.contains(.ambiguousTypeAsBottom) {
                .sum(left: .bottom, right: rightType)
            } else if extensions.contains(.typeReconstruction) {
                .sum(left: .auto(.new), right: rightType)
            } else {
                throw .ambiguousSumType(in: copy expression)
            }

        // MARK: - #variants
        case .variant(let label, let payload):
            guard extensions.contains(.structuralSubtyping) else {
                throw .ambiguousVariantType(in: copy expression)
            }

            let payloadType = try payload.map(infer)

            return .variant(cases: [label: payloadType])

        case .match(let value, let cases):
            let matchContexts = try contextsOfMatch(
                value: value,
                cases: cases,
                in: expression
            )

            if extensions.contains(.typeReconstruction) {
                let caseTypes = try matchContexts.map { localContext, value throws(SemanticError) in
                    try localContext.infer(value)
                }

                let unifiedType = try solver.unify(caseTypes) <!> SemanticError.unifyError(in: expression)

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
                return if extensions.contains(.ambiguousTypeAsBottom) {
                    .list(.bottom)
                } else if extensions.contains(.typeReconstruction) {
                    .list(.auto(.new))
                } else {
                    throw .ambiguousListType(in: copy expression)
                }
            }

            if extensions.contains(.typeReconstruction) {
                let types = try elements.map(infer)

                let unifiedType = try solver.unify(types) <!> SemanticError.unifyError(in: expression)

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

                return try solver.unify(actual: .list(headType), expected: tailType)
                    <!> SemanticError.unifyError(in: expression)
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

            return try constrain(parameter, to: result) <!> SemanticError.constrainError(in: expression)

        // MARK: - #sequencing
        case .sequence(let first, let second):
            try check(first, against: .unit)

            return try infer(second)

        // MARK: - #references
        case .constMemory:
            throw .ambiguousReferenceType(in: copy expression)

        case .reference(let expression):
            return .reference(try infer(expression))

        case .dereference(let reference):
            let referenceType = try infer(reference)

            guard case .reference(let dereferencedType) = referenceType else {
                throw .notAReference(actual: referenceType, in: copy expression)
            }

            return dereferencedType

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

                return try solver.unify(actual: attemptedType, expected: fallbackType)
                    <!> SemanticError.unifyError(in: expression)
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
                <!> SemanticError.patternError(in: expression)
            localContext.data.shadow(by: bindings)

            if extensions.contains(.typeReconstruction) {
                let handlerType = try localContext.infer(handler)

                return try solver.unify(actual: attemptedType, expected: handlerType)
                    <!> SemanticError.unifyError(in: expression)
            } else {
                try localContext.check(handler, against: attemptedType)

                return attemptedType
            }

        // MARK: - #type-cast
        case .typeCast(let value, let rawType):
            _ = try infer(value)

            return try CanonicalType(from: rawType) <!> SemanticError.canonizeError

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

                return try solver.unify(actual: fallbackType, expected: successType)
                    <!> SemanticError.unifyError(in: expression)
            } else {
                try check(fallback, against: successType)

                return successType
            }

        // MARK: - #universal-types
        case .typeAbstraction(let variables, let body):
            let variables = try OrderedSet(
                variables,
                rejectingDuplicatesWith: ParametersError.duplicateTypeParameter
            ) <!> {
                SemanticError.canonizeError(.parametersError($0, in: .lambda(
                    typeVariables: variables,
                    returnExpression: body
                )))
            }

            var localContext = self
            localContext.typeVariables.formUnion(variables)
            let bodyType = try localContext.infer(body)

            return bodyType.abstracting(variables)

        case .typeApplication(let callee, let parameters):
            let calleeType = solver.resolve(try infer(callee))
            guard case .forall(let variableCount, let body) = calleeType else {
                throw .notAGenericFunction(actual: calleeType, in: copy expression)
            }

            let parameters = try parameters.map(CanonicalType.init(from:)) <!> SemanticError.canonizeError
            guard variableCount == parameters.count else {
                throw .incorrectNumberOfTypeArguements(
                    actual: parameters.count,
                    expected: variableCount,
                    type: calleeType,
                    in: copy expression
                )
            }

            let freeVariables = Array.init § parameters
                .lazy
                .map { $0.freeVariables(except: typeVariables) }
                .reduce([], Set.union)
            guard freeVariables.isEmpty else {
                throw .undefinedTypeVariables(freeVariables)
            }

            return body.instantiating(parameters)
        }
    }
}
