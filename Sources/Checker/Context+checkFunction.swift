extension Context {
    func check(_ function: consuming Function) throws(TypeCheckError) {
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
