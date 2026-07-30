enum Declaration: Sendable {
    case function(
        name: Name,
        parameters: [Parameter],
        returnType: RawType?,
        throwTypes: [RawType],
        declarations: [Declaration],
        returnExpression: Expression
    )
    
    case genericFunction(
        name: Name,
        typeVariables: [Name],
        parameters: [Parameter],
        returnType: RawType?,
        throwTypes: [RawType],
        declarations: [Declaration],
        returnExpression: Expression
    )
    
    case exceptionType(RawType)
    case exceptionVariant(name: Name, type: RawType)
}

extension Declaration {
    static func lambda(
        parameters: [Parameter],
        returnExpression: Expression
    ) -> Declaration {
        .function(
            name: "",
            parameters: parameters,
            returnType: nil,
            throwTypes: [],
            declarations: [],
            returnExpression: returnExpression
        )
    }

    static func genericLambda(
        typeVariables: [Name],
        parameters: [Parameter],
        returnExpression: Expression
    ) -> Declaration {
        .genericFunction(
            name: "",
            typeVariables: typeVariables,
            parameters: parameters,
            returnType: nil,
            throwTypes: [],
            declarations: [],
            returnExpression: returnExpression
        )
    }
}

extension Declaration {
    struct Parameter {
        var name: Name
        var type: RawType
    }
}
