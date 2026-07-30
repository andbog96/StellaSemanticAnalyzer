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
        } <?> "extension declaration"
        
        Declaration.parser.many
    }
    .map(Self.init(extensions:declarations:)) <?> "stella program"
}

extension Name: StaticParsable {
    static let parser: Parser<Self> = lexer.identifier.map(Self.init(value:))
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
    static let parser: Parser<Self> = alternatives {
        Keyword.exception.parser.flatMap { _ in // if starts with an `exception` word
            exceptionType <|> exceptionVariant
        }
        normalFunction <|> genericFunction
    } <?> "declaration"

    static var normalFunction: Parser<Self> {
        rule {
            Keyword.fn
            Name.parser <?> "function name"
            parameters
            returnType
            throwTypes
            functionBody
        }
        .map { name, parameters, returnType, throwTypes, body in
            let (declarations, returnExpression) = body
            
            return function(
                name: name,
                parameters: parameters,
                returnType: returnType,
                throwTypes: throwTypes,
                declarations: declarations,
                returnExpression: returnExpression,
            )
        } 
        <?> "function"
    }

    static var genericFunction: Parser<Self> {
        rule {
            Keyword.generic
            Keyword.fn
            Name.parser <?> "function name"
            Name.parser
                .labels("type variable")
                .commaSeparated
                .inBrackets <?> "type variables"
            parameters
            returnType
            throwTypes
            functionBody
        }.map { (name, typeParameters, parameters, returnType, throwTypes, body) in
            let (declarations, returnExpression) = body
            
            return genericFunction(
                name: name,
                typeVariables: typeParameters,
                parameters: parameters,
                returnType: returnType,
                throwTypes: throwTypes,
                declarations: declarations,
                returnExpression: returnExpression
            )
        } <?> "generic function"
    }
    
    static let parameters: Parser<[Parameter]> =
        Parameter
            .parser
            .commaSeparated
            .inParens <?> "parameters"

    static let functionBody: Parser<([Declaration], Expression)> = rule {
        rule {
            Declaration.self
            Sign.semicolon.parser.optional
        }.many
        Keyword.return
        Expression.self
    }.inBraces <?> "function body"

    static let returnType: Parser<RawType?> = rule {
        Sign.arrow
        RawType.self
    }.optional <?> "return type"

    static let throwTypes: Parser<[RawType]> = rule {
        Keyword.throws
        RawType.parser.commaSeparated1
    }.optional.map { $0 ?? [] } <?> "throw type" // if no `throws` return []

    // `exception` already parsed
    static let exceptionType: Parser<Self> = rule {
        Keyword.type
        Sign.equals
        RawType.parser
    }.map(Self.exceptionType) <?> "exception type"

    // `exception` already parsed
    static let exceptionVariant: Parser<Self> = rule {
        Keyword.variant
        Name.self
        Sign.colon
        RawType.self
    }.map(Self.exceptionVariant) <?> "exception variant"
}

extension Declaration.Parameter: StaticParsable {
    static let parser: Parser<Self> = rule {
        Name.self
        Sign.colon
        RawType.self
    }.map(Self.init) <?> "parameter"
}
