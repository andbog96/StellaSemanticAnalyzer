import Collections

struct Function {
    var name: Name
    var typeVariables: OrderedSet<Name>
    var parameters: Parameters
    var returnType: CanonicalType
    var nestedFunctions: Functions
    var returnExpression: Expression
}

extension Function {
    typealias Parameters = OrderedDictionary<Name, CanonicalType>
    
    init?(from declaration: consuming Declaration) throws(CanonizeError) {
        switch declaration {
        case .function(
            let name,
            let typeVariables,
            let parameters,
            let returnType?,
            let throwTypes,
            let declarations,
            let returnExpression
        ):
            guard throwTypes.isEmpty else {
                throw CanonizeError.unsupported(message: "#throw-type-annotations is not supported")
            }

            self.init(
                name: name,

                typeVariables: try OrderedSet(typeVariables, rejectingDuplicatesWith: ParametersError.duplicateTypeParameter) <!> {
                    CanonizeError.parametersError($0, in: copy declaration)
                },

                parameters: try parameters.canonized() |> Parameters.init(from:) <!> {
                    CanonizeError.parametersError($0, in: copy declaration)
                },
                
                returnType: try returnType |> CanonicalType.init(from:),
                
                nestedFunctions: try Functions(from: declarations),

                returnExpression: returnExpression
            )

        case .function(_, _, _, returnType: nil, _, _, _):
            throw CanonizeError.unsupported(code: "ERROR_MISSING_EXPLICIT_RETURN_TYPE")
        
        case .exceptionType,
             .exceptionVariant:
            return nil
        }
    }
}

typealias Functions = [Name: Function]

extension Functions {
    init(from declarations: [Declaration]) throws(CanonizeError) {
        self = Dictionary(minimumCapacity: declarations.count)
        
        let functions = try declarations.compactMap(Function.init(from:))
        
        for function in functions {
            guard updateValue(function, forKey: function.name) == nil else {
                throw .duplicateFunctionDeclaration(function.name)
            }
        }
    }
}
