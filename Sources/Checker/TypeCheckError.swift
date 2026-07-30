enum TypeCheckError: Error {
    case missingMain
    case undefinedVariable(Name)

    case notAFunction(actual: CanonicalType, in: Expression)
    case notATuple(actual: CanonicalType, in: Expression)
    case notARecord(actual: CanonicalType, in: Expression)
    case notAList(actual: CanonicalType, in: Expression)

    case unexpectedLambda(expected: CanonicalType, in: Expression)
    case unexpectedParameterType(
        actual: CanonicalType,
        expected: CanonicalType,
        name: Name,
        callee: CanonicalType,
        in: Expression
    )
    case unexpectedTuple(expected: CanonicalType, in: Expression)
    case unexpectedRecord(expected: CanonicalType, in: Expression)
    case unexpectedVariant(expected: CanonicalType, in: Expression)
    case unexpectedList(expected: CanonicalType, in: Expression)
    case unexpectedInjection(expected: CanonicalType, in: Expression)

    case missingRecordFields(fields: [Name], type: CanonicalType, in: Expression)
    case unexpectedRecordFields(fields: [Name], type: CanonicalType, in: Expression)
    case unexpectedFieldAccess(field: Name, type: CanonicalType, in: Expression)
    case unexpectedVariantLabel(label: Name, expected: CanonicalType, in: Expression)
    case tupleIndexOutOfBounds(index: Int, type: CanonicalType, in: Expression)

    case ambiguosSumType(in: Expression)
    case ambiguosVariantType(in: Expression)
    case ambiguosList(in: Expression)

    case illegalEmptyMatch(in: Expression)
    case nonexhaustiveMatchPatterns(for: CanonicalType, in: Expression)
    case duplicateRecordFields([Name], in: Expression)
    case duplicateFunctionDeclaration(Name)

    case duplicateTypeParameter(Name, in: Declaration)

    case incorrectMainArity(Int)
    case incorrectArgumentsNumber(actual: Int, expected: Int, type: CanonicalType, in: Expression)
    case unexpectedParametersNumber(actual: Int, expected: Int, type: CanonicalType, in: Expression)

    case unexpectedDataForNullaryLabel(Name, expected: CanonicalType, in: Expression)
    case missingData(name: Name, type: CanonicalType, expected: CanonicalType, in: Expression)
    
    // Этап 2
    case exceptionTypeNotDeclared(in: Expression)
    case ambiguousThrowType(in: Expression)
    case ambiguousReferenceType(in: Expression)
    case ambiguousPanicType(in: Expression)
    case notAReference(actual: CanonicalType, in: Expression)
    case unexpectedMemoryAddress(in: Expression)
    case unexpectedReference(expected: CanonicalType, in: Expression)
    case unexpectedSubtype(CanonicalType, ofSupertype: CanonicalType, in: Expression)
    
    // Этап 2, допы
    case duplicateExceptionType(CanonicalType, in: Expression)
    case duplicateExceptionVariant(label: Name, in: Expression)
    case conflictingExceptionDeclarations(in: Expression)
    case illegalLocalExceptionType(in: Expression)
    case illegalLocalOpenVariantException(in: Expression)
    
    case canonizeError(CanonizeError)
    case contextError(ContextError, in: Declaration)
    case unifyError(UnifyError, in: Expression)
    case patternMatchError(PatternMatchError)
}

