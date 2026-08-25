extension RandomAccessCollection where Element: RandomAccessCollection {
    // TODO: - lazy without allocations and copies
    func product() -> some Sequence<[Element.Element]> {
        reduce([[]]) { accumulator, current in
            accumulator.flatMap { combined in
                current.map { element in
                    combined + CollectionOfOne(element)
                }
            }
        }
    }
}
