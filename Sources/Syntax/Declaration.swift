enum Declaration: Sendable {
    case function(
        name: ValueName,
        typeVariables: [TypeName],
        parameters: [(name: ValueName, rawType: RawType)],
        returnType: RawType?,
        throwTypes: [RawType],
        declarations: [Declaration],
        returnExpression: Expression
    )
    
    case exceptionType(RawType)
    case exceptionVariant(VariantLabel, RawType)
}

extension Declaration {
    static func lambda(
        typeVariables: [TypeName] = [],
        parameters: [(name: ValueName, rawType: RawType)] = [],
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
        typeVariables: [TypeName],
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
