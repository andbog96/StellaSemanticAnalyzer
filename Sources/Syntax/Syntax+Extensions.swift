extension ValueName: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        self.init(description: value)
    }
}

extension TupleIndex: CustomStringConvertible {
    var description: String {
        "\(value)"
    }
}

extension TupleIndex {
    var isPairIndex: Bool {
        1...2 ~= value
    }

    var fromZero: Int {
        value - 1
    }
}
