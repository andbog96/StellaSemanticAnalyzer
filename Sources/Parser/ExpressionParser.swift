@preconcurrency import SwiftParsec

// expr = single ; expr?
// block = single (; block)?
// expr = block
// block = single (; (block)?)?
// expr = single
// expr = single ;
// expr = single ; block

extension Expression {
    typealias ThisParser = Parser<Self>
    typealias Operations = OperatorTable<Source, (), Self>

    static let parser: Parser<Self> = .recursive { expression in
        rule {
            single(using: expression)
            Sign.semicolon.parser
                .flatMap { expression.optional }
                .optional
                .map(\.?)
        }
        .map { expr, nextExpr in
            guard let nextExpr else { return expr }
            return .assign(variable: expr, assignee: nextExpr)
        } <?> "expresssion"
    }

    // singular = Expr1
    static func single(using expression: ThisParser) -> ThisParser {
        .recursive { singular in
            alternatives {
                ifExpression(using: singular)
                letExpression(using: expression, recursive: false)
                letExpression(using: expression, recursive: true)
                generic(using: expression)
                // expr := expr
                rule {
                    conditional(using: expression)
                    rule { // we parse `:= expr` as an optional prefix to avoid backtracking
                        Sign.colonEquals
                        singular
                    }.optional
                }.map { expr, assignedExpr in
                    guard let assignedExpr else { return expr }
                    return .assign(variable: expr, assignee: assignedExpr)
                } <?> "assignment"
            }
        }
    }

    // conditional ~ Expr2
    static func conditional(using expression: ThisParser) -> ThisParser {
        comparisonOperations.makeExpressionParser { conditional in
            term(using: expression, conditional: conditional)
        }
    }

    // term = Expr3
    // but we do not parse expressions like `3 as Int + 4` it's hard and likely not inteded
    static func term(using expression: ThisParser, conditional: ThisParser) -> ThisParser {
        .recursive { term in
            rule {
                alternatives {
                    lambda(using: expression)
                    variant(using: expression)
                    match(using: expression)
                    list(using: expression)
                    arithmeticOperations.makeExpressionParser { arithmetic in
                        factor(using: expression)
                    }
                }
                alternatives { // arbitrary many suffixes of cast as or as
                    ascription(cast: false)
                    ascription(cast: true)
                }.many // each gives us a transforming function, apply them in order
            }.map { (term, suffixes) in
                suffixes.reduce(term) { result, suffix in
                    suffix(result)
                }
            } // map
        } // recursive
    }

    // factor = Expr5
    static func factor(using expression: ThisParser) -> ThisParser {
        .recursive { factor in
            alternatives {
                call(of: .new, mapping: Self.ref, with: expression)
                rule { // here we can afford to call factor parser directly as it is
                    // prefixed by a star, no infinite recursion is possible
                    Sign.star
                    factor
                }.map(Self.deref) <?> "dereference"
                suffix(using: expression)
            }
        }
    }

    // suffix = Expr6
    static func suffix(using expression: ThisParser) -> ThisParser {
        rule {
            enclosed(using: expression)
            // again, parse any number of suffixes after the core expression
            // and then apply gained functions from left to right to get the expression
            alternatives {
                applicationPostfix(using: expression)
                typeApplicationPostfix
                postfixDot
            }.many
        }.map { expr, suffixes in suffixes.reduce(expr) { $1($0) } }
    }

    @AlternativesBuilder // enclosed = Expr6, but without suffix rules
    static func enclosed(using expression: ThisParser) -> ThisParser {
        tupleOrRecordContents(
            using: expression, 
            forTuple: tuple,
            forRecord: record,
            descriptionSuffix: " expression",
        ).inBraces

        call(of: .new, mapping: ref, with: expression)
        call(of: .cons, mapping: cons) {
            expression
            Sign.comma
            expression
        }

        Keyword.panic.map { panic }

        tryExpression(using: expression)

        call(of: .throw, mapping: Self.throw, with: expression)

        call(of: .ListHead, mapping: Self.head, with: expression)
        call(of: .ListIsEmpty, mapping: Self.isEmpty, with: expression)
        call(of: .ListTail, mapping: Self.tail, with: expression)

        call(of: .inl, mapping: Self.inl, with: expression)
        call(of: .inr, mapping: Self.inr, with: expression)

        call(of: .succ, mapping: Self.succ, with: expression)

        call(of: .NatPred, mapping: Self.pred, with: expression)
        call(of: .NatIsZero, mapping: Self.isZero, with: expression)

        call(of: .fix, mapping: Self.fix, with: expression)
        call(of: .NatRec, mapping: Self.natRec) {
            expression
            Sign.comma
            expression
            Sign.comma
            expression
        }

        basic(using: expression)
    }

    @AlternativesBuilder // basic = Expr7
    static func basic(using expression: ThisParser) -> ThisParser {
        expression.inParens

        Keyword.true .map { Self.constTrue  }
        Keyword.false.map { Self.constFalse }
        Keyword.unit .map { Self.constUnit  }

        lexer.integer.map(Self.constInt)

        Name.map(Self.var)
        MemoryAddress.map(Self.constMemory)
    }

    static let comparisonOperations: Operations = [
        [
        ]
    ]

    static let arithmeticOperations: Operations = [
        [
        ],
        [
        ]
    ]

}
