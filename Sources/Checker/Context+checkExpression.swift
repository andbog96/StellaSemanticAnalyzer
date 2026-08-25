extension Context {
    func check(
        _ expression: consuming Expression,
        against expected: consuming CanonicalType
    ) throws(TypeCheckError) {
        switch (expression, expected) {
        case (
            .abstraction(let actualParameters, let actualReturnExpression),
            .function(let expectedParameterTypes, let expectedReturnType)
        ) where actualParameters.count == expectedParameterTypes.count:
            let functionParameters = try (
                actualParameters.lazy.canonized() |> Function.Parameters.init(from:) <!> { error in
                    CanonizeError.contextError(error, in: .lambda(
                        parameters: actualParameters,
                        returnExpression: actualReturnExpression
                    ))
                }
            ) <!> TypeCheckError.canonizeError

            for (actual, expected) in zip(functionParameters.values, expectedParameterTypes) {
                try actual.unify(with: expected) <!> { error in
                    TypeCheckError.unifyError(error, in: copy expression)
                }
            }
            
            var localContext = self
            localContext.data.overlay(by: functionParameters)
            
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
            throw .unexpectedLambda(expected: expected, in: copy expression)

//        case let (
//            .tuple(elements),
//            .tuple(types)
//        ) where elements.count == types.count:
//            for (element, type) in zip(elements, types) {
//                try check(element, expected: type, extensions: extensions)
//            }
//            
//        case let (.tuple(elements), .tuple(types)):
//            throw .unexpectedTupleLength(
//                actual: elements.count,
//                expected: types.count,
//                type: expected,
//                in: expression
//            )
//            
//        case (.tuple, _):
//            throw .unexpectedTuple(expected: expected, in: expression)
//
//        case let (.record(actualFields), .record(expectedFields)):
//            break
//            
//        case (.record, _):
//            throw .unexpectedRecord(expected: expected, in: expression)
            
        default:
            let actual = try infer(expression)

            if extensions.contains(.typeReconstruction) {
                try actual.unify(with: expected) <!> { error in
                    TypeCheckError.unifyError(error, in: copy expression)
                }
            } else {
                guard actual == expected else {
                    throw .unexpectedType(actual: actual, expected: expected, for: copy expression)
                }
            }
        }
    }
}
