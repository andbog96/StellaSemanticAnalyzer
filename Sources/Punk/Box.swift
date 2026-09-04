@dynamicMemberLookup
@propertyWrapper
public final class MutableBox<Wrapped> {
    public var wrappedValue: Wrapped

    public init(wrappedValue: Wrapped) {
        self.wrappedValue = wrappedValue
    }

    public subscript<U>(dynamicMember keyPath: WritableKeyPath<Wrapped, U>) -> U {
        get {
            wrappedValue[keyPath: keyPath]
        }
        set {
            wrappedValue[keyPath: keyPath] = newValue
        }
    }
}
