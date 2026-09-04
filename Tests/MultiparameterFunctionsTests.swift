import Testing
@testable import StellaSemanticAnalyzer

@Suite
@MainActor
struct MultiparameterFunctionsTests {
    @Test
    func illTypedIncorrectArityOfMainPrimitive2() throws {
        let source = #"""
language core;
extend with #multiparameter-functions;

fn main(a : Nat, b : Bool) -> Nat {
  return 0;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/multiparameter-functions/ill-typed/incorrect_arity_of_main/primitive 2.stella",
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
    func illTypedIncorrectArityOfMainPrimitive() throws {
        let source = #"""
language core;
extend with #multiparameter-functions;

fn main(a : Nat, b : Bool) -> Nat {
  return 0;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/multiparameter-functions/ill-typed/incorrect_arity_of_main/primitive.stella",
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
    func illTypedIncorrectNumberOfArgumentsFix2() throws {
        let source = #"""
language core;

extend with #let-patterns;
extend with #let-bindings;
extend with #fixpoint-combinator;
extend with #multiparameter-functions;

fn main(n : fn(Nat, Nat) -> Nat) -> Nat {
  return let a = fix(n) in a
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/multiparameter-functions/ill-typed/incorrect_number_of_arguments/fix 2.stella",
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
    func illTypedIncorrectNumberOfArgumentsFix() throws {
        let source = #"""
language core;

extend with #let-patterns;
extend with #let-bindings;
extend with #fixpoint-combinator;
extend with #multiparameter-functions;

fn main(n : fn(Nat, Nat) -> Nat) -> Nat {
  return let a = fix(n) in a
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/multiparameter-functions/ill-typed/incorrect_number_of_arguments/fix.stella",
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
    func illTypedIncorrectNumberOfArgumentsPrimitive2() throws {
        let source = #"""
language core;
extend with #multiparameter-functions;

fn func(a : Nat, b : Bool) -> Nat {
  return if b then a else 0;
}

fn main(a : Nat) -> Nat {
  return func(a);
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/multiparameter-functions/ill-typed/incorrect_number_of_arguments/primitive 2.stella",
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
    func illTypedIncorrectNumberOfArgumentsPrimitive() throws {
        let source = #"""
language core;
extend with #multiparameter-functions;

fn func(a : Nat, b : Bool) -> Nat {
  return if b then a else 0;
}

fn main(a : Nat) -> Nat {
  return func(a);
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/multiparameter-functions/ill-typed/incorrect_number_of_arguments/primitive.stella",
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
extend with #multiparameter-functions;

fn func(a : Nat, b : Bool) -> Nat {
  return if b then a else 0;
}

fn main(a : Nat) -> Nat {
  return func(a, false);
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/multiparameter-functions/well-typed/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }
}
