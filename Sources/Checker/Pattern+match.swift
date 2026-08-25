extension Pattern {
    consuming func match(against type: consuming CanonicalType) throws(PatternError) -> TypeData {
        switch (self, type) {
        // MARK: - var
        case (.var(let name), _):
            return TypeData(name: name, type: type)

        // MARK: - Bool
        case (.false, .bool),
             (.true, .bool):
            return nil

        // MARK: - Nat
        case (.zero, .nat):
            return nil

        case (.succ(let pattern), .nat):
            return try pattern.match(against: .nat)

        // MARK: - Unit
        case (.unit, .unit):
            return nil

        // MARK: - tuple
        case (.tuple(let patterns), .tuple(let types))
            where patterns.count == types.count:
            return try zip(patterns, types)
                .map { pattern, type throws(PatternError) in
                    try pattern.match(against: type)
                }
                .fold(rejectingDuplicateNamesWith: duplicateLetBindingError)

        // MARK: - record
        case (.record(let patterns), .record(let types))
            where patterns.count == types.count:
            
            let patterns = try Dictionary(
                uniqueKeysWithValues: patterns.lazy.map {
                    (key: $0.label, value: $0.pattern)
                },
                rejectingDuplicateKeysWith: { duplicates in
                    PatternError.duplicateRecordPatternFields(duplicates, in: self)
                }
            )

            return try patterns
                .map { label, pattern throws(PatternError) in
                    guard let type = types[label] else {
                        throw .unexpectedPattern(self, for: type)
                    }

                    return try pattern.match(against: type)
                }
                .fold(rejectingDuplicateNamesWith: duplicateLetBindingError)

        // MARK: - sum
        case (.inl(let pattern), .sum(let type, _)),
             (.inr(let pattern), .sum(_, let type)):
            return try pattern.match(against: type)

        // MARK: - Variant
        case (.variant(let label, let payloadPattern), .variant(let cases)):
            guard let caseType = cases[label] else {
                throw .unexpectedPattern(self, for: type)
            }
            
            switch (payloadPattern, caseType) {
            case (nil, nil):
                return nil
            case (nil, let payloadType?):
                throw .unexpectedNullaryVariantPattern(
                    name: label,
                    missed: payloadType,
                    pattern: self,
                    type: type
                )
            case (let payloadPattern?, nil):
                throw .unexpectedNonNullaryVariantPattern(
                    name: label,
                    pattern: payloadPattern,
                    type: type
                )
            case (let payloadPattern?, let payloadType?):
                return try payloadPattern.match(against: payloadType)
            }

        // MARK: - List
        case (.list(let patterns), .list(let elementType)):
            return try patterns
                .map { pattern throws(PatternError) in
                    try pattern.match(against: elementType)
                }
                .fold(rejectingDuplicateNamesWith: duplicateLetBindingError)

        case (.cons(let headPattern, let tailPattern), .list(let elementType)):
            return try CollectionOfTwo(
                try headPattern.match(against: elementType),
                try tailPattern.match(against: .list(elementType))
            )
            .fold(rejectingDuplicateNamesWith: duplicateLetBindingError)

        // MARK: - cast, as
        case (.cast(let pattern, let castType), _),
             (.ascription(let pattern, let castType), _):
            let castType = try CanonicalType(from: castType) <!> PatternError.canonizeError
            
            guard let type = try? castType.unify(with: type) else {
                throw .unexpectedPattern(self, for: type)
            }

            return try pattern.match(against: type)

        default:
            throw .unexpectedPattern(self, for: type)
        }
    }

    private func duplicateLetBindingError(_ duplicates: [Name]) -> PatternError {
        .duplicateLetBinding(duplicates, in: self)
    }
}

enum PatternError: Error {
    case unexpectedPattern(Pattern, for: CanonicalType)

    case duplicateLetBinding([Name], in: Pattern)
    case duplicateRecordPatternFields([Name], in: Pattern)
    case unexpectedNonNullaryVariantPattern(name: Name, pattern: Pattern, type: CanonicalType)
    case unexpectedNullaryVariantPattern(name: Name, missed: CanonicalType, pattern: Pattern, type: CanonicalType)

    case canonizeError(CanonizeError)
}
