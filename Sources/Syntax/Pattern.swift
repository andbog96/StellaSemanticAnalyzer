enum Pattern: Sendable {
    case `var`(Name)

    case `false`
    case `true`
    
    case zero
    indirect case succ(Pattern)

    case unit
    case tuple(elements: [Pattern])
    case record(fields: [(label: Name, pattern: Pattern)])

    indirect case inl(Pattern)
    indirect case inr(Pattern)
    indirect case variant(label: Name, pattern: Pattern?)
    
    case list([Pattern])
    indirect case cons(Pattern, Pattern)
    
    indirect case cast(Pattern, RawType)
    indirect case ascription(Pattern, RawType)
}
