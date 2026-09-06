import Collections

extension Context {
    @MainActor
    func match(
        _ pattern: consuming Pattern,
        against type: consuming CanonicalType
    ) throws(PatternError) -> ValueData {
        func duplicateLetBindingError(in pattern: consuming Pattern) -> (_ duplicates: [ValueName]) -> PatternError {
            { .duplicateLetBinding($0, in: pattern) }
        }
        
        switch (pattern, type) {
        // MARK: - var
        case (.var(let name), _):
            return ValueData(name: name, type: type)

        // MARK: - Bool
        case (.false, .bool),
             (.true, .bool):
            return nil

        // MARK: - Nat
        case (.zero, .nat):
            return nil

        case (.succ(let pattern), .nat):
            return try match(pattern, against: .nat)

        // MARK: - Unit
        case (.unit, .unit):
            return nil

        // MARK: - tuple
        case (.tuple(let patterns), .tuple(let types))
            where patterns.count == types.count:
            return try zip(patterns, types)
                .map { pattern, type throws(PatternError) in
                    try match(pattern, against: type)
                }
                .fold(rejectingDuplicateNamesWith: duplicateLetBindingError(in: pattern))

        // MARK: - record
        case (.record(let patterns), .record(let types))
            where patterns.count == types.count:
            
            let patterns = try Dictionary(
                uniqueKeysWithValues: patterns,
                rejectingDuplicateKeysWith: {
                    PatternError.duplicateRecordPatternFields($0, in: pattern)
                }
            )

            return try patterns
                .map { label, pattern throws(PatternError) in
                    guard let type = types[label] else {
                        throw .unexpectedPattern(
                            .record(fields: [(label: label, pattern: pattern)]),
                            for: copy type
                        )
                    }

                    return try match(pattern, against: type)
                }
                .fold(rejectingDuplicateNamesWith: duplicateLetBindingError(in: pattern))

        // MARK: - sum
        case (.inl(let pattern), .sum(let type, _)),
             (.inr(let pattern), .sum(_, let type)):
            return try match(pattern, against: type)

        // MARK: - Variant
        case (.variant(let label, let payloadPattern), .variant(let cases)):
            guard let caseType = cases[label] else {
                throw .unexpectedPattern(pattern, for: type)
            }
            
            switch (payloadPattern, caseType) {
            case (nil, nil):
                return nil

            case (nil, let payloadType?):
                throw .unexpectedNullaryVariantPattern(label, expected: payloadType, pattern, in: type)

            case (let payloadPattern?, nil):
                throw .unexpectedNonNullaryVariantPattern(label, payloadPattern, in: type)

            case (let payloadPattern?, let payloadType?):
                return try match(payloadPattern, against: payloadType)
            }

        // MARK: - List
        case (.list(let patterns), .list(let elementType)):
            return try patterns
                .map { pattern throws(PatternError) in
                    try match(pattern, against: elementType)
                }
                .fold(rejectingDuplicateNamesWith: duplicateLetBindingError(in: pattern))

        case (.cons(let headPattern, let tailPattern), .list(let elementType)):
            return try CollectionOfTwo(
                try match(headPattern, against: elementType),
                try match(tailPattern, against: .list(elementType))
            )
            .fold(rejectingDuplicateNamesWith: duplicateLetBindingError(in: pattern))

        // MARK: - as, cast
        case (.ascription(let castPattern, let rawType), _):
            let castType = try CanonicalType(from: rawType) <!> PatternError.canonizeError

            // upcast
            try constrain(type, to: castType) <!> PatternError.constrainError(pattern, for: type)

            return try match(castPattern, against: castType)

        case (.cast(let castPattern, let rawType), _):
            let castType = try CanonicalType(from: rawType) <!> PatternError.canonizeError

            // downcast
            try constrain(castType, to: type) <!> PatternError.constrainError(pattern, for: type)

            return try match(castPattern, against: castType)

        default:
            throw .unexpectedPattern(pattern, for: type)
        }
    }

    func inferredType(
        from pattern: borrowing Pattern
    ) throws(PatternError) -> CanonicalType? {
        func inferredOrAuto(from pattern: borrowing Pattern) throws(PatternError) -> CanonicalType {
            try inferredType(from: pattern) ?? .auto(.new)
        }

        return switch pattern {
        case .var:
            nil

        case .false,
             .true:
            .bool

        case .zero,
             .succ:
            .nat

        case .unit:
            .unit

        case .tuple(let patterns):
            .tuple(elements: try patterns.map(inferredOrAuto(from:)))

        case .record(let fields):
            try CanonicalType.record(fields:) § OrderedDictionary(
                uniqueKeysWithValues: fields,
                rejectingDuplicateKeysWith: {
                    PatternError.duplicateRecordPatternFields($0, in: copy pattern)
                }
            )
            .mapValues(try: inferredOrAuto(from:))

        case .inl(let payload):
            .sum(
                left: try inferredOrAuto(from: payload),
                right: .auto(.new)
            )

        case .inr(let payload):
            .sum(
                left: .auto(.new),
                right: try inferredOrAuto(from: payload)
            )

        case .variant:
            nil

        case .list,
             .cons:
            .list(.auto(.new))

        case .ascription(_, let rawType),
             .cast(_, let rawType):
            try CanonicalType(from: rawType) <!> PatternError.canonizeError
        }
    }

    func annotatedType(
        of pattern: borrowing Pattern
    ) throws(PatternError) -> CanonicalType {
        switch pattern {
        case .ascription(_, let rawType):
            try CanonicalType(from: rawType)
                <!> PatternError.canonizeError

        case .tuple(let patterns):
            .tuple(elements: try patterns.map(annotatedType(of:)))

        case .record(let fields):
            try CanonicalType.record(fields:) § OrderedDictionary(
                uniqueKeysWithValues: fields,
                rejectingDuplicateKeysWith: {
                    PatternError.duplicateRecordPatternFields($0, in: copy pattern)
                }
            )
            .mapValues(try: annotatedType(of:))

        case .false,
             .true:
            .bool

        case .zero,
             .succ:
            .nat

        case .unit:
            .unit

        default:
            throw .ambiguousPatternType(copy pattern)
        }
    }
}

enum PatternError: Error {
    case unexpectedPattern(Pattern, for: CanonicalType)

    case duplicateLetBinding([ValueName], in: Pattern)
    case duplicateRecordPatternFields([RecordLabel], in: Pattern)
    case unexpectedNonNullaryVariantPattern(VariantLabel, Pattern, in: CanonicalType)
    case unexpectedNullaryVariantPattern(VariantLabel, expected: CanonicalType, Pattern, in: CanonicalType)
    case ambiguousPatternType(Pattern)

    case canonizeError(CanonizeError)
    case subtypeError(SubtypeError)
    case unifyError(UnifyError)
}

extension PatternError {
    static func constrainError(
        _ pattern: Pattern,
        for type: CanonicalType
    ) -> (ConstrainError) -> Self {
        { error in
            switch error {
            case .subtypeError(let error):
                .subtypeError(error)
            case .unifyError(let error):
                .unifyError(error)
            case .unexpectedType:
                .unexpectedPattern(pattern, for: type)
            }
        }
    }
}
