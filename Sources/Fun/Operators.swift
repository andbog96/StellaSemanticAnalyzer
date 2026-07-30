precedencegroup ApplicativePrecedence {
    associativity: right
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
}

infix operator § : ApplicativePrecedence

@inlinable
public func § <A, B, E: Error>(
    f: (A) throws(E) -> B,
    x: A
) throws(E) -> B {
    try f(x)
}

//@inlinable
//public func § <A, B>(
//    f: (A) -> B,
//    x: A,
//) -> B {
//    f(x)
//}

precedencegroup PipelinePrecedence {
    associativity: left
    higherThan: ApplicativePrecedence
    lowerThan: TernaryPrecedence
}

infix operator |> : PipelinePrecedence

@inlinable
public func |> <A, B, E: Error>(
    x: A,
    f: (A) throws(E) -> B
) throws(E) -> B {
    try f(x)
}

precedencegroup CompositionPrecedence {
    associativity: right
    higherThan: BitwiseShiftPrecedence
}

infix operator • : CompositionPrecedence

@inlinable
public func • <A, B, C>(
    _ f: @escaping (B) -> C,
    _ g: @escaping (A) -> B
) -> (A) -> C {
    { x in f(g(x)) }
}

@inlinable
public func • <A, B, C, E: Error>(
    _ f: @escaping (B) throws(E) -> C,
    _ g: @escaping (A) -> B
) -> (A) throws(E) -> C {
    { x in try f(g(x)) }
}

@inlinable
public func • <A, B, C, E: Error>(
    _ f: @escaping (B) -> C,
    _ g: @escaping (A) throws(E) -> B
) -> (A) throws(E) -> C {
    { x in try f(g(x)) }
}

@inlinable
public func • <A, B, C, E: Error>(
    _ f: @escaping (B) throws(E) -> C,
    _ g: @escaping (A) throws(E) -> B
) -> (A) throws(E) -> C {
    { x in try f(g(x)) }
}

infix operator ?! : NilCoalescingPrecedence

@inlinable
public func ?! <T, E: Error>(lhs: T?, rhs: @autoclosure () -> E) throws(E) -> T {
    if let lhs {
        lhs
    } else {
        throw rhs()
    }
}
