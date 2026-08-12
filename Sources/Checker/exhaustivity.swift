private let wildcard = Pattern.var § Name(value: "__something__")

extension CanonicalType {
    func missingPatterns(in patterns: [Pattern]) -> [Pattern] {
        witnesses.filter { witness in
            !patterns.contains(where: witness.isCovered(by:))
        }
    }

    private var witnesses: [Pattern] {
        switch self {
        case .bool:
            return [.true, .false]

        case .nat:
            return [.zero, .succ(wildcard)]

        case .unit:
            return [.unit]

        case .tuple(let elements):
            return elements.lazy
                .map(\.witnesses)
                .product()
                .map(Pattern.tuple(elements:))

        case .record(let fields):
            return fields.lazy.map { label, type in
                type.witnesses.map { pattern in
                    (label, pattern)
                }
            }
            .product()
            .map(Pattern.record(fields:))

        case .sum(let left, let right):
            return left.witnesses.map(Pattern.inl) + right.witnesses.map(Pattern.inr)

        case .variant(let cases):
            return cases
                .flatMap { label, type in
                    type?.witnesses
                        .map { pattern in
                            (label, pattern)
                        }
                    ?? [(label, nil)]
                }
                .map(Pattern.variant(label:pattern:))

        case .list:
            return [.list([]), .cons(wildcard, wildcard)]

        case .mu,
             .reference,
             .function,
             .variable,
             .top,
             .auto,
             .forall:
            return [wildcard]
            
        case .bottom:
            return []
        }
    }
}

private extension Pattern {
    func isCovered(by pattern: Pattern) -> Bool {
        switch (self, pattern) {
        case (_, .var):
            return true
            
        case (.false, .false),
             (.true, .true):
            return true
            
        case (.zero, .zero):
            return true
            
        case (.succ(let witness), .succ(let pattern)):
            return witness.isCovered(by: pattern)
            
        case (.unit, .unit):
            return true
            
        case (.tuple(let witnesses), .tuple(let patterns)):
            guard witnesses.count == patterns.count else {
                return false
            }

            return zip(witnesses, patterns)
                .allSatisfy { witness, pattern in
                    witness.isCovered(by: pattern)
                }

        case (.record(let witnesses), .record(let patterns)):
            guard witnesses.count == patterns.count else {
                return false
            }
            
            return patterns.allSatisfy { label, pattern in
                let witness = witnesses.first { witnessLabel, _ in
                    label == witnessLabel
                }
                
                guard let witness else {
                    return false
                }

                return witness.pattern.isCovered(by: pattern)
            }

        case (.inl(let witness), .inl(let pattern)),
             (.inr(let witness), .inr(let pattern)):
            return witness.isCovered(by: pattern)

        case (.variant(let witnessLabel, let payloadWitness), .variant(let label, let payloadPattern)):
            guard witnessLabel == label else {
                return false
            }

            return switch (payloadWitness, payloadPattern) {
            case (nil, nil):
                true
            case (let witness?, let pattern?):
                witness.isCovered(by: pattern)
            default:
                false
            }

        case (.list(let witnesses), .list(let patterns)):
            guard witnesses.count == patterns.count else {
                return false
            }
            
            return zip(witnesses, patterns)
                .allSatisfy { witness, pattern in
                    witness.isCovered(by: pattern)
                }

        case (.cons(let witnessHead, let witnessTail), .cons(let head, let tail)):
            return witnessHead.isCovered(by: head) && witnessTail.isCovered(by: tail)
            
        case (_, .cast(let pattern, _)),
             (_, .ascription(let pattern, _)):
            return isCovered(by: pattern)

        default:
            return false
        }
    }
}
