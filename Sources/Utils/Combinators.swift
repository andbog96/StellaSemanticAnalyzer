@inlinable
public func identity<T>(_ value: T) -> T {
    value
}

@inlinable
public func not(_ value: Bool) -> Bool {
    !value
}

@inlinable
public func first<A, B>(_ a: A, _: B) -> A {
    a
}

@inlinable
public func second<A, B>(_: A, _ b: B) -> B {
    b
}
