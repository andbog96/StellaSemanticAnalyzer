struct ValueName: CustomStringConvertible, Hashable {
    var description: String
}

struct TypeName: CustomStringConvertible, Hashable {
    var description: String
}

struct TupleIndex {
    var value: Int
}

struct RecordLabel: CustomStringConvertible, Hashable {
    var description: String
}

struct VariantLabel: CustomStringConvertible, Hashable {
    var description: String
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
