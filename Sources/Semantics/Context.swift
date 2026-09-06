@MainActor
struct Context {
    let extensions: Set<Extension>
    let exceptionType: CanonicalType?
    var data = nil as ValueData

    @MutableBox
    var solver = Solver()
    var typeVariables = [] as Set<TypeName>

    init(from program: Program) throws(SemanticError) {
        extensions = program.extensions
        exceptionType = try Exception(from: program.declarations).map(CanonicalType.init)

        let functions = try Functions(from: program.declarations) <!> SemanticError.canonizeError
        try check(functions)

        guard case .function(let mainParameters, _) = try? data["main"] else {
            throw .missingMain
        }

        guard mainParameters.count == 1 else {
            throw .incorrectMainArity(mainParameters.count)
        }

        for function in functions.values {
            let resolvedType = solver.resolve(.function(function))

            guard !resolvedType.containsAutoType else {
                throw .ambiguousType(in: function.returnExpression)
            }
        }
    }

    private mutating func check(_ functions: Functions) throws(SemanticError) {
        data.shadow(by: functions)

        let localContexts = try functions.values
            .sorted(by: \.name.description)
            .map { function throws(SemanticError) in
                (function: function, localContext: try localContext(of: function))
            }

        for (function, var localContext) in localContexts {
            try localContext.check(function.nestedFunctions)
            try localContext.check(function.returnExpression, against: function.returnType)
        }
    }

    private func localContext(of function: borrowing Function) throws(SemanticError) -> Context {
        let declaredTypes = Array(function.parameters.values) + CollectionOfOne(function.returnType)

        let bound = Set(function.typeVariables)
        let undefinedVariables = Array.init § declaredTypes
            .lazy
            .map { $0.freeVariables(except: bound) }
            .reduce([], Set.union)

        guard undefinedVariables.isEmpty else {
            throw .undefinedTypeVariables(undefinedVariables)
        }

        var localContext = self
        localContext.typeVariables = bound
        localContext.data.shadow(by: function.parameters)
        localContext.data.shadow(by: function.nestedFunctions)

        return localContext
    }
}
