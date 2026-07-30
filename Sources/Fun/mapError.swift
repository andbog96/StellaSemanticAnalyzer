precedencegroup MapErrorPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
}

infix operator <!>: MapErrorPrecedence

// mapError operator
@discardableResult
public func <!> <T, E1: Error, E2: Error>(
    _ value: @autoclosure () throws(E1) -> T,
    _ transform: (E1) -> E2
) throws(E2) -> T {
    do throws(E1) {
        return try value()
    } catch {
        throw transform(error)
    }
}
