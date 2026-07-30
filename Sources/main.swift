import Foundation

guard let data = try FileHandle.standardInput.readToEnd(),
      let programText = String(data: data, encoding: .utf8) else {
    quit(message: "Failed to read Stella program from the standard input")
}

do {
    let program = try Program.parser.run(sourceName: "stdin", input: programText)
    try program.check()
} catch let error as StellaParseError {
    quit(message: error.description)
} catch let error as TypeCheckError {
    print(error)
} catch {
    quit(message: error.localizedDescription)
}

private func quit(message: String) -> Never {
    print(message)
    exit(EXIT_FAILURE)
}
