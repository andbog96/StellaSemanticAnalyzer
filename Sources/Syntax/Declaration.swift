enum Declaration: Sendable {
    case function(
        name: Name,
        typeVariables: [Name],
        parameters: [(name: Name, rawType: RawType)],
        returnType: RawType?,
        throwTypes: [RawType],
        declarations: [Declaration],
        returnExpression: Expression
    )
    
    case exceptionType(RawType)
    case exceptionVariant(Label, RawType)
}

extension Declaration {
    static func lambda(
        typeVariables: [Name] = [],
        parameters: [(name: Name, rawType: RawType)] = [],
        returnExpression: Expression
    ) -> Self {
        .function(
            name: "",
            typeVariables: typeVariables,
            parameters: parameters,
            returnType: nil,
            throwTypes: [],
            declarations: [],
            returnExpression: returnExpression
        )
    }

    static func forall(
        typeVariables: [Name],
        returnType: RawType,
    ) -> Self {
        .function(
            name: "",
            typeVariables: typeVariables,
            parameters: [],
            returnType: returnType,
            throwTypes: [],
            declarations: [],
            returnExpression: .panic // bullshit
        )
    }
}
