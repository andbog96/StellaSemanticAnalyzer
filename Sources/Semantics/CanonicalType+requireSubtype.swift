extension CanonicalType {
    borrowing func requireSubtype(of supertype: borrowing CanonicalType) throws(SubtypeError) {
        guard self != supertype else {
            return
        }

        switch (copy self, copy supertype) {
        case (.bottom, _),
             (_, .top):
            break

        case (
            .function(let subtypeParameters, let subtypeResult),
            .function(let supertypeParameters, let supertypeResult)
        ) where subtypeParameters.count == supertypeParameters.count:
            for (subtype, supertype) in zip(subtypeParameters, supertypeParameters) {
                try supertype.requireSubtype(of: subtype)
            }
            
            try subtypeResult.requireSubtype(of: supertypeResult)

        case (
            .function(let subtypeParameters, _),
            .function(let supertypeParameters, _)
        ):
            throw .incorrectArgumentsNumber(
                actual: subtypeParameters.count,
                expected: supertypeParameters.count,
                type: copy supertype
            )

        case (
            .tuple(let subtypeElements),
            .tuple(let supertypeElements)
        ) where subtypeElements.count == supertypeElements.count:
            for (subtype, supertype) in zip(subtypeElements, supertypeElements) {
                try subtype.requireSubtype(of: supertype)
            }

        case (
            .tuple(let subtypeElements),
            .tuple(let supertypeElements)
        ):
            throw .unexpectedTupleLength(
                actual: subtypeElements.count,
                expected: supertypeElements.count,
                type: copy supertype
            )

        case (
            .record(let subtypeFields),
            .record(let supertypeFields)
        ):
            for (label, supertypeField) in supertypeFields {
                guard let subtypeField = subtypeFields[label] else {
                    let missingLabels = Set(supertypeFields.keys).subtracting(subtypeFields.keys)
                    assert(!missingLabels.isEmpty)

                    throw .missingRecordFields(Array(missingLabels), for: copy supertype)
                }

                try subtypeField.requireSubtype(of: supertypeField)
            }

        case (
            .sum(let subtypeLeft, let subtypeRight),
            .sum(let supertypeLeft, let supertypeRight)
        ):
            try subtypeLeft.requireSubtype(of: supertypeLeft)
            try subtypeRight.requireSubtype(of: supertypeRight)

        case (
            .variant(let subtypeCases),
            .variant(let supertypeCases)
        ):
            for (label, subtypePayload) in subtypeCases {
                guard let supertypePayload = supertypeCases[label] else {
                    let unexpectedLabels = Set(subtypeCases.keys).subtracting(supertypeCases.keys)
                    assert(!unexpectedLabels.isEmpty)

                    throw .unexpectedVariantLabels(Array(unexpectedLabels), for: copy supertype)
                }

                switch (subtypePayload, supertypePayload) {
                case (nil, nil):
                    break

                case (nil, _?):
                    throw .undefined(code: "ERROR_UNEXPECTED_TYPE_FOR_NULLARY_LABEL")

                case (_?, nil):
                    throw .undefined(code: "ERROR_MISSING_TYPE_FOR_LABEL")

                case (let subtypePayload?, let supertypePayload?):
                    try subtypePayload.requireSubtype(of: supertypePayload)
                }
            }

        case (.list(let subtypeElement), .list(let supertypeElement)):
            try subtypeElement.requireSubtype(of: supertypeElement)

        case (.reference(let subtypeValue), .reference(let supertypeValue))
        where subtypeValue == supertypeValue:
            break

        case (
            .forall(let subtypeVariables, let subtypeBody),
            .forall(let supertypeVariables, let supertypeBody)
        ) where subtypeVariables.count == supertypeVariables.count:
            let renaming = Dictionary(uniqueKeysWithValues: zip(
                subtypeVariables,
                supertypeVariables.map(CanonicalType.variable)
            ))
            try subtypeBody.substituting(renaming).requireSubtype(of: supertypeBody)

        default:
            throw .unexpectedSubtype(copy self, of: copy supertype)
        }
    }
}

enum SubtypeError: Error {
    case undefined(code: String)

    case incorrectArgumentsNumber(actual: Int, expected: Int, type: CanonicalType)
    case unexpectedTupleLength(actual: Int, expected: Int, type: CanonicalType)
    case missingRecordFields([RecordLabel], for: CanonicalType)
    case unexpectedVariantLabels([VariantLabel], for: CanonicalType)

    case unexpectedSubtype(CanonicalType, of: CanonicalType)
}
