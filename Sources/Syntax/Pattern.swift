enum Pattern: Sendable {
    case `var`(Name)

    case `false`
    case `true`
    
    case zero
    indirect case succ(Pattern)

    case unit
    case tuple(elements: [Pattern])
    case record(fields: [(label: Label, pattern: Pattern)])

    indirect case inl(Pattern)
    indirect case inr(Pattern)
    indirect case variant(Label, Pattern?)

    case list([Pattern])
    indirect case cons(head: Pattern, tail: Pattern)

    indirect case cast(Pattern, as: RawType)
    indirect case ascription(Pattern, as: RawType)
}
