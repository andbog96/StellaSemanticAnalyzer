@MainActor
enum Exception {
    case type(CanonicalType)
    case variant([VariantLabel: CanonicalType])
}

extension Exception {
    init?(from declarations: [Declaration]) throws(SemanticError) {
        var result = nil as Self?

        for declaration in declarations {
            switch (result, declaration) {
            case (nil, .exceptionType(let rawType)):
                let type = try CanonicalType(from: rawType) <!> SemanticError.canonizeError

                result = .type(type)

            case (nil, .exceptionVariant(let label, let rawType)):
                let type = try CanonicalType(from: rawType) <!> SemanticError.canonizeError

                result = .variant([label: type])

            case (.variant(var cases), .exceptionVariant(let label, let rawType)):
                let type = try CanonicalType(from: rawType) <!> SemanticError.canonizeError

                guard cases.updateValue(type, forKey: label) == nil else {
                    throw .duplicateExceptionVariant(label)
                }

                result = .variant(cases)

            case (.type, .exceptionType):
                throw .duplicateExceptionType

            case (.variant, .exceptionType),
                 (.type, .exceptionVariant):
                throw .conflictingExceptionDeclarations

            case (_, .function(_, _, _, _, _, let declarations, _)):
                let exception = try Exception(from: declarations)

                switch exception {
                case .type:
                    throw .illegalLocalExceptionType
                case .variant:
                    throw .illegalLocalOpenVariantException
                case nil:
                    break
                }
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
