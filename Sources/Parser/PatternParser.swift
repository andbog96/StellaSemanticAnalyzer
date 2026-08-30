@preconcurrency import SwiftParsec

extension Pattern: StaticParsable {
    static let parser: Parser<Self> = .recursive { pattern in
        rule {
            commonPattern(using: pattern) <?> "pattern"
            // like with term expression, first parse pattern, then
            // try to parse arbitrary amount of `case as` or `as` casts
            alternatives {
                ascription(cast: true)
                ascription(cast: false)
            }.many
        }.map { (pattern, casts) in // and here we can apply all casts nicely with reduce
            casts.reduce(pattern) { $1($0) }
        }
    } <?> "pattern"

    @AlternativesBuilder
    static func commonPattern(using pattern: Parser<Self>) -> Parser<Self> {
        pattern.inParens // can be nested in meaningless parens
        variant(using: pattern)
        call(of: .inl, mapping: Self.inl, with: pattern) <?> "left alternative"
        call(of: .inr, mapping: Self.inr, with: pattern) <?> "right alternative"
        call(of: .succ, mapping: Self.succ, with: pattern) <?> "succ pattern"
        tupleOrRecordContents(
            using: pattern,
            forTuple: Self.tuple,
            forRecord: Self.record,
            descriptionSuffix: " pattern",
        ).inBraces
        list(using: pattern)
        constructor(using: pattern)
        basicPattern
    }

    @ParserBuilder
    static func ascription(cast: Bool) -> Parser<(Self) -> Self> {
        if cast { Keyword.cast }
        Keyword.as
        RawType.self.map { type in
            { (cast ? Self.cast : Self.ascription) ($0, type) }
        } <?> "\(cast ? "cast" : "ascription") pattern"
    }

    // to avoid recursion in the cast and ascription rules,
    // we need to parse patters like expressions with postfix operations
    static let table: OperatorTable<Source, (), Self> = [[
        .postfix(
            rule {
                Keyword.cast
                Keyword.as
                RawType.self
            }.map { type in { Self.cast($0, as: type) } } <?> "cast"
        ),
        .postfix(
            rule {
                Keyword.as
                RawType.self
            }.map { type in { Self.ascription($0, as: type) } } <?> "ascription"
        )
    ]]

    static func variant(using thisParser: Parser<Self>) -> Parser<Self> {
        rule {
            Label.self
            rule {
                Sign.equals
                thisParser
            }.optional <?> "pattern data"
        }.inClips.map(Self.variant) <?> "variant pattern"
    }

    static func list(using thisParser: Parser<Self>) -> Parser<Self> {
        thisParser
            .commaSeparated
            .inBrackets
            .map(Self.list) <?> "list pattern"
    }

    static func constructor(using thisParser: Parser<Self>) -> Parser<Self> {
        // there are some weird rules regarding this branch:
        // PatternCons.    Pattern ::= "cons" "(" Pattern "," Pattern ")" ;
        // patternCons.    Pattern ::= "(" Pattern "," Pattern ")" ;
        // define patternCons h t = PatternCons h t ;
        // no idea, what the last two mean, and it would be really difficult to parse
        // the `(pattern, pattern)` as one pattern expression, so not using this one
        rule {
            Keyword.cons
            rule {
                thisParser
                Sign.comma
                thisParser
            }.inParens
        }.map(Self.cons) <?> "cons pattern"
    }

    static let basicPattern: Parser<Self> = alternatives {
        Keyword.true.map { `true` }
        Keyword.false.map { `false` }
        Keyword.unit.map { unit }
        Name.map(`var`)
        lexer.natural.map {
            (0..<$0).reduce(zero) { pattern, _ in
                succ(pattern)
            }
        }
    }
}
