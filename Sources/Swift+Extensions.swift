extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
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
            .map(\.key)
        }

        guard duplicates.isEmpty else {
            throw duplicateKeysError(duplicates)
        }
    }
}
