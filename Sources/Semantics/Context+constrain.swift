extension Context {
    @discardableResult
    func constrain(
        _ actualType: CanonicalType,
        to expectedType: CanonicalType
    ) throws(ConstrainError) -> CanonicalType {
        if extensions.contains(.structuralSubtyping) {
            try actualType.requireSubtype(of: expectedType)
                <!> ConstrainError.subtypeError

            return actualType
        } else if extensions.contains(.typeReconstruction) {
            return try solver.unify(actual: copy actualType, expected: expectedType)
                <!> ConstrainError.unifyError
        } else {
            guard actualType == expectedType else {
                throw .unexpectedType(actualType: actualType, expectedType: expectedType)
            }

            return actualType
        }
    }
}

enum ConstrainError: Error {
    case unexpectedType(actualType: CanonicalType, expectedType: CanonicalType)
    case subtypeError(SubtypeError)
    case unifyError(UnifyError)
}
