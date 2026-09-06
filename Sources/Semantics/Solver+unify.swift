extension Solver {
    mutating func unify(_ types: NonEmpty<[CanonicalType]>) throws(UnifyError) -> CanonicalType {
        try types.fold { result, next throws(UnifyError) in
            try unify(actual: result, expected: next)
        }
    }

    @discardableResult
    mutating func unify(
        actual: consuming CanonicalType,
        expected: borrowing CanonicalType
    ) throws(UnifyError) -> CanonicalType {
        let actual = resolve(actual)
        let expected = resolve(copy expected)

        if actual == expected {
            return actual
        }

        switch (actual, expected) {
        case (.auto(let identifier), let type),
             (let type, .auto(let identifier)):
            guard !contains(identifier, in: type) else {
                throw .occursCheckInfiniteType(actual: actual, expected: expected)
            }

            substitutions[identifier] = type

            return type

        case (
            .forall(let actualVariables, let actualBody),
            .forall(let expectedVariables, let expectedBody)
        ) where actualVariables.count == expectedVariables.count:
            let renaming = Dictionary.init(uniqueKeysWithValues:) § zip(
                actualVariables,
                expectedVariables.map(CanonicalType.variable)
            )

            return .forall(
                variables: expectedVariables,
                body: try unify(actual: actualBody.substituting(renaming), expected: expectedBody)
            )

        case (
            .function(let actualFrom, let actualTo),
            .function(let expectedFrom, let expectedTo)
        ) where actualFrom.count == expectedFrom.count:
            let parameters = try zip(actualFrom, expectedFrom)
                .map { actualParameter, expectedParameter throws(UnifyError) in
                    try unify(actual: actualParameter, expected: expectedParameter)
                }

            return .function(
                from: parameters,
                to: try unify(actual: actualTo, expected: expectedTo)
            )

        case (
            .tuple(let actualElements),
            .tuple(let expectedElements)
        ) where actualElements.count == expectedElements.count:
            return try CanonicalType.tuple(elements:) § zip(actualElements, expectedElements)
                .map { actualElement, expectedElement throws(UnifyError) in
                    try unify(actual: actualElement, expected: expectedElement)
                }

        case (.tuple(let actualElements), .tuple(let expectedElements)):
            throw .unexpectedTupleLength(
                actual: actualElements.count,
                expected: expectedElements.count,
                type: expected
            )

        case (
            .record(let actualFields),
            .record(let expectedFields)
        ) where actualFields.keys == expectedFields.keys:
            return try CanonicalType.record(fields:)
            § Dictionary.init(uniqueKeysWithValues:)
            § actualFields.map { key, actualField throws(UnifyError) in
                guard let expectedField = expectedFields[key] else {
                    assertionFailure()
                }

                return (key, try unify(actual: actualField, expected: expectedField))
            }

        case (
            .sum(let actualLeft, let actualRight),
            .sum(let expectedLeft, let expectedRight)
        ):
            return .sum(
                left: try unify(actual: actualLeft, expected: expectedLeft),
                right: try unify(actual: actualRight, expected: expectedRight)
            )

        case (.list(let actualElement), .list(let expectedElement)):
            return .list(try unify(actual: actualElement, expected: expectedElement))

        case (.reference(let actualValue), .reference(let expectedValue)):
            return .reference(try unify(actual: actualValue, expected: expectedValue))

        default:
            throw .unexpectedType(actual: actual, expected: copy expected)
        }
    }
}

enum UnifyError: Error {
    case occursCheckInfiniteType(actual: CanonicalType, expected: CanonicalType)

    case unexpectedTupleLength(actual: Int, expected: Int, type: CanonicalType)
    case unexpectedType(actual: CanonicalType, expected: CanonicalType)
}
