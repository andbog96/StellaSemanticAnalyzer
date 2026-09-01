import Testing
@testable import StellaTypeChecker

@Suite
struct FunTests {
    @Test("Ambiguous inferred match type is rejected")
    @MainActor
    func ambiguousMatchType() throws {
        let source = """
        language core;
        extend with #type-reconstruction;

        fn main(x : auto) -> Nat {
            return match x { y => 0 }
        }
        """

        let program = try Program.parser.run(sourceName: "test", input: source)

        #expect(throws: SemanticError.self) {
            _ = try Context(from: program)
        }

        do {
            _ = try Context(from: program)
            Issue.record("Expected ERROR_AMBIGUOUS_TYPE")
        } catch let error as SemanticError {
            #expect(error.code == "ERROR_AMBIGUOUS_TYPE")
        }
    }
}
