@inlinable
public func identity<T>(_ value: T) -> T {
    value
}

@inlinable
public func not(_ value: Bool) -> Bool {
    !value
}

@inlinable
public func second<A, B>(_ a: A, _ b: B) -> B {
    b
}

@inlinable
public func with<Value, E: Error>(
    _ value: Value,
    do body: (inout Value) throws(E) -> Void,
) throws(E) -> Value {
    var copy = value
    try body(&copy)
    return copy
}
