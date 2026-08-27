import Collections

enum CanonicalType: Sendable, Equatable, Hashable {
    indirect case function(from: [Self], to: Self)

    case bool
    case nat
    case unit

    case tuple(elements: [Self])
    case record(fields: [Label: Self])

    indirect case sum(left: Self, right: Self)
    case variant(cases: [Label: Self?])

    indirect case list(Self)

    indirect case reference(Self)

    case top
    case bottom

    case auto
    case variable(Name)
    indirect case forall(variables: [Name], type: Self)
}

extension CanonicalType {
    static func function(_ function: Function) -> Self {
        .function(
            from: Array.init § function.parameters.values,
            to: function.returnType
        )
    }
    
    init(from rawType: RawType) throws(CanonizeError) {
        self = switch rawType {
        case .function(let from, let to):
            try .function(
                from: from.map(CanonicalType.init(from:)),
                to: Self(from: to)
            )
        
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
                uniqueKeysWithValues: fields.lazy.map { label, type in
                    (key: label, value: type)
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
                uniqueKeysWithValues: cases.lazy.map { label, type in
                    (key: label, value: type)
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
        
        case .reference(let type):
            try .reference(Self(from: type))
        
        case .top:
            .top
        
        case .bottom:
            .bottom
            
        case .variable(let name):
            .variable(name)
        
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

extension Sequence<(name: Name, rawType: RawType)> {
    func canonized() throws(CanonizeError) -> some Sequence<(name: Name, type: CanonicalType)> {
        try map { name, rawType throws(CanonizeError) in
            (
                name: name,
                type: try CanonicalType(from: rawType)
            )
        }
    }
}

extension Function.Parameters {
    init(from parameters: some Sequence<(name: Name, type: CanonicalType)>) throws(ParametersError) {
        self = OrderedDictionary(minimumCapacity: parameters.underestimatedCount)

        for parameter in parameters {
            guard updateValue(parameter.type, forKey: parameter.name) == nil else {
                throw .duplicateFunctionParameter(parameter.name)
            }
        }
    }
}

enum CanonizeError: Error {
    case unsupported(code: String? = nil, message: String? = nil)
    
    case duplicateFunctionDeclaration(Name)
    case duplicateRecordTypeFields([Label], in: RawType)
    case duplicateVariantTypeFields([Label], in: RawType)

    case parametersError(ParametersError, in: Declaration)
}

enum ParametersError: Error {
    case duplicateFunctionParameter(Name)
    case duplicateTypeParameter([Name])
}
