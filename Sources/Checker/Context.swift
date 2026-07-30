typealias TypeData = [Name: CanonicalType]

struct Context {
    private var data: TypeData
    let extensions: Set<Extension>
    
    init(from declarations: [Declaration], extensions: Set<Extension>) throws(TypeCheckError) {
        data = try TypeData(from: declarations)
        self.extensions = extensions
    }
}

extension Context {
    subscript(_ name: Name) -> CanonicalType {
        get throws(TypeCheckError) {
            guard let type = data[name] else {
                throw .undefinedVariable(name)
            }
            
            return type
        }
    }

    mutating func overlay(by otherData: TypeData) {
        data.merge(otherData, uniquingKeysWith: second)
    }

    func overlaid(by otherData: TypeData) -> Self {
        var copy = self
        copy.overlay(by: otherData)

        return copy
    }

    mutating func overlay(by declarations: [Declaration]) throws(TypeCheckError) {
        let data = try TypeData(from: declarations)
        overlay(by: data)
    }
    
    func overlaid(by declarations: [Declaration]) throws(TypeCheckError) -> Self {
        let data = try TypeData(from: declarations)
        let context = overlaid(by: data)
        
        return context
    }
    
    mutating func overlay(by parameters: [(name: Name, type: CanonicalType)]) throws(ContextError) {
        let data = try TypeData(from: parameters)
        overlay(by: data)
    }
    
    func overlaid(by parameters: some Sequence<(name: Name, type: CanonicalType)>) throws(ContextError) -> Self {
        let data = try TypeData(from: parameters)
        let context = overlaid(by: data)
        
        return context
    }
}

private extension TypeData {
    init(from declarations: [Declaration]) throws(TypeCheckError) {
        self = Dictionary(minimumCapacity: declarations.count)
        
        for case let .function(name, parameters, returnType?, _, _, _) in declarations {
            let type = try CanonicalType.function(
                from: parameters.lazy.map(\.type).map(CanonicalType.init(from:)),
                to: CanonicalType(from: returnType)
            ) <!> TypeCheckError.canonizeError
            
            guard updateValue(type, forKey: name) == nil else {
                throw .duplicateFunctionDeclaration(name)
            }
        }
    }
    
    init(from parameters: some Sequence<(name: Name, type: CanonicalType)>) throws(ContextError) {
        self = Dictionary(minimumCapacity: parameters.underestimatedCount)

        for parameter in parameters {
            guard updateValue(parameter.type, forKey: parameter.name) == nil else {
                throw .duplicateFunctionParameter(parameter.name)
            }
        }
    }
}

enum ContextError: Error {
    case duplicateFunctionParameter(Name)
}
