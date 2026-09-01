import Foundation

@MainActor
struct TypeVariableID: Hashable {
    private static var nextID = 0

    private let value: Int

    static var new: Self {
        defer {
            nextID += 1
        }

        return Self(value: nextID)
    }
}

@MainActor
struct Solver {
    var substitutions = [:] as [TypeVariableID: CanonicalType]

    mutating func resolve(_ type: consuming CanonicalType) -> CanonicalType {
        switch type {
        case .auto(let identifier):
            guard let replacement = substitutions[identifier] else {
                return type
            }

            let resolved = resolve(replacement)
            substitutions[identifier] = resolved

            return resolved

        case .function(let from, let to):
            return .function(from: from.map { resolve($0) }, to: resolve(to))

        case .tuple(let elements):
            return .tuple(elements: elements.map { resolve($0) })

        case .record(let fields):
            return .record(fields: fields.mapValues { resolve($0) })

        case .sum(let left, let right):
            return .sum(left: resolve(left), right: resolve(right))

        case .variant(let cases):
            return .variant(cases: cases.mapValues { $0.map { resolve($0) } })

        case .list(let element):
            return .list(resolve(element))

        case .reference(let value):
            return .reference(resolve(value))

        case .forall(let variables, let body):
            return .forall(variables: variables, body: resolve(body))

        default:
            return type
        }
    }

    mutating func contains(_ identifier: TypeVariableID, in type: consuming CanonicalType) -> Bool {
        switch resolve(type) {
        case .auto(let other):
            return identifier == other

        case .function(let from, let to):
            return from.contains { contains(identifier, in: $0) } || contains(identifier, in: to)

        case .tuple(let elements):
            return elements.contains { contains(identifier, in: $0) }

        case .record(let fields):
            return fields.values.contains { contains(identifier, in: $0) }

        case .sum(let left, let right):
            return contains(identifier, in: left) || contains(identifier, in: right)

        case .variant(let cases):
            return cases.values.contains { $0.map { contains(identifier, in: $0) } ?? false }

        case .list(let element), .reference(let element):
            return contains(identifier, in: element)

        case .forall(_, let body):
            return contains(identifier, in: body)

        default:
            return false
        }
    }
}
