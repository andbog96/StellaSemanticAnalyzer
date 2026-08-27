import Collections

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Sequence {
    
    func compactMap<T, E: Error>(
        _ transform: (Element) throws(E) -> T?
    ) throws(E) -> [T] {
        var result = [] as [T]
        
        for element in self {
            if let mapped = try transform(element) {
                result.append(mapped)
            }
        }
        
        return result
    }
    
//    func reduce<T, E: Error>(
//        _ nextPartialResult: (_ result: T?, _ next: Element) throws(E) -> T?
//    ) throws(E) -> T? {
//        var result = nil as T?
//        
//        for element in self {
//            result = try nextPartialResult(result, element)
//        }
//        
//        return result
//    }
}

extension NonEmpty {
    func fold<E: Error>(
        _ nextPartialResult: (_ result: Element) -> (_ next: Element) throws(E) -> Element
    ) throws(E) -> Element {
        try fold { result, next throws(E) in
            try nextPartialResult(result)(next)
        }
    }

    func fold<E: Error>(
        _ nextPartialResult: (_ result: Element, _ next: Element) throws(E) -> Element
    ) throws(E) -> Element {
        var result = first

        for element in dropFirst() {
            result = try nextPartialResult(result, element)
        }

        return result
    }
}

extension OrderedSet {
    init<E: Error>(
        _ elements: some Sequence<Element>,
        rejectingDuplicatesWith duplicatesError: (_ duplicates: [Element]) -> E
    ) throws(E) {
        self = []

        let duplicates = Array.init § OrderedSet.init § elements.filter {
            !append($0).inserted
        }

        guard duplicates.isEmpty else {
            throw duplicatesError(duplicates)
        }
    }
}

extension Dictionary {
    init<E: Error>(
        uniqueKeysWithValues keysAndValues: some Sequence<(key: Key, value: Value)>,
        rejectingDuplicateKeysWith duplicateKeysError: (_ duplicateKeys: [Key]) -> E
    ) throws(E) {
        self = [Key: Value](minimumCapacity: keysAndValues.underestimatedCount)

        let isDuplicate = { key, value in
            updateValue(value, forKey: key) != nil
        }

        let duplicates = Array.init § withoutActuallyEscaping(isDuplicate) { isDuplicate in
            keysAndValues
            .lazy
            .filter(isDuplicate)
            .map(\.0)
        }

        guard duplicates.isEmpty else {
            throw duplicateKeysError(duplicates)
        }
    }
}
