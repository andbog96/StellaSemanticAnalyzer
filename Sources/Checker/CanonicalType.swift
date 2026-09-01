import Collections

@MainActor
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

    case auto(TypeVariableID)
    case variable(Name)
    indirect case forall(variables: OrderedSet<Name>, body: Self)
}

extension CanonicalType {
    static func function(_ function: Function) -> Self {
        let body = Self.function(
            from: Array.init § function.parameters.values,
            to: function.returnType
        )

        return if function.typeVariables.isEmpty {
            body
        } else {
            .forall(variables: function.typeVariables, body: body)
        }
    }
}

extension CanonicalType {
    var containsAutoType: Bool {
        switch self {
        case .auto:
            true

        case .function(let parameters, let result):
            parameters.contains(where: \.containsAutoType) || result.containsAutoType

        case .tuple(let elements):
            elements.contains(where: \.containsAutoType)

        case .record(let fields):
            fields.values.contains(where: \.containsAutoType)

        case .sum(let left, let right):
            left.containsAutoType || right.containsAutoType

        case .variant(let cases):
            cases.compactMap(\.value).contains(where: \.containsAutoType)

        case .list(let element), .reference(let element):
            element.containsAutoType

        case .forall(_, let body):
            body.containsAutoType

        default:
            false
        }
    }

    func substituting(_ substitutions: [Name: CanonicalType]) -> Self {
        switch self {
        case .variable(let name):
            substitutions[name] ?? self

        case .forall(let variables, let body):
            .forall(
                variables: variables,
                body: body.substituting(substitutions.filter(not • variables.contains • \.key))
            )

        case .function(let from, let to):
            .function(
                from: from.map { $0.substituting(substitutions) },
                to: to.substituting(substitutions)
            )

        case .tuple(let elements):
            .tuple(elements: elements.map { $0.substituting(substitutions) })

        case .record(let fields):
            .record(fields: fields.mapValues { $0.substituting(substitutions) })

        case .sum(let left, let right):
            .sum(
                left: left.substituting(substitutions),
                right: right.substituting(substitutions)
            )

        case .variant(let cases):
            .variant(cases: cases.mapValues { $0.map { $0.substituting(substitutions) } })

        case .list(let element):
            .list(element.substituting(substitutions))

        case .reference(let value):
            .reference(value.substituting(substitutions))

        default:
            self
        }
    }

    func freeVariables(except excluded: Set<Name>) -> Set<Name> {
        switch self {
        case .variable(let name):
            excluded.contains(name) ? [] : [name]

        case .forall(let variables, let body):
            body.freeVariables(except: excluded.union(variables))

        case .function(let from, let to):
            from
            .lazy
            .map { $0.freeVariables(except: excluded) }
            .reduce(to.freeVariables(except: excluded), Set.union)

        case .tuple(let elements):
            elements
            .lazy
            .map { $0.freeVariables(except: excluded) }
            .reduce([], Set.union)

        case .record(let fields):
            fields.values
            .lazy
            .map { $0.freeVariables(except: excluded) }
            .reduce([], Set.union)

        case .sum(let left, let right):
            CollectionOfTwo(left, right)
            .lazy
            .map { $0.freeVariables(except: excluded) }
            .reduce([], Set.union)

        case .variant(let cases):
            cases.values
            .lazy
            .compactMap { $0?.freeVariables(except: excluded) }
            .reduce([], Set.union)

        case .list(let element),
             .reference(let element):
            element.freeVariables(except: excluded)

        default:
            []
        }
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
            .auto(.new)

        case .forall(let variables, let type):
            try .forall(
                variables: try OrderedSet(
                    variables,
                    rejectingDuplicatesWith: ParametersError.duplicateTypeParameter
                ) <!> {
                    CanonizeError.parametersError($0, in: .forall(typeVariables: variables, returnType: type))
                },
                body: Self(from: type)
            )
        }
    }
}

extension Sequence<(name: Name, rawType: RawType)> {
    @MainActor
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

        for (name, type) in parameters {
            guard updateValue(type, forKey: name) == nil else {
                throw .duplicateFunctionParameter(name)
            }
        }
    }
}

enum CanonizeError: Error {
    case unsupported(message: String)
    case undefined(code: String)

    case duplicateFunctionDeclaration(Name)
    case duplicateRecordTypeFields([Label], in: RawType)
    case duplicateVariantTypeFields([Label], in: RawType)

    case parametersError(ParametersError, in: Declaration)
}

enum ParametersError: Error {
    case duplicateFunctionParameter(Name)
    case duplicateTypeParameter([Name])
}
