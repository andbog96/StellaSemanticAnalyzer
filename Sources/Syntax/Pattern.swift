enum Pattern: Sendable {
    case `var`(ValueName)

    case `false`
    case `true`
    
    case zero
    indirect case succ(Pattern)

    case unit
    case tuple(elements: [Pattern])
    case record(fields: [(label: RecordLabel, pattern: Pattern)])

    indirect case inl(Pattern)
    indirect case inr(Pattern)
    indirect case variant(VariantLabel, Pattern?)

    case list([Pattern])
    indirect case cons(head: Pattern, tail: Pattern)

    indirect case cast(Pattern, as: RawType)
    indirect case ascription(Pattern, as: RawType)
}

extension Pattern {
    var isVariable: Bool {
        if case .var = self {
            true
        } else {
            false
        }
    }
}
