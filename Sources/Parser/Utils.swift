@preconcurrency import SwiftParsec

extension GenericParser where UserState == (), StreamType == Source {
    var commaSeparated: Parser<[Result]> {
        lexer.commaSeparated(self)
    }

    var commaSeparated1: Parser<[Result]> {
        lexer.commaSeparated1(self)
    }

    var inParens: Parser<Result> {
        lexer.parentheses(self)
    }

    var inBrackets: Parser<Result> {
        lexer.brackets(self)
    }

    var inBraces: Parser<Result> {
        lexer.braces(self)
    }

    var inAngles: Parser<Result> {
        lexer.angles(self)
    }

    var inClips: Parser<Result> {
        self.between(Sign.openClip.parser, Sign.closeClip.parser)
    }

    var lexeme: Parser<Result> {
        lexer.lexeme(self)
    }
}

extension Parsable {
    func map<T>(_ transform: @escaping (ParseResult) -> T) -> Parser<T> {
        parser.map(transform)
    }
}

extension StaticParsable {
    static func map<T>(_ transform: @escaping (ParseResult) -> T) -> Parser<T> {
        Self.parser.map(transform)
    }
}

// generic functions to create parsers for call expressions like `name(...)`
func call<T, R>(
    of name: Keyword, mapping transform: @escaping (T) -> R,
    @ParserBuilder with argumentsBuilder: () -> Parser<T>
) -> Parser<R> {
    call(of: name, mapping: transform, with: argumentsBuilder())
}

func call<T, R>(
    of name: Keyword,
    mapping transform: @escaping (T) -> R,
    with arguments: Parser<T>
) -> Parser<R> {
    rule {
        name
        arguments.inParens
    }.map(transform) <?> "\(name) call expression"
}

@AlternativesBuilder // generic parser to distinguish between tuple and record syntax
func tupleOrRecordContents<T>(
    using stuffParser: Parser<T>,
    forTuple tupleMap: @escaping ([T]) -> T,
    forRecord recordMap: @escaping ([(RecordLabel, T)]) -> T,
    recordFieldSeparator: Sign = .equals,
    descriptionSuffix: String = "",
) -> Parser<T> {
    // either {stuff1, stuff2, stuff3, ... } or {a = stuff1, b = stuff2, ...}
    // hard case is when `stuff1` in the tuple begins with an identifier like `a`

    // try to parse an identifier with a record field separator first
    rule {
        RecordLabel.self
        recordFieldSeparator
    }
    .attempt
    .flatMap { firstIdentifier in
        // if ok, then parse the stuff, and the rest of the record
        // by the way, we are not allowing empty records as they are
        // impossible to distinguish from empty tuples
        rule {
            stuffParser
            rule {
                Sign.comma // end of the previous field
                RecordLabel.self
                recordFieldSeparator
                stuffParser
            }.many
        }
        .map { firstStuff, rest in
            recordMap(
                rest.prepending((firstIdentifier, firstStuff))
            )
        }
    } <?> "record".appending(descriptionSuffix)

    // if failed, then it's definitely a tuple now
    // we haven't consumed input because of .attempt, so we can just parse tuple now
    stuffParser
        .commaSeparated
        .map(tupleMap) <?> "tuple".appending(descriptionSuffix)
}

// Parsec uses different CharacterSet on non-apple platforms
// so we need to extend it to our needs

#if !_runtime(_ObjC)

import struct Foundation.CharacterSet

extension SwiftParsec.CharacterSet {
    init(_ elements: [Unicode.Scalar]) {
        self.init(Foundation.CharacterSet(elements))
    }
}

#endif
