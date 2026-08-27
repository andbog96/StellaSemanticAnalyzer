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
        parameters: [(name: Name, rawType: RawType)],
        returnExpression: Expression
    ) -> Self {
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