extension TypeCheckError {
    var code: String {
        switch self {
        case .missingMain: "ERROR_MISSING_MAIN"
        case .undefinedVariable: "ERROR_UNDEFINED_VARIABLE"
        case .notAFunction: "ERROR_NOT_A_FUNCTION"
        case .notATuple: "ERROR_NOT_A_TUPLE"
        case .notARecord: "ERROR_NOT_A_RECORD"
        case .notAList: "ERROR_NOT_A_LIST"
        case .unexpectedLambda: "ERROR_UNEXPECTED_LAMBDA"
        case .unexpectedParameterType: "ERROR_UNEXPECTED_TYPE_FOR_PARAMETER"
        case .unexpectedTuple: "ERROR_UNEXPECTED_TUPLE"
        case .unexpectedRecord: "ERROR_UNEXPECTED_RECORD"
        case .unexpectedVariant: "ERROR_UNEXPECTED_VARIANT"
        case .unexpectedList: "ERROR_UNEXPECTED_LIST"
        case .unexpectedInjection: "ERROR_UNEXPECTED_INJECTION"
        case .missingRecordFields: "ERROR_MISSING_RECORD_FIELDS"
        case .unexpectedRecordFields: "ERROR_UNEXPECTED_RECORD_FIELDS"
        case .unexpectedFieldAccess: "ERROR_UNEXPECTED_FIELD_ACCESS"
        case .unexpectedVariantLabel: "ERROR_UNEXPECTED_VARIANT_LABEL"
        case .tupleIndexOutOfBounds: "ERROR_TUPLE_INDEX_OUT_OF_BOUNDS"
        case .ambiguosSumType: "ERROR_AMBIGUOUS_SUM_TYPE"
        case .ambiguosVariantType: "ERROR_AMBIGUOUS_VARIANT_TYPE"
        case .ambiguosList: "ERROR_AMBIGUOUS_LIST"
        case .illegalEmptyMatch: "ERROR_ILLEGAL_EMPTY_MATCHING"
        case .nonexhaustiveMatchPatterns: "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS"
        case .duplicateRecordFields: "ERROR_DUPLICATE_RECORD_FIELDS"
        case .duplicateFunctionDeclaration: "ERROR_DUPLICATE_FUNCTION_DECLARATION"
        case .duplicateTypeParameter: "ERROR_DUPLICATE_TYPE_PARAMETER"
        case .incorrectMainArity: "ERROR_INCORRECT_ARITY_OF_MAIN"
        case .incorrectArgumentsNumber: "ERROR_INCORRECT_NUMBER_OF_ARGUMENTS"
        case .unexpectedParametersNumber: "ERROR_UNEXPECTED_NUMBER_OF_PARAMETERS_IN_LAMBDA"
        case .unexpectedDataForNullaryLabel: "ERROR_UNEXPECTED_DATA_FOR_NULLARY_LABEL"
        case .missingData: "ERROR_MISSING_DATA_FOR_LABEL"
        case .exceptionTypeNotDeclared: "ERROR_EXCEPTION_TYPE_NOT_DECLARED"
        case .ambiguousThrowType: "ERROR_AMBIGUOUS_THROW_TYPE"
        case .ambiguousReferenceType: "ERROR_AMBIGUOUS_REFERENCE_TYPE"
        case .ambiguousPanicType: "ERROR_AMBIGUOUS_PANIC_TYPE"
        case .notAReference: "ERROR_NOT_A_REFERENCE"
        case .unexpectedMemoryAddress: "ERROR_UNEXPECTED_MEMORY_ADDRESS"
        case .unexpectedReference: "ERROR_UNEXPECTED_REFERENCE"
        case .unexpectedSubtype: "ERROR_UNEXPECTED_SUBTYPE"
        case .duplicateExceptionType: "ERROR_DUPLICATE_EXCEPTION_TYPE"
        case .duplicateExceptionVariant: "ERROR_DUPLICATE_EXCEPTION_VARIANT"
        case .conflictingExceptionDeclarations: "ERROR_CONFLICTING_EXCEPTION_DECLARATIONS"
        case .illegalLocalExceptionType: "ERROR_ILLEGAL_LOCAL_EXCEPTION_TYPE"
        case .illegalLocalOpenVariantException: "ERROR_ILLEGAL_LOCAL_OPEN_VARIANT_EXCEPTION"
            
        // MARK: - CanonizeError
        case .canonizeError(.duplicateRecordTypeFields): "ERROR_DUPLICATE_RECORD_TYPE_FIELDS"
        case .canonizeError(.duplicateVariantTypeFields): "ERROR_DUPLICATE_VARIANT_TYPE_FIELDS"
            
        // MARK: - ContextError
        case .contextError(.duplicateFunctionParameter, _): "ERROR_DUPLICATE_FUNCTION_PARAMETER"
            
        // MARK: - UnifyError
        case .unifyError(.unexpectedType, _): "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION"
        case .unifyError(.unexpectedTupleLength, _): "ERROR_UNEXPECTED_TUPLE_LENGTH"
            
        // MARK: - PatternMatchError
        case .patternMatchError(.unexpectedPattern): "ERROR_UNEXPECTED_PATTERN_FOR_TYPE"
        case .patternMatchError(.duplicateLetBinding): "ERROR_DUPLICATE_LET_BINDING"
        case .patternMatchError(.duplicateRecordPatternFields): "ERROR_DUPLICATE_RECORD_PATTERN_FIELDS"
        case .patternMatchError(.unexpectedNonNullaryVariantPattern): "ERROR_UNEXPECTED_NON_NULLARY_VARIANT_PATTERN"
        case .patternMatchError(.unexpectedNullaryVariantPattern): "ERROR_UNEXPECTED_NULLARY_VARIANT_PATTERN"
        }
    }
}

