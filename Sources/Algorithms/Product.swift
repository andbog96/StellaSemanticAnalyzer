// Декартово произведение
extension RandomAccessCollection where Element: RandomAccessCollection {
    // TODO: - переписать на ленивую версию, без промежуточных аллокаций и копирований
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
