@preconcurrency import SwiftParsec

extension Expression: StaticParsable {
    static func ifExpression(using thisParser: Parser<Self>) -> Parser<Self> {
        rule {
            Keyword.if
            thisParser
            Keyword.then
            thisParser
            Keyword.else
            thisParser
        }
        .map(`if`) <?> "if condition"
    }

    static func letExpression(using thisParser: Parser<Self>, recursive: Bool) -> Parser<Self> {
        let keyword = recursive ? Keyword.letrec : Keyword.let
        return rule {
            keyword
            rule {
                Pattern.self
                Sign.equals
                thisParser
            }
            .commaSeparated1 <?> "pattern binding"
            
            Keyword.in
            
            thisParser
        }
        .map(recursive ? letrec : `let` as ([(_, _)], _) -> _)
        <?> "\(keyword) expression"
    }

    static func generic(using thisParser: Parser<Self>) -> Parser<Self> {
        rule {
            Keyword.generic
            Name.parser
                .commaSeparated
                .inBrackets
            thisParser
        }
        .map(typeAbstraction) <?> "generic expression"
    }

    static func lambda(using thisParser: Parser<Self>) -> Parser<Self> {
        rule {
            Keyword.fn
            Declaration.parameters
            rule {
                Keyword.return
                thisParser
            }
            .inBraces
        }.map(abstraction) <?> "lambda"
    }

    static func variant(using thisParser: Parser<Self>) -> Parser<Self> {
        rule {
            Name.self
            rule {
                Sign.equals
                thisParser
            }
            .optional <?> "expression data"
        }
        .inClips
        .map(variant) <?> "variant experssion"
    }

    static func match(using thisParser: Parser<Self>) -> Parser<Self> {
        rule {
            Keyword.match
            thisParser
            rule {
                Pattern.self
                Sign.logicArrow
                thisParser
            }
            .labels("match case")
            .separatedBy(Sign.pipe.parser)
            .inBraces <?> "match clause"
        }
        .map(match as (_, [(_, _)]) -> _)
        <?> "match expression"
    }

    static func list(using thisParser: Parser<Self>) -> Parser<Self> {
        thisParser
            .commaSeparated
            .inBrackets
            .map(list) <?> "list expresssion"
    }

    @ParserBuilder
    static func tryExpression(using thisParser: Parser<Self>) -> Parser<Self> {
        Keyword.try
        thisParser.inBraces.flatMap { tried in alternatives {
            rule {
                Keyword.catch
                rule {
                    Pattern.self
                    Sign.logicArrow
                    thisParser
                }
                .inBraces
            }
            .map { tryCatch(attempted: tried, pattern: $0, handler: $1) } <?> "try catch expression"

            rule {
                Keyword.with
                thisParser.inBraces
            }
            .map { tryWith(attempted: tried, fallback: $0) } <?> "try with expression"

            rule {
                Keyword.cast
                Keyword.as
                RawType.self
                rule {
                    Pattern.self
                    Sign.logicArrow
                    thisParser
                }
                .inBraces <?> "pattern match clause"
                Keyword.with
                thisParser.inBraces
            }
            .map { (type, clause, expression) in
                tryCastAs(tried, type, clause.0, clause.1, with: expression)
            } <?> "`try cast with` expression"
        }}
    }

    static let postfixDot: Parser<(Self) -> Self> =
        Sign.dot.parser.flatMap { () in
            alternatives {
                lexer.natural.map { number in { dotTuple ($0, index: number) } }
                Name.map { attribute in { dotRecord($0, label: attribute) } }
            }
        }

    @ParserBuilder
    static func ascription(cast: Bool) -> Parser<(Self) -> Self> {
        if cast {
            Keyword.cast
        }
        Keyword.as
        // techinacally it should be Type2, but now just leave as a full type
        RawType.self
            .map { type in
                {
                    if cast {
                        typeCast($0, type)
                    } else {
                        typeAscription($0, type)
                    }
                }
            } <?> "type \(cast ? "cast" : "ascription")"
    }

    @ParserBuilder
    static func applicationPostfix(using thisParser: Parser<Self>) -> Parser<(Self) -> Self> {
        thisParser
            .commaSeparated
            .inParens
            .map { arguments in { application(calle: $0, arguments: arguments) } }
    }

    static let typeApplicationPostfix: Parser<(Self) -> Self> = RawType
        .parser
        .commaSeparated
        .inBrackets
        .map { types in { typeApplication($0, types) } }
}
