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

    public func max<E: Error>(
        by areInIncreasingOrder: (Element, Element) throws(E) -> Bool
    ) throws(E) -> Element {
        try rawValue.max(by: areInIncreasingOrder).unsafelyUnwrapped
        <!> { (error: any Error) in error as! E }
    }

    public func min<E: Error>(
        by areInIncreasingOrder: (Element, Element) throws(E) -> Bool
    ) throws(E) -> Element {
        try rawValue.min(by: areInIncreasingOrder).unsafelyUnwrapped
        <!> { (error: any Error) in error as! E }
    }

    public func sorted<E: Error>(
        by areInIncreasingOrder: (Element, Element) throws(E) -> Bool
    ) throws(E) -> NonEmpty<[Element]> {
        try rawValue.sorted(by: areInIncreasingOrder)
        <!> { (error: any Error) in error as! E }
        |> NonEmpty<[Element]>.init(rawValue:)
        |> \.unsafelyUnwrapped
    }

    public func randomElement<T>(using generator: inout T) -> Element where T: RandomNumberGenerator {
        rawValue.randomElement(using: &generator).unsafelyUnwrapped
    }

    public func randomElement() -> Element {
        rawValue.randomElement().unsafelyUnwrapped
    }

    public func shuffled<T>(using generator: inout T) -> NonEmpty<[Element]>
    where T: RandomNumberGenerator {
        rawValue.shuffled(using: &generator)
        |> NonEmpty<[Element]>.init(rawValue:)
        |> \.unsafelyUnwrapped
    }

    public func shuffled() -> NonEmpty<[Element]> {
        rawValue.shuffled()
        |> NonEmpty<[Element]>.init(rawValue:)
        |> \.unsafelyUnwrapped
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

extension NonEmpty: Comparable where Wrapped: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension NonEmpty: Sendable where Wrapped: Sendable {}

extension NonEmpty: Encodable where Wrapped: Encodable {
    public func encode(to encoder: Encoder) throws {
        do {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        } catch {
            try rawValue.encode(to: encoder)
        }
    }
}

extension NonEmpty: Decodable where Wrapped: Decodable {
    public init(from decoder: Decoder) throws {
        let collection: Wrapped
        do {
            collection = try decoder.singleValueContainer().decode(Wrapped.self)
        } catch {
            collection = try Wrapped(from: decoder)
        }

        guard !collection.isEmpty else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Non-empty collection expected"
                )
            )
        }

        self.init(rawValue: collection)!
    }
}

extension NonEmpty: RawRepresentable {}

extension NonEmpty where Wrapped.Element: Comparable {
    public func max() -> Element {
        rawValue.max().unsafelyUnwrapped
    }

    public func min() -> Element {
        rawValue.min().unsafelyUnwrapped
    }

    public func sorted() -> NonEmpty<[Element]> {
        rawValue.sorted()
        |> NonEmpty<[Element]>.init(rawValue:)
        |> \.unsafelyUnwrapped
    }
}

extension NonEmpty: BidirectionalCollection where Wrapped: BidirectionalCollection {
    public func index(before i: Index) -> Index {
        rawValue.index(before: i)
    }

    public var last: Element {
        rawValue.last.unsafelyUnwrapped
    }
}

extension NonEmpty: MutableCollection where Wrapped: MutableCollection {
    public subscript(position: Index) -> Element {
        _read { yield rawValue[position] }
        _modify { yield &rawValue[position] }
    }
}

extension NonEmpty: RandomAccessCollection where Wrapped: RandomAccessCollection {}

extension NonEmpty where Wrapped: MutableCollection & RandomAccessCollection {
    public mutating func shuffle<T: RandomNumberGenerator>(using generator: inout T) {
        rawValue.shuffle(using: &generator)
    }
}

public typealias NonEmptyArray<Element> = NonEmpty<[Element]>

public func single<T>(_ element: T) -> NonEmpty<some Collection<T>> {
    NonEmpty<CollectionOfOne<T>>(rawValue: CollectionOfOne(element))!
}
