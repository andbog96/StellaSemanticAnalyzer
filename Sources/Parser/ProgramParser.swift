@preconcurrency import SwiftParsec

extension Program: StaticParsable {
    static let parser: Parser<Program> = rule {
        rule {
            Keyword.language
            Keyword.core
            Sign.semicolon
        } <?> "language declaration"
    
        rule {
            Keyword.extend
            Keyword.with
            
            rule {
                Char.hash.parser.discard
                CharGroup.alphaNum.with("-", "_").parser.many1.stringValue
            }
            .lexeme
            .commaSeparated
            .map {
                Set.init § $0.compactMap(Extension.init(rawValue:))
            }
            
            Sign.semicolon
        }
        .many
        .map {
            NonEmpty(rawValue: $0)?.fold(Set<Extension>.union) ?? []
        }
        <?> "extension declaration"
        
        Declaration.parser.many
    }
    .map(Self.init(extensions:declarations:)) <?> "stella program"
}

extension ValueName: StaticParsable {
    static let parser: Parser<Self> = lexer.identifier.map(Self.init(description:))
}

extension TypeName: StaticParsable {
    static let parser: Parser<Self> = lexer.identifier.map(Self.init(description:))
}

extension RecordLabel: StaticParsable {
    static let parser: Parser<Self> = lexer.identifier.map(Self.init(description:))
}

extension VariantLabel: StaticParsable {
    static let parser: Parser<Self> = lexer.identifier.map(Self.init(description:))
}

extension MemoryAddress: StaticParsable {
    static let parser: Parser<Self> = rule {
        Sign.hexStart
        CharGroup.hexDigit.parser.many1
    }
    .inAngles
        .map(String.init(_:))
        .map(Self.init(value:))
    <?> "memory address"
}

extension Declaration: StaticParsable {
    static var parser: Parser<Self> {
        alternatives {
            Keyword.exception.parser.flatMap { _ in
                exceptionType <|> exceptionVariant
            }
            
            Parser<Never>.empty.noOccurence.flatMap { _ in
                function
            }
        } <?> "declaration"
    }

    static var function: Parser<Self> {
        rule {
            alternatives {
                rule {
                    Keyword.generic
                    Keyword.fn
                    ValueName.parser <?> "function name"
                    TypeName.parser.commaSeparated.inBrackets <?> "type variables"
                }
                .map { (name: $0, typeVariables: $1) }

                rule {
                    Keyword.fn
                    ValueName.parser <?> "function name"
                }
                .map { (name: $0, typeVariables: [] as [TypeName]) }
            }
            parameters
            returnType
            throwTypes
            functionBody
        }
        .map { header, parameters, returnType, throwTypes, body in
            let (declarations, returnExpression) = body
            
            return function(
                name: header.name,
                typeVariables: header.typeVariables,
                parameters: parameters,
                returnType: returnType,
                throwTypes: throwTypes,
                declarations: declarations,
                returnExpression: returnExpression,
            )
        } <?> "function"
    }
    
    static let parameters: Parser<[(name: ValueName, rawType: RawType)]> = rule {
        ValueName.self
        Sign.colon
        RawType.self
    }
    .map { (name: $0, rawType: $1) }
    .commaSeparated
    .inParens <?> "parameters"

    static let functionBody: Parser<([Declaration], Expression)> = rule {
        rule {
            Declaration.self
            Sign.semicolon.parser.optional
        }
        .many
        
        Keyword.return
        Expression.self
    }
    .inBraces <?> "function body"

    static let returnType: Parser<RawType?> = rule {
        Sign.arrow
        RawType.self
    }
    .optional <?> "return type"

    static let throwTypes: Parser<[RawType]> = rule {
        Keyword.throws
        RawType.parser.commaSeparated1
    }
    .optional
    .map { $0 ?? [] } <?> "throw type"

    static let exceptionType: Parser<Self> = rule {
        Keyword.type
        Sign.equals
        RawType.parser
    }
    .map(Self.exceptionType) <?> "exception type"

    static let exceptionVariant: Parser<Self> = rule {
        Keyword.variant
        VariantLabel.self
        Sign.colon
        RawType.self
    }
    .map(Self.exceptionVariant) <?> "exception variant"
}
