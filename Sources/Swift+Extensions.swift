extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Dictionary where Key: Comparable {
    func sorted() -> [Element] {
        sorted {
            $0.key < $1.key
        }
    }
}

extension Dictionary {
    init<E: Error>(
        uniqueKeysWithValues keysAndValues: some Sequence<(Key, Value)>,
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
