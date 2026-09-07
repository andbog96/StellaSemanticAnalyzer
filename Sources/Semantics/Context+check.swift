import Collections

extension Context {
    func check(
        _ expression: consuming Expression,
        against expectedType: borrowing CanonicalType
    ) throws(SemanticError) {
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
            ) <!> SemanticError.canonizeError

            for ((actualParameterName, actualParameterType), expectedParameterType) in zip(actualParameters, expectedParameterTypes) {
                do {
                    try constrain(expectedParameterType, to: actualParameterType)
                        <!> SemanticError.constrainError(in: expression)
                } catch SemanticError.unexpectedType {
                    throw SemanticError.unexpectedParameterType(
                        actual: actualParameterType,
                        expected: expectedParameterType,
                        name: actualParameterName,
                        callee: copy expectedType,
                        in: expression
                    )
                }
            }

            var localContext = self
            localContext.data.shadow(by: actualParameters)

            try localContext.check(actualReturnExpression, against: expectedReturnType)

        case (
            .abstraction(let actualParameters, _),
            .function(let expectedParameterTypes, _)
        ):
            throw .unexpectedParametersNumber(
                actual: actualParameters.count,
                expected: expectedParameterTypes.count,
                type: copy expectedType,
                in: expression
            )

        case (.abstraction, _) where !extensions.contains(.typeReconstruction):
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
        ) where !extensions.contains(.typeReconstruction):
            throw .unexpectedTupleLength(
                actual: actualElements.count,
                expected: expectedElements.count,
                type: copy expectedType,
                in: expression
            )

        case (.tuple, _) where !extensions.contains(.typeReconstruction):
            throw .unexpectedTuple(expected: copy expectedType, in: expression)

        // MARK: - #records
        case (
            .record(let actualFields),
            .record(let expectedFields)
        ):
            let actualLabels = try OrderedSet(actualFields.lazy.map(\.label)) {
                SemanticError.duplicateRecordFields($0, in: expression)
            }

            if !extensions.contains(.structuralSubtyping) {
                let unexpectedLabels = actualLabels.subtracting(expectedFields.keys)
                guard unexpectedLabels.isEmpty else {
                    throw .unexpectedRecordFields(
                        Array(unexpectedLabels),
                        for: copy expectedType,
                        in: expression
                    )
                }
            }

            let missingLabels = Set(expectedFields.keys).subtracting(actualLabels)
            if !missingLabels.isEmpty {
                throw .missingRecordFields(
                    Array(missingLabels),
                    for: copy expectedType,
                    in: expression
                )
            }

            for (label, actualValue) in actualFields {
                if let expectedType = expectedFields[label] {
                    try check(actualValue, against: expectedType)
                }
            }

        case (.record, _) where !extensions.contains(.typeReconstruction):
            throw .unexpectedRecord(expected: copy expectedType, in: expression)

        // MARK: - #let-patterns
        case (.let(let cases, let inExpression), _):
            try contextOfLet(cases: cases, in: expression)
                .check(inExpression, against: expectedType)

        // MARK: - #letrec-bindings
        case (.letrec(let cases, let inExpression), _):
            try contextOfLetrec(cases: cases, in: expression)
                .check(inExpression, against: expectedType)

        // MARK: - #sum-types
        case (.inl(let value), .sum(let sumType, _)),
             (.inr(let value), .sum(_, let sumType)):
            try check(value, against: sumType)

        case (.inl, _) where !extensions.contains(.typeReconstruction),
             (.inr, _) where !extensions.contains(.typeReconstruction):
            throw .unexpectedInjection(expected: copy expectedType, in: expression)

        // MARK: - #variants
        case (
            .variant(let label, let actualData),
            .variant(let expectedCases)
        ):
            guard let expectedData = expectedCases[label] else {
                throw .unexpectedVariantLabels([label], for: copy expectedType, in: expression)
            }

            switch (actualData, expectedData) {
            case (nil, nil):
                break

            case (_?, nil):
                throw .unexpectedData(for: label, expected: copy expectedType, in: expression)

            case (nil, let expectedData?):
                throw .missingData(for: label, type: expectedData, expected: copy expectedType, in: expression)

            case (let actualData?, let expectedData?):
                try check(actualData, against: expectedData)
            }

        case (.variant, _):
            throw .unexpectedVariant(expected: copy expectedType, in: expression)

        case (.match(let value, let cases), _):
            let localContexts = try contextsOfMatch(
                value: value,
                cases: cases,
                in: expression
            )

            for (localContext, value) in localContexts {
                try localContext.check(value, against: expectedType)
            }

        // MARK: - #lists
        case (.list(let elements), .list(let elementsType)):
            for element in elements {
                try check(element, against: elementsType)
            }

        case (.list, _) where !extensions.contains(.typeReconstruction) && expectedType != .top:
            throw .unexpectedList(expected: copy expectedType, in: expression)

        case (.cons(let head, let tail), .list(let elementType)):
            try check(head, against: elementType)
            try check(tail, against: expectedType)

        case (.cons, _) where !extensions.contains(.typeReconstruction) && expectedType != .top:
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
        case (.constMemory, .top),
             (.constMemory, .reference):
            break

        case (.constMemory, _):
            throw .unexpectedMemoryAddress(in: copy expression)

        case (.reference(let value), .reference(let valueType)):
            try check(value, against: valueType)

        case (.reference, _) where expectedType != .top:
            throw .unexpectedReference(expected: copy expectedType, in: expression)

        case (.dereference(let reference), _):
            do {
                try check(reference, against: .reference(copy expectedType))
            } catch .subtypeError(.unexpectedSubtype(.reference(let actual), of: .reference(let expected)), _) {
                try actual.requireSubtype(of: expected) <!> SemanticError.subtypeError(in: expression)
            }

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

            let bindings = try match(pattern, against: exceptionType)
                <!> SemanticError.patternError(in: expression)
            localContext.data.shadow(by: bindings)

            try localContext.check(handler, against: expectedType)

        // MARK: - #try-cast-as, #type-cast-patterns
        case (.tryCastAs(let value, let rawType, let pattern, let success, let fallback), _):
            let localContext = try contextOfTryCastAs(
                value: value,
                rawType: rawType,
                pattern: pattern,
                in: expression
            )

            try localContext.check(success, against: expectedType)

            try check(fallback, against: expectedType)

        default:
            let actualType = try infer(expression)

            try constrain(actualType, to: expectedType) <!> SemanticError.constrainError(in: expression)
        }
    }
}

