import Testing
@testable import StellaSemanticAnalyzer

@Suite
@MainActor
struct TryCastAsTests {
    @Test
    func illTypedUnexpectedTypeForExpressionPrimitive() throws {
        let source = #"""
language core;
extend with #try-cast-as;


fn main(n : Nat) -> Bool {
    return try { 0 } cast as Bool {
      b => b
    } with {
      0
    }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/try-cast-as/ill-typed/unexpected_type_for_expression/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test
    func wellTypedPrimitive() throws {
        let source = #"""
language core;
extend with #try-cast-as;

fn main(n : Nat) -> Bool {
    return try { 0 } cast as Bool {
      b => b
    } with {
      false
    }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/try-cast-as/well-typed/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }
}
