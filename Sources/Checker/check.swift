extension Program {
    func check() throws(TypeCheckError) {
        let context = try Context(from: declarations, extensions: extensions)
        
        guard case .function = try? context["main"] else {
            throw .missingMain
        }
        
        for declaraion in declarations {
            try context.check(declaraion)
        }
    }
}

extension Context {
    func check(_ declaration: consuming Declaration) throws(TypeCheckError) {
        switch declaration {
        case let .function(_, parameters, returnType?, _, declarations, returnExpression):
            let canonizedParameters = try parameters.canonized() <!> TypeCheckError.canonizeError
            var localContext = try overlaid(by: canonizedParameters) <!> { error in
                TypeCheckError.contextError(error, in: copy declaration)
            }
            
            try localContext.overlay(by: declarations)
            
            for declaration in declarations {
                try localContext.check(declaration)
            }
            
            let returnType = try CanonicalType(from: returnType) <!> TypeCheckError.canonizeError
            try localContext.check(returnExpression, against: returnType)

        default:
            break
        }
    }
}

extension Context {
    func check(
        _ expression: consuming Expression,
        against expected: consuming CanonicalType
    ) throws(TypeCheckError) {
        switch (expression, expected) {
        case (
            .abstraction(let actualParameters, let returnExpression),
            .function(let expectedParameterTypes, let expectedReturnType)
        ) where actualParameters.count == expectedParameterTypes.count:
            let canonicalParameters = try actualParameters.canonized() <!> TypeCheckError.canonizeError

            for (actual, expected) in zip(canonicalParameters.lazy.map(\.type), expectedParameterTypes) {
                try actual.unify(with: expected) <!> { error in
                    TypeCheckError.unifyError(error, in: copy expression)
                }
            }

            let localContext = try overlaid(by: canonicalParameters) <!> { error in
                TypeCheckError.contextError(error, in: .lambda(
                    parameters: actualParameters,
                    returnExpression: returnExpression
                ))
            }
            
            try localContext.check(returnExpression, against: expectedReturnType)

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
            let actualType = try infer(expression)
            try actualType.unify(with: expected) <!> { error in
                TypeCheckError.unifyError(error, in: copy expression)
            }
        }
    }
}