extension TypeCheckError {
    var message: String {
        switch self {
        case .missingMain:
            "main function is missing from the program"
        case let .incorrectMainArity(n):
            "main function must have one and only one parameter, instead it has \(n)"
        case let .undefinedVariable(name):
            "Undefined variable: \(name)"
        case let .notAFunction(actualType, in: expression):
            """
            Expression is expected to have a function type
            But instead it's type is: \(actualType)
            In expression:
                \(indented: expression)
            """
        case let .incorrectArgumentsNumber(actual, expected, type: calleeType, in: expression):
            """
            Was expecting \(expected) argument\(expected != 1 ? "s" : ""), \
            instead got \(actual) argument\(actual != 1 ? "s" : "")
            For the function of type: \(calleeType)
            In expression: 
                \(indented: expression)
            """
        case let .unexpectedLambda(expected: type, in: expression):
            """
            Expected type: \(type) 
            cannot be assigned to lambda: 
                \(indented: expression)
            """
        case let .unexpectedParametersNumber(actual, expected, type: calleeType, in: expression):
            """
            Expected \(expected) parameter\(expected != 1 ? "s" : ""), \
            instead got \(actual) parameter\(actual != 1 ? "s" : "")
            For type: \(calleeType)
            In expression: \(expression)
            """
        case let .unexpectedParameterType(type, expected, name, calleeType, in: expression):
            """
            Unexpected type for parameter \(name) 
            Expecting type: \(expected)
            Actual type: \(type)
            For overall function type: \(calleeType)
            In lambda expression: \(expression)
            """
        case let .notATuple(actualType, in: expression):
            """
            Expected a tuple type instead of:
                \(indented: actualType)
            In expression:
                \(indented: expression)
            """
        case let .tupleIndexOutOfBounds(index, type, in: expression):
            """
            Unexpected index: \(index)
            for a tuple of type: \(type)
            In expression: \(expression)
            """
        case let .unexpectedTuple(expectedType, in: expression):
            """
            Expected type: \(expectedType)
            cannot be assigned to tuple expression: \(expression)
            """
        case let .notARecord(actualType, in: expression):
            """
            Expected a record type instead of: \(actualType)
            In expression: \(expression)
            """
        case let .unexpectedFieldAccess(name, type, in: expression):
            """
            Unexpected field name: '\(name)'
            for a record of type: \(type)
            In expression: \(expression)
            """
        case let .unexpectedRecord(expectedType, in: expression):
            """
            Expected type: \(expectedType)
            cannot be assigned to record expression: \(expression)
            """
        case let .missingRecordFields(fields, type, in: expression):
            """
            Missing record fields: \(fields)
            Required by type: \(type)
            In expression: \(expression)
            """
        case let .unexpectedRecordFields(fields, type, in: expression):
            """
            Extra record fields: \(fields)
            Required by type: \(type)
            In expression: \(expression)
            """
        case let .duplicateRecordFields(fields, in: expression):
            """
            Duplicate record fields: \(fields)
            In expression: \(expression)
            """
        case let .duplicateFunctionDeclaration(id):
            """
            Duplicate function declaration: \(id)
            """
        case let .duplicateTypeParameter(id, in: declaration):
            """
            Duplicate type parameter: \(id)
            In declaration: \(declaration)
            """
        case let .illegalEmptyMatch(in: expression):
            """
            Match expression with zero alternatives: 
                \(indented: expression)
            """
        case let .unexpectedInjection(expected, in: expression):
            """
            Unexpected inl or inr tag: \(expression)
            Expected expression of type: \(expected)
            """
        case let .ambiguosSumType(in: expression):
            """
            Cannot infer the other half of the sum type expression: \(expression)
            """
        case let .nonexhaustiveMatchPatterns(type, in: expression):
            """
            Not all cases of type: \(type)
            Are covered by: \(expression)
            """
        case let .unexpectedList(expected, in: expression):
            """
            Expected expression of type: \(expected)
            Instead of a list: \(expression)
            """
        case let .ambiguosList(in: expression):
            """
            Cannot infer type of the list: \(expression)
            """
        case let .notAList(actual, in: expression):
            """
            Actual type: \(actual)
            Is not a list type, which is required in:
                \(indented: expression)
            """
        case let .unexpectedVariant(expected, in: expression):
            """
            Expected expression of type: \(expected)
            Instead of a variant expresssion: \(expression)
            """
        case let .ambiguosVariantType(in: expression):
            """
            Cannot infer type of a variant expression: \(expression)
            """
        case let .unexpectedVariantLabel(label, expectedType, in: expression):
            """
            Variant label: '\(label)' wasn't expected 
            for a variant type: \(expectedType)
            In expression: \(expression)
            """
        case let .missingData(tag, type, expected, in: expression):
            """
            Variant label: '\(tag)' is a null label, 
            but expression of type: \(type)
            was expected for a variant type: \(expected)
            In expression: \(expression)
            """
        case let .unexpectedDataForNullaryLabel(name, expectedType, in: expression):
            """
            Null variant label: '\(name)' contains an expression, but it shouldn't
            for a variant of type: \(expectedType)
            In expresssion: \(expression)
            """
        case let .exceptionTypeNotDeclared(in: expression):
            """
            No exception is declared, but exceptions are used in:
                \(indented: expression)
            """
        case let .ambiguousThrowType(in: expression):
            """
            Cannot infer type for a throw expression:
                \(indented: expression)
            """
        case let .ambiguousReferenceType(in: expression):
            """
            Cannot infer type for a reference expression:
                \(indented: expression)
            """
        case let .ambiguousPanicType(in: expression):
            """
            Cannot infer type for a panic expression: 
                \(indented: expression)
            """
        case let .notAReference(actual, in: expression):
            """
            Expected an expression of a reference type, 
            instead have expression of type: \(actual)
            In expression:
                \(indented: expression)
            """
        case let .unexpectedMemoryAddress(in: expression):
            """
            адрес памяти (ConstMemory) используется там, где ожидается
            тип, отличный от типа-ссылки (TypeRef);
            expression: \(expression)
            """
        case let .unexpectedReference(expected, in: expression):
            """
            Was expecting an expression of type: \(expected)
            Instead got: \(expression)
            """
        case let .unexpectedSubtype(subtype, supertype, in: expression):
            """
            Type: \(subtype)
            Is not a subtype of: \(supertype)
            In expression:
                \(indented: expression)
            """
        case let .duplicateExceptionType(type, in: expression):
            """
            в одной области видимости объявлено более одного типа
            исключений ( #exception-type-declaration ) (допускается только одно объявление)
            type: \(type)
            expression: \(expression) 
            """
        case .duplicateExceptionVariant(let label, let expression):
            """
            повторяющаяся метка варианта в декларациях 
            исключений с открытым вариантом ( #open-variant-exceptions )
            label: \(label)
            expression: \(expression) 
            """
        case let .conflictingExceptionDeclarations(in: expression):
            """
            в одной области видимости присутствуют и
            декларация exception type, и декларации exception variant (их нельзя смешивать)
            expression: \(expression) 
            """
        case let .illegalLocalExceptionType(in: expression):
            """
            декларация типа исключения ( #exception-type-declaration )
            в недопустимой (например, локальной) области видимости
            expression: \(expression) 
            """
        case let .illegalLocalOpenVariantException(in: expression):
            """
            декларация исключения с открытым вариантом ( #open-variant-exceptions ) 
            в недопустимой (например, локальной) области видимости
            expression: \(expression) 
            """
            
        // MARK: - CanonizeError
        case .canonizeError(.duplicateRecordTypeFields(let fields, let type)):
            """
            Duplicate record fields: \(fields)
            In type: \(type)
            """
        case .canonizeError(.duplicateVariantTypeFields(let tags, let type)):
            """
            Duplicate variant tags: \(tags)
            In a variant type: \(type)
            """
            
        // MARK: - ContextError
        case .contextError(.duplicateFunctionParameter(let id), let declaration):
            """
            Duplicate function parameter: \(id)
            In declaration: \(declaration)
            """
            
        // MARK: - UnifyError
        case .unifyError(.unexpectedType(let actual, let expected), let expression):
            """
            Expected type: \(expected)
            Instead have: \(actual)
            In expression: 
                \(indented: expression)
            """
        case .unifyError(.unexpectedTupleLength(let actual, let expected, let type), let expression):
            """
            Unexpected lenght of tuple: \(actual), 
            expecting length \(expected), because of type:
                \(indented: type)
            In expression: \(expression)
            """
            
        // MARK: - PatternMatchError
        case .patternMatchError(.unexpectedPattern(let pattern, let type)):
            """
            Pattern: \(pattern)
            cannot be used to match against type: \(type)
            """
        case .patternMatchError(.duplicateLetBinding(let id, in: let pattern)):
            """
            Duplicate let binding: \(id.lazy.map(String.init).joined(separator: ", "))
            In pattern: \(pattern)
            """
        case .patternMatchError(.duplicateRecordPatternFields(let fields, in: let pattern)):
            """
            Duplicate record fields: \(fields)
            In pattern: \(pattern)
            """
        case .patternMatchError(.unexpectedNullaryVariantPattern(let tag, let missedType, let pattern, let type)):
            """
            Pattern: \(pattern) 
            suggests that a variant label: '\(tag)' must be a nullary label
            but is should match the type: \(missedType)
            according to the matching type: \(type)
            """
        case .patternMatchError(.unexpectedNonNullaryVariantPattern(let tag, let pattern, let type)):
            """
            Pattern: \(pattern)
            provides a pattern to match for a label: '\(tag)', 
            but this tag must be null according to a matching type: \(type)
            """
        }
    }
}

extension TypeCheckError: CustomStringConvertible {
    public var description: String {
        code + "\n" + message
    }
}
