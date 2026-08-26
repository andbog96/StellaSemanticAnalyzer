extension Context {
    func check(
        _ expression: consuming Expression,
        against expectedType: consuming CanonicalType
    ) throws(TypeCheckError) {
        switch (expression, expectedType) {
        // MARK: - STLC
        case (
            .abstraction(let actualParameters, let actualReturnExpression),
            .function(let expectedParameterTypes, let expectedReturnType)
        ) where actualParameters.count == expectedParameterTypes.count:
            let actualParameters = try (
                actualParameters.lazy.canonized() |> Function.Parameters.init(from:) <!> {
                    CanonizeError.contextError($0, in: .lambda(
                        parameters: actualParameters,
                        returnExpression: actualReturnExpression
                    ))
                }
            ) <!> TypeCheckError.canonizeError

            for (actual, expected) in zip(actualParameters.values, expectedParameterTypes) {
                try unify(actual: actual, expected: expected) <!> {
                    TypeCheckError.unifyError($0, in: copy expression)
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
                in: copy expression
            )
            
        case (.abstraction, _):
            throw .unexpectedLambda(expected: expectedType, in: copy expression)


        default:
            let actualType = try infer(expression)

            try unify(actual: actualType, expected: expectedType) <!> {
                TypeCheckError.unifyError($0, in: copy expression)
            }
        }
    }
}
