@preconcurrency import SwiftParsec

// this includes lexer for the keywords, operators and such

/// Used in parser as known tokens
enum Keyword: String, Parsable, CaseIterable {
    case fn
    case `return`
    case generic
    case inline
    case type
    case `throws`
    case `throw`
    case exception
    case match
    case variant
    case cast
    case `as`
    case inl
    case inr
    case cons
    case `false`
    case `true`
    case unit
    case succ
    case and
    case or
    case not
    case `if`
    case then
    case `else`
    case `let`
    case `in`
    case `letrec`
    case new
    case panic = "panic!"
    case `try`
    case `catch`
    case with
    case fix
    case fold
    case unfold
    case ListHead = "List::head"
    case ListIsEmpty = "List::isempty"
    case ListTail = "List::tail"
    case NatPred = "Nat::pred"
    case NatIsZero = "Nat::iszero"
    case NatRec = "Nat::rec"
    case forall
    case auto
    case Bool
    case Nat
    case Unit
    case Top
    case Bot
    case language
    case core
    case extend

    var parser: Parser<Void> { lexer.reservedName(self.rawValue) }
}

/// Also used in parser as known tokens
enum Sign: String, Parsable, CaseIterable {
    case semicolon = ";"
    case comma = ","
    case equals = "="
    case colonEquals = ":="
    case arrow = "->"
    case logicArrow = "=>"
    case colon = ":"
    case dot = "."
    case ampersand = "&"
    case plus = "+"
    case minus = "-"
    case star = "*"
    case slash = "/"
    case openClip = "<|"
    case closeClip = "|>"
    case pipe = "|"
    case less = "<"
    case lessEq = "<="
    case greater = ">"
    case greaterEq = ">="
    case doubleEquals = "=="
    case notEquals = "!="
    case hexStart = "0x"

    var parser: Parser<Void> {
        lexer.reservedOperator(self.rawValue)
    }
}

/// These are used to parse individual characters of tokens
enum Char: Character, Parsable, ExpressibleByUnicodeScalarLiteral {
    case underscore = "_"
    case hash = "#"
    case hyphen = "-"

    init(unicodeScalarLiteral value: Character) {
        self = .init(rawValue: value)!
    }

    var parser: Parser<Character> {
        StringParser.character(self.rawValue)
    }
}

/// Also used to tokenize input
struct CharGroup: Parsable {
    let allowed: [CharacterSet]
    let description: String

    init(allowed: [CharacterSet], _ description: String) {
        self.allowed = allowed
        self.description = description
    }

    init(_ string: StringLiteralType, _ description: String) {
        self.allowed = [CharacterSet(charactersIn: string)]
        self.description = description
    }

    static let alphaNum = Self(allowed: [.alphanumerics], "digit or a letter")
    static let digit = Self(allowed: [.decimalDigits], "digit")
    static let hexDigit = Self("0123456789ABCDEFabcdef", "hexadecimal digit")
    static let letter = Self(allowed: [.letters], "letter")

    static func + (a: CharGroup, b: CharGroup) -> CharGroup {
        CharGroup(
            allowed: a.allowed + b.allowed,
            a.description + " or " + b.description
        )
    }

    func with(_ characters: Unicode.Scalar...) -> CharGroup {
        let charsDescription = characters.map { "\"\($0)\"" }.joined(separator: " , ")

        return .init(
            allowed: allowed.appending(CharacterSet(characters)),
            description + " or " + charsDescription
        )
    }

    var parser: Parser<Character> {
        allowed.reduce(.empty) { parser, set in
            parser <|> StringParser.memberOf(set)
        } <?> description
    }
}

let stellaDefinition: LanguageDefinition<Void> = {
    var stella = LanguageDefinition<Void>.empty

    stella.commentStart = "/*"
    stella.commentEnd = "*/"
    stella.commentLine = "//"

    stella.identifierStart = CharGroup.letter.with("_").parser

    stella.identifierLetter = { _ in
        CharGroup.alphaNum.with("_", "-", "!", "?", ":").parser
    }

    stella.reservedNames = Set(Keyword.allCases.map(\.rawValue))
    stella.reservedOperators = Set(Sign.allCases.map(\.rawValue))

    // don't confuse operators written one after another as some custom operator
    stella.operatorLetter = .empty

    return stella
}()

let lexer = GenericTokenParser(languageDefinition: stellaDefinition)
