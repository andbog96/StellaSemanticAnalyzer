enum Exception {
    case type(CanonicalType)
    case variant([Name: CanonicalType])
}

extension Exception {
    init?(from declarations: [Declaration]) throws(TypeCheckError) {
        var result = nil as Self?
        
        for declaration in declarations {
            switch (result, declaration) {
            case (nil, .exceptionType(let rawType)):
                let type = try CanonicalType(from: rawType) <!> TypeCheckError.canonizeError
                
                result = .type(type)

            case (nil, .exceptionVariant(let label, let rawType)):
                let type = try CanonicalType(from: rawType) <!> TypeCheckError.canonizeError
                
                result = .variant([label: type])

            case (.variant(var cases), .exceptionVariant(let label, let rawType)):
                let type = try CanonicalType(from: rawType) <!> TypeCheckError.canonizeError
                
                guard cases.updateValue(type, forKey: label) == nil else {
                    throw .duplicateExceptionVariant(label: label)
                }
                
                result = .variant(cases)
            
            case (.type, .exceptionType):
                throw .duplicateExceptionType
                
            case (.variant, .exceptionType),
                 (.type, .exceptionVariant):
                throw .conflictingExceptionDeclarations

            case (_, .function):
                continue
            }
        }
        
        guard let result else {
            return nil
        }
        
        self = result
    }
}

extension CanonicalType {
    init(_ exception: Exception) {
        self = switch exception {
        case .type(let type):
            type
            
        case .variant(let cases):
            .variant(cases: cases)
        }
    }
}
