enum RawType: Sendable {
    indirect case function(from: [Self], to: Self)

    case bool
    case nat
    case unit

    case tuple(elements: [Self])
    case record(fields: [(label: RecordLabel, rawType: Self)])

    indirect case sum(left: Self, right: Self)
    case variant(cases: [(label: VariantLabel, rawType: Self?)])

    indirect case list(Self)
    
    indirect case reference(Self)
    
    case top
    case bottom
    
    case auto
    case variable(TypeName)
    indirect case forall(variables: [TypeName], rawType: Self)
}
