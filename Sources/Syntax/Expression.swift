enum Expression: Sendable {
    // MARK: - STLC
    case `var`(Name)
    indirect case abstraction(parameters: [(name: Name, rawType: RawType)], returnExpression: Expression)
    indirect case application(calle: Expression, arguments: [Expression])
    
    // MARK: - Bool
    case constTrue
    case constFalse
    indirect case `if`(condition: Expression, then: Expression, else: Expression)
    
    // MARK: - Nat
    case constInt(Int)
    indirect case succ(n: Expression)
    indirect case pred(n: Expression)
    indirect case isZero(n: Expression)
    indirect case natRec(n: Expression, zero: Expression, step: Expression)
    
    // MARK: - #unit-type
    case constUnit
    
    // MARK: - #pairs, #tuples
    case tuple(elements: [Expression])
    indirect case dotTuple(Expression, index: Int)

    // MARK: - #records
    case record(fields: [(label: Label, value: Expression)])
    indirect case dotRecord(Expression, Label)

    // MARK: - #let-patterns
    indirect case `let`(cases: [(pattern: Pattern, value: Expression)], inExpression: Expression)

    // MARK: - #letrec-bindings
    indirect case letrec(cases: [(pattern: Pattern, value: Expression)], inExpression: Expression)

    // MARK: - #type-ascriptions
    indirect case typeAscription(value: Expression, as: RawType)

    // MARK: - #sum-types
    indirect case inl(left: Expression)
    indirect case inr(right: Expression)

    // MARK: - #variants
    indirect case variant(Label, payload: Expression?)
    indirect case match(value: Expression, cases: [(pattern: Pattern, value: Expression)])

    // MARK: - #lists
    case list(elements: [Expression])
    indirect case cons(head: Expression, tail: Expression)
    indirect case head(list: Expression)
    indirect case tail(list: Expression)
    indirect case isEmpty(list: Expression)

    // MARK: - #fixpoint-combinator
    indirect case fix(generator: Expression)

    // MARK: - #sequencing
    indirect case sequence(first: Expression, second: Expression)

    // MARK: - #references
    case constMemory(MemoryAddress)
    indirect case reference(Expression)
    indirect case dereference(Expression)
    indirect case assign(variable: Expression, assignee: Expression)
    
    // MARK: - #panic
    case panic
    
    // MARK: - #exceptions
    indirect case `throw`(exception: Expression)
    indirect case tryWith(attempted: Expression, fallback: Expression)
    indirect case tryCatch(attempted: Expression, pattern: Pattern, handler: Expression)

    // MARK: - #type-cast
    indirect case typeCast(value: Expression, as: RawType)

    // MARK: - #try-cast-as, #type-cast-patterns
    indirect case tryCastAs(
        value: Expression,
        as: RawType,
        pattern: Pattern,
        handler: Expression,
        fallback: Expression
    )

    // MARK: - #universal-types
    indirect case typeAbstraction(variables: [Name], body: Expression)
    indirect case typeApplication(calle: Expression, parameters: [RawType])
}
