enum Declaration: Sendable {
    case function(
        name: Name,
        typeVariables: [Name],
        parameters: [(name: Name, type: RawType)],
        returnType: RawType?,
        throwTypes: [RawType],
        declarations: [Declaration],
        returnExpression: Expression
    )
    
    case exceptionType(RawType)
    case exceptionVariant(label: Name, rawType: RawType)
}

extension Declaration {
    static func lambda(
        parameters: [(name: Name, type: RawType)],
        returnExpression: Expression
    ) -> Declaration {
        .function(
            name: "",
            typeVariables: [],
            parameters: parameters,
            returnType: nil,
            throwTypes: [],
            declarations: [],
            returnExpression: returnExpression
        )
    }
}
