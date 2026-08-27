import Collections

extension Context {
    func check(
        _ expression: consuming Expression,
        against expectedType: borrowing CanonicalType
    ) throws(TypeCheckError) {
        switch (expression, copy expectedType) {
        // MARK: - STLC
        case (
            .abstraction(let actualParameters, let actualReturnExpression),
            .function(let expectedParameterTypes, let expectedReturnType)
        ) where actualParameters.count == expectedParameterTypes.count:
            let actualParameters = try (
                actualParameters.canonized() |> Function.Parameters.init(from:) <!> {
                    CanonizeError.parametersError($0, in: .lambda(
                        parameters: actualParameters,
                        returnExpression: actualReturnExpression
                    ))
                }
            ) <!> TypeCheckError.canonizeError

            for ((actualParameterName, actualParameterType), expectedParameterType) in zip(actualParameters, expectedParameterTypes) {
                try unify(actual: actualParameterType, expected: expectedParameterType) <!> { (_: UnifyError) in
                    TypeCheckError.unexpectedParameterType(
                        actual: actualParameterType,
                        expected: expectedParameterType,
                        name: actualParameterName,
                        callee: copy expectedType,
                        in: expression
                    )
                }
            }

            var localContext = self
            localContext.data.overlay(by: actualParameters)

            try localContext.check(actualReturnExpression, against: expectedReturnType)

        case (
            .abstraction(let actualParameters, _),
            .function(let expectedParameterTypes, let expectedReturnType)
        ):
            throw .unexpectedParametersNumber(
                actual: actualParameters.count,
                expected: expectedParameterTypes.count,
                type: expectedReturnType,
                in: expression
            )

        case (.abstraction, _):
            throw .unexpectedLambda(expected: copy expectedType, in: expression)

        // MARK: - Bool
        case (.if(let condition, let then, let `else`), _):
            try check(condition, against: .bool)
            try check(then, against: expectedType)
            try check(`else`, against: expectedType)

        // MARK: - Nat
        case (.natRec(let n, let zero, let step), _):
            try check(n, against: .nat)
            try check(zero, against: expectedType)
            try check(step, against: .function(
                from: [.nat],
                to: .function(from: [copy expectedType], to: copy expectedType)
            ))

        // MARK: - #pairs, #tuples
        case (
            .tuple(let actualElements),
            .tuple(let expectedElements)
        ) where actualElements.count == expectedElements.count:
            for (actual, expected) in zip(actualElements, expectedElements) {
                try check(actual, against: expected)
            }

        case (
            .tuple(let actualElements),
            .tuple(let expectedElements)
        ):
            throw .unexpectedTupleLength(
                actual: actualElements.count,
                expected: expectedElements.count,
                type: copy expectedType,
                in: expression
            )

        case (.tuple, _):
            throw .unexpectedTuple(expected: copy expectedType, in: expression)

        // MARK: - #records
        case (
            .record(let actualFields),
            .record(let expectedFields)
        ):
            let actualLabels = try OrderedSet(actualFields.lazy.map(\.label)) {
                TypeCheckError.duplicateRecordFields($0, in: expression)
            }

            let expectedLabels = Set(expectedFields.keys)
            let missingLabels = expectedLabels.subtracting(actualLabels)
            guard missingLabels.isEmpty else {
                throw .missingRecordFields(
                    Array(missingLabels),
                    for: copy expectedType,
                    in: expression
                )
            }

            let unexpectedLabels = actualLabels.subtracting(expectedLabels)
            guard unexpectedLabels.isEmpty else {
                throw .unexpectedRecordFields(
                    Array(unexpectedLabels),
                    for: copy expectedType,
                    in: expression
                )
            }

            for (label, expression) in actualFields {
                if let expectedType = expectedFields[label] {
                    try check(expression, against: expectedType)
                }
            }

        case (.record, _):
            throw .unexpectedRecord(expected: copy expectedType, in: expression)

        // MARK: - #let-patterns
        case (.let(let cases, let inExpression), _):
            try letContext(from: cases, in: expression)
                .check(inExpression, against: expectedType)

        // MARK: - #letrec-bindings
        case (.letrec(let cases, let inExpression), _):
            try letrecContext(from: cases)
                .check(inExpression, against: expectedType)

        // MARK: - #type-ascriptions
        case (.typeAscription, _):
            let ascribedType = try infer(expression)

            try unify(actual: ascribedType, expected: expectedType) <!> {
                TypeCheckError.unifyError($0, in: expression)
            }

        // MARK: - #sum-types
        case (.inl(let value), .sum(let sumType, _)),
             (.inr(let value), .sum(_, let sumType)):
            try check(value, against: sumType)

        case (.inl, _),
             (.inr, _):
            throw .unexpectedInjection(expected: copy expectedType, in: expression)

        // MARK: - #variants
        case (
            .variant(let label, let actualData),
            .variant(let expectedCases)
        ):
            guard let expectedData = expectedCases[label] else {
                throw .unexpectedVariantLabel(label, for: copy expectedType, in: expression)
            }

            switch (actualData, expectedData) {
            case (nil, nil):
                break

            case (let actualData?, let expectedData?):
                try check(actualData, against: expectedData)

            case (_?, nil):
                throw .unexpectedData(for: label, expected: copy expectedType, in: expression)

            case (nil, let expectedData?):
                throw .missingData(for: label, type: expectedData, expected: copy expectedType, in: expression)
            }

        case (.variant, _):
            throw .unexpectedVariant(expected: copy expectedType, in: expression)

        case (.match(let matchedExpression, let cases), _):
            let matchContexts = try matchContexts(
                matchedExpression: matchedExpression,
                cases: cases,
                in: expression
            )

            for (localContext, value) in matchContexts {
                try localContext.check(value, against: expectedType)
            }

        // MARK: - #lists
        case (.list(let elements), .list(let elementsType)):
            for element in elements {
                try check(element, against: elementsType)
            }

        case (.list, _):
            throw .unexpectedList(expected: copy expectedType, in: expression)

        case (.cons(let head, let tail), .list(let elementType)):
            try check(head, against: elementType)
            try check(tail, against: expectedType)

        case (.cons, _):
            throw .unexpectedList(expected: copy expectedType, in: expression)

        case (.head(let list), _):
            try check(list, against: .list(copy expectedType))

        case (.tail(let list), .list):
            try check(list, against: expectedType)

        // MARK: - #fixpoint-combinator
        case (.fix(let generator), _):
            try check(
                generator,
                against: .function(from: [copy expectedType], to: copy expectedType)
            )

        // MARK: - #sequencing
        case (.sequence(let first, let second), _):
            try check(first, against: .unit)
            try check(second, against: expectedType)

        // MARK: - #references
        case (.constMemory, .reference):
            break

        case (.constMemory, _):
            throw .unexpectedMemoryAddress(in: copy expression)

        case (.reference(let value), .reference(let valueType)):
            try check(value, against: valueType)

        case (.reference, _):
            throw .unexpectedReference(expected: copy expectedType, in: expression)

        case (.dereference(let reference), _):
            try check(reference, against: .reference(copy expectedType))

        // MARK: - #panic
        case (.panic, _):
            break

        // MARK: - #exceptions
        case (.throw(let exception), _):
            guard let exceptionType else {
                throw .exceptionTypeNotDeclared(in: expression)
            }

            try check(exception, against: exceptionType)

        case (.tryWith(let attempted, let fallback), _):
            try check(attempted, against: expectedType)
            try check(fallback, against: copy expectedType)

        case (.tryCatch(let attempted, let pattern, let handler), _):
            guard let exceptionType else {
                throw .exceptionTypeNotDeclared(in: expression)
            }

            try check(attempted, against: expectedType)
            
            var localContext = self

            let bindings = try match(pattern, against: exceptionType) <!> TypeCheckError.patternError
            localContext.data.overlay(by: bindings)

            try localContext.check(handler, against: expectedType)

        default:
            let actualType = try infer(expression)

            try unify(actual: actualType, expected: expectedType) <!> {
                TypeCheckError.unifyError($0, in: expression)
            }
        }
    }
}

