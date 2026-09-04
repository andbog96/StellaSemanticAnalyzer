@MainActor
struct ValueData {
    fileprivate var data = [:] as [ValueName: CanonicalType]
}

extension ValueData: @MainActor ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.data = [:]
    }
}

extension ValueData {
    var names: some Sequence<ValueName> {
        data.keys
    }

    init(name: ValueName, type: CanonicalType) {
        data = [name: type]
    }

    subscript(_ name: ValueName) -> CanonicalType {
        get throws(SemanticError) {
            guard let type = data[name] else {
                throw .undefinedVariable(name)
            }

            return type
        }
    }

    mutating func shadow(by otherData: ValueData) {
        data.merge(otherData.data, uniquingKeysWith: second)
    }
}

extension Sequence<ValueData> {
    func fold<E: Error>(
        rejectingDuplicateNamesWith duplicateNamesError: (_ duplicateNames: [ValueName]) -> E
    ) throws(E) -> ValueData {
        try ValueData.init(data:) § Dictionary(
            uniqueKeysWithValues: lazy.flatMap(\.data),
            rejectingDuplicateKeysWith: duplicateNamesError
        )
    }
}

extension ValueData {
    init(_ functions: Functions) {
        data = functions.mapValues(CanonicalType.function)
    }
    
    mutating func shadow(by functions: Functions) {
        shadow(by: ValueData(functions))
    }
    
    mutating func shadow(by parameters: Function.Parameters) {
        shadow(
            by: ValueData.init • Dictionary.init(uniqueKeysWithValues:) § parameters.lazy.map(identity)
        )
    }
}
