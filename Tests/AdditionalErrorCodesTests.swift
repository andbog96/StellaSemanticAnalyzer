import Testing
@testable import StellaSemanticAnalyzer

@Suite
@MainActor
struct AdditionalErrorCodesTests {
    @Test
    func illTypedDuplicateFunctionParameterFunc2() throws {
        let source = #"""
language core;
extend with #multiparameter-functions;

fn duplicate(a : Nat, b : Nat, a : Bool) -> Nat {
  return 0;
}

fn main(n : Nat) -> Nat {
  return 0;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/additional-error-codes/ill-typed/duplicate_function_parameter/func 2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_FUNCTION_PARAMETER")
        }
    }

    @Test
    func illTypedDuplicateFunctionParameterFunc() throws {
        let source = #"""
language core;
extend with #multiparameter-functions;

fn duplicate(a : Nat, b : Nat, a : Bool) -> Nat {
  return 0;
}

fn main(n : Nat) -> Nat {
  return 0;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/additional-error-codes/ill-typed/duplicate_function_parameter/func.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_FUNCTION_PARAMETER")
        }
    }

    @Test
    func illTypedDuplicateFunctionParameterLambda2() throws {
        let source = #"""
language core;
extend with #multiparameter-functions;

fn main(n : Nat) -> fn (Nat, Bool) -> Nat {
  return fn(a : Nat, a : Bool) {
    return 0;
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/additional-error-codes/ill-typed/duplicate_function_parameter/lambda 2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_FUNCTION_PARAMETER")
        }
    }

    @Test
    func illTypedDuplicateFunctionParameterLambda() throws {
        let source = #"""
language core;
extend with #multiparameter-functions;

fn main(n : Nat) -> fn (Nat, Bool) -> Nat {
  return fn(a : Nat, a : Bool) {
    return 0;
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/additional-error-codes/ill-typed/duplicate_function_parameter/lambda.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_FUNCTION_PARAMETER")
        }
    }

    @Test
    func illTypedDuplicateLetBindingLet2() throws {
        let source = #"""
language core;
extend with #let-bindings;
extend with #let-patterns;
extend with #tuples;
extend with #structural-patterns;


fn main(n : Nat) -> Nat {
  return let {a, a} = {0, 0} in 0;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/additional-error-codes/ill-typed/duplicate_let_binding/let 2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_LET_BINDING")
        }
    }

    @Test
    func illTypedDuplicateLetBindingLet() throws {
        let source = #"""
language core;
extend with #let-bindings;
extend with #let-patterns;
extend with #tuples;
extend with #structural-patterns;


fn main(n : Nat) -> Nat {
  return let {a, a} = {0, 0} in 0;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/additional-error-codes/ill-typed/duplicate_let_binding/let.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_LET_BINDING")
        }
    }

    @Test
    func illTypedDuplicateLetBindingLetrec2() throws {
        let source = #"""
language core;
extend with #let-bindings;
extend with #let-patterns;
extend with #tuples;
extend with #structural-patterns;
extend with #letrec-bindings;
extend with #pattern-ascriptions;


fn main(n : Nat) -> Nat {
  return letrec {a as Nat, a as Nat} = {a, succ(a)} in 0;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/additional-error-codes/ill-typed/duplicate_let_binding/letrec 2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_LET_BINDING")
        }
    }

    @Test
    func illTypedDuplicateLetBindingLetrec() throws {
        let source = #"""
language core;
extend with #let-bindings;
extend with #let-patterns;
extend with #tuples;
extend with #structural-patterns;
extend with #letrec-bindings;
extend with #pattern-ascriptions;


fn main(n : Nat) -> Nat {
  return letrec {a as Nat, a as Nat} = {a, succ(a)} in 0;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/additional-error-codes/ill-typed/duplicate_let_binding/letrec.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_LET_BINDING")
        }
    }
}
