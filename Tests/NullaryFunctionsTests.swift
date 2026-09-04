import Testing
@testable import StellaSemanticAnalyzer

@Suite
@MainActor
struct NullaryFunctionsTests {
    @Test
    func illTypedIncorrectArityOfMainPrimitive() throws {
        let source = #"""
language core;
extend with #nullary-functions;

fn main() -> Nat {
  return 0;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/nullary-functions/ill-typed/incorrect_arity_of_main/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_ARITY_OF_MAIN")
        }
    }

    @Test
    func illTypedIncorrectNumberOfArgumentsPrimitive() throws {
        let source = #"""
language core;
extend with #nullary-functions;

fn func(n : Nat) -> Nat {
  return n;
}

fn main(n : Nat) -> Nat {
  return func();
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/nullary-functions/ill-typed/incorrect_number_of_arguments/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_NUMBER_OF_ARGUMENTS")
        }
    }

    @Test
    func wellTypedPrimitive() throws {
        let source = #"""
language core;
extend with #nullary-functions;

fn func() -> Nat {
  return 0;
}

fn main(n : Nat) -> Nat {
  return func();
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/nullary-functions/well-typed/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }
}
