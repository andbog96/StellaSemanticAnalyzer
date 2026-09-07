import Foundation
import SwiftParsec

guard let data = try FileHandle.standardInput.readToEnd(),
      let programText = String(data: data, encoding: .utf8) else {
    quit(message: "Failed to read Stella program from the standard input")
}

do {
    let program = try Program.parser.run(sourceName: "stdin", input: programText)
    _ = try Context(from: program)
} catch let error as ParseError {
    quit(message: error.description)
} catch let error as SemanticError {
    print(error, to: &standardError)
} catch {
    quit(message: error.localizedDescription)
}

private func quit(message: String) -> Never {
    print(message)
    exit(EXIT_FAILURE)
}

private struct StandardErrorOutputStream: TextOutputStream {
    private static let handle = FileHandle.standardError

    func write(_ string: String) {
        Self.handle.write(Data(string.utf8))
    }
}

private var standardError = StandardErrorOutputStream()
