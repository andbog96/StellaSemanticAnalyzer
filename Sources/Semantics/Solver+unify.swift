extension Solver {
    mutating func unify(_ types: NonEmpty<[CanonicalType]>) throws(UnifyError) -> CanonicalType {
        try types.fold { result, next throws(UnifyError) in
            try unify(actual: result, expected: next)
        }
    }

    @discardableResult
    mutating func unify(actual: consuming CanonicalType, expected: borrowing CanonicalType) throws(UnifyError) -> CanonicalType {
        let actual = resolve(actual)
        let expected = resolve(copy expected)
        let unexpectedTypeError = UnifyError.unexpectedType(actual: actual, expected: copy expected)

        if actual == expected {
            return actual
        }

        switch (actual, expected) {
        case (.auto(let identifier), let type),
             (let type, .auto(let identifier)):
            guard !contains(identifier, in: type) else {
                throw .occursCheckInfiniteType
            }

            substitutions[identifier] = type

            return type

        case (.function(let actualFrom, let actualTo), .function(let expectedFrom, let expectedTo)):
            guard actualFrom.count == expectedFrom.count else { throw unexpectedTypeError }
            var parameters: [CanonicalType] = []
            for (actualParameter, expectedParameter) in zip(actualFrom, expectedFrom) {
                parameters.append(try unify(actual: actualParameter, expected: expectedParameter))
            }
            return try .function(from: parameters, to: unify(actual: actualTo, expected: expectedTo))

        case (.tuple(let actualElements), .tuple(let expectedElements)):
            guard actualElements.count == expectedElements.count else {
                throw .unexpectedTupleLength(actual: actualElements.count, expected: expectedElements.count, type: expected)
            }
            var elements: [CanonicalType] = []
            for (actualElement, expectedElement) in zip(actualElements, expectedElements) {
                elements.append(try unify(actual: actualElement, expected: expectedElement))
            }
            return .tuple(elements: elements)

        case (.record(let actualFields), .record(let expectedFields)):
            guard actualFields.keys == expectedFields.keys else { throw unexpectedTypeError }
            var fields: [RecordLabel: CanonicalType] = [:]
            for (key, actualField) in actualFields {
                guard let expectedField = expectedFields[key] else { throw unexpectedTypeError }
                fields[key] = try unify(actual: actualField, expected: expectedField)
            }
            return .record(fields: fields)

        case (.sum(let actualLeft, let actualRight), .sum(let expectedLeft, let expectedRight)):
            return try .sum(left: unify(actual: actualLeft, expected: expectedLeft), right: unify(actual: actualRight, expected: expectedRight))

        case (.list(let actualElement), .list(let expectedElement)):
            return try .list(unify(actual: actualElement, expected: expectedElement))

        case (.reference(let actualValue), .reference(let expectedValue)):
            return try .reference(unify(actual: actualValue, expected: expectedValue))

        case (.forall(let actualVariables, let actualBody), .forall(let expectedVariables, let expectedBody))
            where actualVariables.count == expectedVariables.count:
            let renaming = Dictionary(uniqueKeysWithValues: zip(
                actualVariables,
                expectedVariables.map(CanonicalType.variable)
            ))
            return try .forall(
                variables: expectedVariables,
                body: unify(actual: actualBody.substituting(renaming), expected: expectedBody)
            )

        default:
            throw unexpectedTypeError
        }
    }
}

enum UnifyError: Error {
    case occursCheckInfiniteType

    case unexpectedTupleLength(actual: Int, expected: Int, type: CanonicalType)
    case unexpectedType(actual: CanonicalType, expected: CanonicalType)
}
