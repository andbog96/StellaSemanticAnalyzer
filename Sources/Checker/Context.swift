@MainActor
struct Context {
    let extensions: Set<Extension>
    let exceptionType: CanonicalType?
    var data: TypeData

    @MutableBox
    var solver = Solver()
    var typeVariables = [] as Set<Name>

    init(from program: Program) throws(SemanticError) {
        extensions = program.extensions
        exceptionType = try Exception(from: program.declarations).map(CanonicalType.init)

        let functions = try Functions(from: program.declarations) <!> SemanticError.canonizeError
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

    private func check(_ function: consuming Function) throws(SemanticError) {
        let declaredTypes = Array(function.parameters.values) + CollectionOfOne(function.returnType)

        let bound = Set(function.typeVariables)
        let undefinedVariables = Array.init § declaredTypes
            .lazy
            .map { $0.freeVariables(except: bound) }
            .reduce([], Set.union)

        if extensions.contains(.universalTypes) {
            guard undefinedVariables.isEmpty else {
                throw .undefinedTypeVariables(undefinedVariables)
            }
        }

        var localContext = self
        localContext.typeVariables = bound
        localContext.data.shadow(by: function.parameters)
        localContext.data.shadow(by: function.nestedFunctions)

        for localFunction in function.nestedFunctions.values {
            try localContext.check(localFunction)
        }

        try localContext.check(function.returnExpression, against: function.returnType)
    }
}
