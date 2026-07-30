enum CanonicalType: Sendable, Equatable, Hashable {
    indirect case function(from: [Self], to: Self)
    case variable(Name)

    case bool
    case nat
    case unit

    case tuple(elements: [Self])
    case record(fields: [Name: Self])

    indirect case sum(left: Self, right: Self)
    case variant(cases: [Name: Self?])

    indirect case list(Self)

    indirect case mu(Name, Self)
    indirect case reference(Self)

    case top
    case bottom

    case auto
    indirect case forall(variables: [Name], type: Self)
}

extension CanonicalType {
    init(from rawType: RawType) throws(CanonizeError) {
        self = switch rawType {
        case .function(let from, let to):
            try .function(
                from: from.map(CanonicalType.init(from:)),
                to: Self(from: to)
            )
        
        case .variable(let name):
            .variable(name)
        
        case .bool:
            .bool
        
        case .nat:
            .nat
        
        case .unit:
            .unit
        
        case .tuple(let elements):
            try .tuple(elements: elements.map(CanonicalType.init(from:)))
        
        case .record(let fields):
            try Self.record(fields:) § Dictionary(
                uniqueKeysWithValues: fields.lazy.map {
                    (key: $0.label, value: $0.type)
                },
                rejectingDuplicateKeysWith: { duplicates in
                    CanonizeError.duplicateRecordTypeFields(duplicates, in: rawType)
                }
            )
            .mapValues(Self.init(from:))
        
        case .sum(let left, let right):
            try .sum(
                left: Self(from: left),
                right: Self(from: right)
            )
        
        case .variant(let cases):
            try Self.variant(cases:) § Dictionary(
                uniqueKeysWithValues: cases.lazy.map {
                    (key: $0.label, value: $0.type)
                },
                rejectingDuplicateKeysWith: { duplicates in
                    CanonizeError.duplicateVariantTypeFields(duplicates, in: rawType)
                }
            )
            .mapValues { rawType throws(CanonizeError) in
                try rawType.map(Self.init(from:))
            }
        
        case .list(let type):
            try .list(Self(from: type))
        
        case .mu(let name, let type):
            try .mu(name, Self(from: type))
        
        case .reference(let type):
            try .reference(Self(from: type))
        
        case .top:
            .top
        
        case .bottom:
            .bottom
        
        case .auto:
            .auto
        
        case .forall(let variables, let type):
            try .forall(
                variables: variables,
                type: Self(from: type)
            )
        }
    }
}

extension Sequence<Declaration.Parameter> {
    func canonized() throws(CanonizeError) -> [(name: Name, type: CanonicalType)] {
        try map { parameter throws(CanonizeError) in
            (
                name: parameter.name,
                type: try CanonicalType(from: parameter.type)
            )
        }
    }
}

enum CanonizeError: Error {
    case duplicateRecordTypeFields([Name], in: RawType)
    case duplicateVariantTypeFields([Name], in: RawType)
}
