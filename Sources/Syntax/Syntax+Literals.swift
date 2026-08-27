extension Name: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        self.init(value: value)
    }
}

extension Label: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        self.init(value: value)
    }
}

extension MemoryAddress: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        self.init(value: value)
    }
}
