import Collections

@MainActor
enum CanonicalType: Sendable, Equatable, Hashable {
    indirect case function(from: [Self], to: Self)

    case bool
    case nat
    case unit

    case tuple(elements: [Self])
    case record(fields: OrderedDictionary<RecordLabel, Self>)

    indirect case sum(left: Self, right: Self)
    case variant(cases: OrderedDictionary<VariantLabel, Self?>)

    indirect case list(Self)

    indirect case reference(Self)

    case top
    case bottom

    case auto(TypeVariableID)
    case freeVariable(TypeName)
    case boundVariable(Int)
    indirect case forall(variableCount: Int, body: Self)
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
            body.abstracting(function.typeVariables)
        }
    }
}

extension CanonicalType {
    func abstracting(_ variables: OrderedSet<TypeName>) -> Self {
        let body = mappingVariables(
            free: { name, depth in
                guard let position = variables.firstIndex(of: name) else {
                    return .freeVariable(name)
                }

                return .boundVariable(depth + variables.count - position - 1)
            },
            bound: { index, _ in
                .boundVariable(index)
            }
        )

        return .forall(variableCount: variables.count, body: body)
    }

    func instantiating(_ arguments: [Self]) -> Self {
        mappingVariables(
            free: { name, _ in
                .freeVariable(name)
            },
            bound: { index, depth in
                let relativeIndex = index - depth

                guard relativeIndex >= 0 else {
                    return .boundVariable(index)
                }

                guard relativeIndex < arguments.count else {
                    return .boundVariable(index - arguments.count)
                }

                return arguments[arguments.count - relativeIndex - 1].shiftingBoundVariables(by: depth)
            }
        )
    }

    private func shiftingBoundVariables(by offset: Int) -> Self {
        guard offset != 0 else {
            return self
        }

        return mappingVariables(
            free: { name, _ in
                .freeVariable(name)
            },
            bound: { index, depth in
                .boundVariable(index >= depth ? index + offset : index)
            }
        )
    }

    private func mappingVariables(
        depth: Int = 0,
        free: (TypeName, Int) -> Self,
        bound: (Int, Int) -> Self
    ) -> Self {
        switch self {
        case .freeVariable(let name):
            free(name, depth)

        case .boundVariable(let index):
            bound(index, depth)

        case .forall(let variableCount, let body):
            .forall(
                variableCount: variableCount,
                body: body.mappingVariables(
                    depth: depth + variableCount,
                    free: free,
                    bound: bound
                )
            )

        case .function(let from, let to):
            .function(
                from: from.map { $0.mappingVariables(depth: depth, free: free, bound: bound) },
                to: to.mappingVariables(depth: depth, free: free, bound: bound)
            )

        case .tuple(let elements):
            .tuple(elements: elements.map { $0.mappingVariables(depth: depth, free: free, bound: bound) })

        case .record(let fields):
            .record(fields: fields.mapValues { $0.mappingVariables(depth: depth, free: free, bound: bound) })

        case .sum(let left, let right):
            .sum(
                left: left.mappingVariables(depth: depth, free: free, bound: bound),
                right: right.mappingVariables(depth: depth, free: free, bound: bound)
            )

        case .variant(let cases):
            Self.variant(cases:) § cases.mapValues {
                $0.map { $0.mappingVariables(depth: depth, free: free, bound: bound) }
            }

        case .list(let element):
            .list(element.mappingVariables(depth: depth, free: free, bound: bound))

        case .reference(let element):
            .reference(element.mappingVariables(depth: depth, free: free, bound: bound))

        default:
            self
        }
    }

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

    consuming func substituting(_ substitutions: [TypeName: CanonicalType]) -> Self {
        mappingVariables(
            free: { name, depth in
                substitutions[name]?.shiftingBoundVariables(by: depth) ?? .freeVariable(name)
            },
            bound: { index, _ in
                .boundVariable(index)
            }
        )
    }

