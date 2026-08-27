struct Name: Hashable {
    var value: String
}

extension Name: Comparable {
    static func < (lhs: borrowing Name, rhs: borrowing Name) -> Bool {
        lhs.value < rhs.value
    }
}

struct Label: Hashable {
    var value: String
}

struct Program {
    var extensions: Set<Extension>
    var declarations: [Declaration]
}

enum Extension: String, CaseIterable {
    case structuralSubtyping = "structural-subtyping"
    case ambiguousTypeAsBottom = "ambiguous-type-as-bottom"
    case typeReconstruction = "type-reconstruction"
    case universalTypes = "universal-types"
}

struct MemoryAddress: Hashable {
    var value: String
}
