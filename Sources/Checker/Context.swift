struct Context {
    let extensions: Set<Extension>
    let exceptionType: CanonicalType?
    var data: TypeData

    init(from program: Program) throws(TypeCheckError) {
        extensions = program.extensions
        exceptionType = try Exception(from: program.declarations).map(CanonicalType.init)

        let functions = try Functions(from: program.declarations) <!> TypeCheckError.canonizeError
        data = TypeData(functions)

        guard case .function(let mainParameters, _) = try? data["main"] else {
            throw .missingMain
        }

        guard mainParameters.count == 1 else {
            throw .incorrectMainArity(mainParameters.count)
        }

        for function in functions.values {
            try check(function)
        }
    }

    private func check(_ function: consuming Function) throws(TypeCheckError) {
        guard function.typeVariables.isEmpty || extensions.contains(.universalTypes) else {
            throw .unsupported(message: "Illegal declaration of a generic function")
        }

        var localContext = self
        localContext.data.overlay(by: function.parameters)
        localContext.data.overlay(by: function.nestedFunctions)

        for localFunction in function.nestedFunctions.values {
            try localContext.check(localFunction)
        }

        try localContext.check(function.returnExpression, against: function.returnType)
    }
}