    borrowing func freeVariables(except excluded: Set<TypeName>) -> Set<TypeName> {
        switch self {
        case .freeVariable(let name):
            excluded.contains(name) ? [] : [name]

        case .forall(_, let body):
            body.freeVariables(except: excluded)

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

    init(from rawType: borrowing RawType) throws(CanonizeError) {
        self = try makeCanonicalType(from: rawType, environment: [])

        func makeCanonicalType(from rawType: borrowing RawType, environment: [TypeName]) throws(CanonizeError) -> Self {
            switch rawType {
            case .function(let from, let to):
                try .function(
                    from: from.map { rawType throws(CanonizeError) in
                        try makeCanonicalType(from: rawType, environment: environment)
                    },
                    to: makeCanonicalType(from: to, environment: environment)
                )

            case .bool:
                .bool

            case .nat:
                .nat

            case .unit:
                .unit

            case .tuple(let elements):
                try .tuple(elements: elements.map { rawType throws(CanonizeError) in
                    try makeCanonicalType(from: rawType, environment: environment)
                })

            case .record(let fields):
                try Self.record(fields:) § OrderedDictionary(
                    uniqueKeysWithValues: fields,
                    rejectingDuplicateKeysWith: {
                        CanonizeError.duplicateRecordTypeFields($0, in: copy rawType)
                    }
                )
                .mapValues(try: { rawType throws(CanonizeError) in
                    try makeCanonicalType(from: rawType, environment: environment)
                })

            case .sum(let left, let right):
                try .sum(
                    left: makeCanonicalType(from: left, environment: environment),
                    right: makeCanonicalType(from: right, environment: environment)
                )

            case .variant(let cases):
                try Self.variant(cases:) § OrderedDictionary(
                    uniqueKeysWithValues: cases,
                    rejectingDuplicateKeysWith: {
                        CanonizeError.duplicateVariantTypeFields($0, in: copy rawType)
                    }
                )
                .mapValues(try: { rawType throws(CanonizeError) in
                        try rawType.map { rawType throws(CanonizeError) in
                            try makeCanonicalType(from: rawType, environment: environment)
                        }
                })

            case .list(let type):
                try .list(makeCanonicalType(from: type, environment: environment))

            case .reference(let type):
                try .reference(makeCanonicalType(from: type, environment: environment))

            case .top:
                .top

            case .bottom:
                .bottom

            case .variable(let name):
                if let position = environment.lastIndex(of: name) {
                    .boundVariable(environment.count - position - 1)
                } else {
                    .freeVariable(name)
                }

            case .auto:
                .auto(.new)

            case .forall(let variables, let type):
                try { variables throws(CanonizeError) in
                    try .forall(
                        variableCount: variables.count,
                        body: makeCanonicalType(from: type, environment: environment + variables)
                    )
                } § OrderedSet(
                    variables,
                    rejectingDuplicatesWith: ParametersError.duplicateTypeParameter
                ) <!> {
                    CanonizeError.parametersError($0, in: .forall(typeVariables: variables, returnType: type))
                }
            }
        }
    }
}

extension Sequence<(name: ValueName, rawType: RawType)> {
    @MainActor
    func canonized() throws(CanonizeError) -> some Sequence<(name: ValueName, type: CanonicalType)> {
        try map { name, rawType throws(CanonizeError) in
            (
                name: name,
                type: try CanonicalType(from: rawType)
            )
        }
    }
}

extension Function.Parameters {
    init(from parameters: some Sequence<(name: ValueName, type: CanonicalType)>) throws(ParametersError) {
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

    case duplicateFunctionDeclaration(ValueName)
    case duplicateRecordTypeFields([RecordLabel], in: RawType)
    case duplicateVariantTypeFields([VariantLabel], in: RawType)

    case parametersError(ParametersError, in: Declaration)
}

enum ParametersError: Error {
    case duplicateFunctionParameter(ValueName)
    case duplicateTypeParameter([TypeName])
}
