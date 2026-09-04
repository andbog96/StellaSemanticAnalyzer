precedencegroup MapErrorPrecedence {
    associativity: left
    higherThan: PipelinePrecedence
    lowerThan: TernaryPrecedence
}

infix operator <!>: MapErrorPrecedence

// mapError operator
@discardableResult
public func <!> <Value, E1: Error, E2: Error>(
    _ value: @autoclosure () throws(E1) -> Value,
    _ transform: (E1) -> E2
) throws(E2) -> Value {
    do throws(E1) {
        return try value()
    } catch {
        throw transform(error)
    }
}

public func <!> <A, B, E1: Error, E2: Error>(
    _ function: @escaping (A) throws(E1) -> B,
    _ transform: @escaping (E1) -> E2
) -> (A) throws(E2) -> B {
    { a throws(E2) -> B in
        do throws(E1) {
            return try function(a)
        } catch {
            throw transform(error)
        }
    }
}