extension Context {
    func letContext(
        from cases: [(pattern: Pattern, value: Expression)],
        in expression: borrowing Expression
    ) throws(TypeCheckError) -> Context {
        var localContext = self
        var usedBindings = [] as Set<Name>

        for (pattern, value) in cases {
            let valueType = try localContext.infer(value)
            let bindings = try match(pattern, against: valueType) <!> TypeCheckError.patternError

            let duplicateBindings = usedBindings.intersection(bindings.names)
            guard duplicateBindings.isEmpty else {
                throw .patternError(.duplicateLetBinding(Array(duplicateBindings), in: pattern))
            }

            localContext.data.overlay(by: bindings)
            usedBindings.formUnion(bindings.names)

            do {
                try valueType.checkExhaustiveness(of: single(pattern))
            } catch {
                throw .nonexhaustiveLetPatterns(for: copy expression, missing: error.missingPatterns)
            }
        }

        return localContext
    }

    func letrecContext(
        from cases: [(pattern: Pattern, value: Expression)]
    ) throws(TypeCheckError) -> Context {
        guard let (pattern, value) = cases.first else {
            throw .unsupported(message: "#letrec-many-bindings is not supported")
        }

        guard case .ascription(let subpattern, let rawType) = pattern else {
            throw .unsupported(code: "ERROR_AMBIGUOUS_PATTERN_TYPE")
        }

        let valueType = try CanonicalType(from: rawType) <!> TypeCheckError.canonizeError

        var localContext = self

        let bindings = try match(subpattern, against: valueType) <!> TypeCheckError.patternError
        localContext.data.overlay(by: bindings)

        try localContext.check(value, against: valueType)

        return localContext
    }

    func matchContexts(
        matchedExpression: Expression,
        cases: [(pattern: Pattern, value: Expression)],
        in expression: borrowing Expression
    ) throws(TypeCheckError) -> NonEmpty<[(localContext: Context, value: Expression)]> {
        guard let cases = NonEmpty(rawValue: cases) else {
            throw .illegalEmptyMatch(in: copy expression)
        }

        let matchedType = try infer(matchedExpression)

        do {
            try matchedType.checkExhaustiveness(of: cases.map(\.pattern))
        } catch {
            throw .nonexhaustiveMatchPatterns(for: copy expression, missing: error.missingPatterns)
        }

        return try cases.map { pattern, value throws(TypeCheckError) in
            var localContext = self

            let bindings = try match(pattern, against: matchedType) <!> TypeCheckError.patternError
            localContext.data.overlay(by: bindings)

            return (localContext: localContext, value: value)
        }
    }
}
