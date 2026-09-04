@preconcurrency import SwiftParsec

extension RawType: StaticParsable {
    // thiss is no jokes about calling a recursive parser this way ONLY
    // if you just try to call it recursively as a static variable, it will crash hard
    static let parser: Parser<Self> = .recursive { typeParser in
        alternatives {
            Keyword.auto.map { auto } <?> "auto type"
            function(using: typeParser)
            forall(using: typeParser)
            // other cases are handled by a special expression parser
            typeExpression(using: typeParser)
        }
    } <?> "type"

    // operators on types (it's just + really)
    static let operatorTable: OperatorTable<Source, (), RawType> = [
        [ .infix(Sign.plus.map { sum } <?> "sum type", .none) ]
    ]

    @AlternativesBuilder
    static func basicType(
        using typeParser: Parser<Self>,
        enclosed: Parser<Self>
    ) -> Parser<Self> {
        typeParser.inParens

        tupleOrRecordContents(
            using: typeParser,
            forTuple: tuple,
            forRecord: record,
            recordFieldSeparator: .colon,
            descriptionSuffix: " type",
        )
        .inBraces

        // [int]
        typeParser.inBrackets.map(list) <?> "list type"

        // <| a, b : bool, c : int |>
        let variant = rule { // `a: int` field for variant
            VariantLabel.self
            rule { // optional `: int`
                Sign.colon
                typeParser
            }
            .optional <?> "optional typing"
        }
        .commaSeparated
        .inClips
        variant.map(Self.variant) <?> "variant type"

        Keyword.Bool.map { bool   } <?> "bool type"
        Keyword.Nat .map { nat    } <?> "nat type"
        Keyword.Unit.map { unit   } <?> "unit type"
        Keyword.Top .map { top    } <?> "top type"
        Keyword.Bot .map { bottom } <?> "bot type"

        rule { // &T
            Sign.ampersand
            enclosed
        }
        .map(reference) <?> "reference type"

        TypeName.map(variable) <?> "type variable"
    }

    // parsec provides tools for quickly parsing expressions
    static func typeExpression(using typeParser: Parser<Self>) -> Parser<Self> {
        operatorTable.makeExpressionParser { enclosedParser in
            basicType(using: typeParser, enclosed: enclosedParser)
        }
    }

    static func function(using typeParser: Parser<RawType>) -> Parser<RawType> {
        rule {
            Keyword.fn
            typeParser
                .commaSeparated
                .inParens
            Sign.arrow
            typeParser
        }
        .map(function) <?> "function type"
    }

    static func forall(using typeParser: Parser<Self>) -> Parser<Self> {
        rule {
            Keyword.forall
            TypeName.parser.commaSeparated
            Sign.dot
            typeParser
        }
        .map(forall) <?> "forall type"
    }
}
