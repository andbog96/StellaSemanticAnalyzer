import Foundation

private struct StandardErrorOutputStream: TextOutputStream {
    private static let handle = FileHandle.standardError

    func write(_ string: String) {
        Self.handle.write(Data(string.utf8))
    }
}

@MainActor
private var standardError = StandardErrorOutputStream()

@MainActor
func print(_ error: TypeCheckError) {
    print(error, to: &standardError)
}

