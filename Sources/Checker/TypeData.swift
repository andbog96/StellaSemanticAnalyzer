struct TypeData {
    fileprivate var data = [:] as [Name: CanonicalType]
}

extension TypeData: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.data = [:]
    }
}

extension TypeData {
    var names: some Sequence<Name> {
        data.keys
    }

    init(name: Name, type: CanonicalType) {
        data = [name: type]
    }

    subscript(_ name: Name) -> CanonicalType {
        get throws(TypeCheckError) {
            guard let type = data[name] else {
                throw .undefinedVariable(name)
            }

            return type
        }
    }

    mutating func overlay(by otherData: TypeData) {
        data.merge(otherData.data, uniquingKeysWith: second)
    }
}

extension Sequence<TypeData> {
    func fold<E: Error>(
        rejectingDuplicateNamesWith duplicateNamesError: (_ duplicateNames: [Name]) -> E
    ) throws(E) -> TypeData {
        try TypeData.init(data:) § Dictionary(
            uniqueKeysWithValues: lazy.flatMap(\.data),
            rejectingDuplicateKeysWith: duplicateNamesError
        )
    }
}

extension TypeData {
    init(_ functions: Functions) {
        data = functions.mapValues(CanonicalType.function)
    }
    
    mutating func overlay(by functions: Functions) {
        overlay(by: TypeData.init § functions)
    }
    
    mutating func overlay(by parameters: Function.Parameters) {
        overlay(
            by: TypeData.init • Dictionary.init(uniqueKeysWithValues:) § parameters.lazy.map(identity)
        )
    }
}
