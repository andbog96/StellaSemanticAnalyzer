@dynamicMemberLookup
public struct NonEmpty<Wrapped: Collection>: Collection {
    public typealias Element = Wrapped.Element
    public typealias Index = Wrapped.Index

    public internal(set) var rawValue: Wrapped

    public init?(rawValue: Wrapped) {
        guard !rawValue.isEmpty else {
            return nil
        }

        self.rawValue = rawValue
    }

    public subscript<Subject>(dynamicMember keyPath: KeyPath<Wrapped, Subject>) -> Subject {
        rawValue[keyPath: keyPath]
    }

    public var startIndex: Index {
        rawValue.startIndex
    }

    public var endIndex: Index {
        rawValue.endIndex
    }

    public subscript(position: Index) -> Element {
        rawValue[position]
    }

    public func index(after i: Index) -> Index {
        rawValue.index(after: i)
    }

    public var first: Element {
        rawValue.first.unsafelyUnwrapped
    }

    public func map<T, E: Error>(
        _ transform: (Element) throws(E) -> T
    ) throws(E) -> NonEmpty<[T]> {
        try rawValue.map(transform)
        |> NonEmpty<[T]>.init(rawValue:)
        |> \.unsafelyUnwrapped
    }

    public func flatMap<T: Sequence, E: Error>(
        _ transform: (Element) throws(E) -> NonEmpty<T>
    ) throws(E) -> NonEmpty<[T.Element]> {
        try rawValue.flatMap(transform)
        <!> { (error: any Error) in error as! E }
        |> NonEmpty<[T.Element]>.init(rawValue:)
        |> \.unsafelyUnwrapped
    }
}

extension NonEmpty: CustomStringConvertible {
    public var description: String {
        String(describing: rawValue)
    }
}

extension NonEmpty: Equatable where Wrapped: Equatable {}

extension NonEmpty: Hashable where Wrapped: Hashable {}


extension NonEmpty: Sendable where Wrapped: Sendable {}

extension NonEmpty: RawRepresentable {}

public func single<T>(_ element: T) -> NonEmpty<some Collection<T>> {
    NonEmpty<CollectionOfOne<T>>(rawValue: CollectionOfOne(element)).unsafelyUnwrapped
}