extension Context {
    func contextOfLet(
        cases: [(pattern: Pattern, value: Expression)],
        in expression: borrowing Expression
    ) throws(SemanticError) -> Context {
        var localContext = self
        var usedBindings = [] as Set<ValueName>

        for (pattern, value) in cases {
            var valueType = localContext.solver.resolve(try localContext.infer(value))
            if valueType.containsAutoType {
                let inferredPatternTypes = try cases
                    .map(\.pattern)
                    .compactMap(inferredType(from:))
                    <!> SemanticError.patternError(in: expression)

                if let inferredPatternTypes = NonEmpty(rawValue: inferredPatternTypes) {
                    let inferredPatternType = try solver.unify(inferredPatternTypes)
                        <!> SemanticError.unifyError(in: expression)

                    valueType = try solver.unify(
                        actual: valueType,
                        expected: inferredPatternType
                    ) <!> SemanticError.unifyError(in: expression)
                    valueType = solver.resolve(valueType)
                }
            }

            if valueType.containsAutoType {
                switch valueType {
                case .sum,
                     .tuple,
                     .record,
                     .list:
                    break

                case .auto where cases.allSatisfy(\.pattern.isVariable):
                    break

                default:
                    throw .ambiguousType(in: copy expression)
                }
            }

            let bindings = try match(pattern, against: valueType)
                <!> SemanticError.patternError(in: expression)

            let duplicateBindings = usedBindings.intersection(bindings.names)
            guard duplicateBindings.isEmpty else {
                throw .patternError(
                    .duplicateLetBinding(Array(duplicateBindings), in: pattern),
                    in: copy expression
                )
            }

            localContext.data.shadow(by: bindings)
            usedBindings.formUnion(bindings.names)

            do {
                try valueType.checkExhaustiveness(of: single(pattern))
            } catch {
                throw .nonexhaustiveLetPatterns(for: copy expression, missing: error.missingPatterns)
            }
        }

        return localContext
    }

    func contextOfLetrec(
        cases: [(pattern: Pattern, value: Expression)],
        in expression: borrowing Expression
    ) throws(SemanticError) -> Context {
        guard let (pattern, value) = cases.first else {
            throw .unsupported(message: "#letrec-many-bindings is not supported")
        }

        let valueType = try annotatedType(of: pattern) <!> SemanticError.patternError(in: expression)

        var localContext = self

        let bindings = try match(pattern, against: valueType) <!> SemanticError.patternError(in: expression)
        localContext.data.shadow(by: bindings)

        try localContext.check(value, against: valueType)

        return localContext
    }

    func contextsOfMatch(
        value: Expression,
        cases: [(pattern: Pattern, value: Expression)],
        in expression: borrowing Expression
    ) throws(SemanticError) -> NonEmpty<[(localContext: Context, value: Expression)]> {
        guard let cases = NonEmpty(rawValue: cases) else {
            throw .illegalEmptyMatch(in: copy expression)
        }

        var matchedType = solver.resolve(try infer(value))

        if matchedType.containsAutoType {
            let inferredPatternTypes = try cases
                .map(\.pattern)
                .compactMap(inferredType(from:))
                <!> SemanticError.patternError(in: expression)

            if let inferredPatternTypes = NonEmpty(rawValue: inferredPatternTypes) {
                let inferredPatternType = try solver.unify(inferredPatternTypes)
                    <!> SemanticError.unifyError(in: expression)

                matchedType = try solver.unify(
                    actual: matchedType,
                    expected: inferredPatternType
                ) <!> SemanticError.unifyError(in: expression)
                matchedType = solver.resolve(matchedType)
            }
        }

        if matchedType.containsAutoType {
            switch matchedType {
            case .sum,
                 .tuple,
                 .record,
                 .list:
                break

            case .auto where cases.allSatisfy(\.pattern.isVariable):
                break

            default:
                throw .ambiguousType(in: copy expression)
            }
        }

        let result = try cases.map { pattern, value throws(SemanticError) in
            var localContext = self

            let bindings = try match(pattern, against: matchedType) <!> SemanticError.patternError(in: expression)
            localContext.data.shadow(by: bindings)

            return (localContext: localContext, value: value)
        }

        do {
            try matchedType.checkExhaustiveness(of: cases.map(\.pattern))
        } catch {
            throw .nonexhaustiveMatchPatterns(for: copy expression, missing: error.missingPatterns)
        }

        return result
    }

    func contextOfTryCastAs(
        value: Expression,
        rawType: RawType,
        pattern: Pattern,
        in expression: borrowing Expression
    ) throws(SemanticError) -> Context {
        let castType = try infer(.typeCast(value: value, as: rawType))

        var localContext = self

        let bindings = try match(pattern, against: castType) <!> SemanticError.patternError(in: expression)
        localContext.data.shadow(by: bindings)

        return localContext
    }
}
