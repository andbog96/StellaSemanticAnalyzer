import Testing
@testable import StellaSemanticAnalyzer

@Suite("Imported non-generic-language tests")
@MainActor
struct ImportedNoGenericsTests {
    @Test("no-generics/core/basic.stella")
    func test_no_generics_core_basic_stella_2f757a32() throws {
        let source = #"""
language core;

fn increment_twice(n : Nat) -> Nat {
  return succ(succ(n))
}

fn main(n : Nat) -> Nat {
  return increment_twice(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/basic.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/core/bool-false-literal.stella")
    func test_no_generics_core_bool_false_literal_stella_4d710a0e() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Bool {
  return false
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/bool-false-literal.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/core/bool-if-bad.stella")
    func test_no_generics_core_bool_if_bad_stella_6c3fed75() throws {
        let source = #"""
language core;

fn main(b : Bool) -> Nat {
     return if b then true else false
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/bool-if-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/core/bool-if-good.stella")
    func test_no_generics_core_bool_if_good_stella_4fa78f4f() throws {
        let source = #"""
language core;

fn main(b : Bool) -> Bool {
     return if b then true else false
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/bool-if-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/core/bool-true-literal.stella")
    func test_no_generics_core_bool_true_literal_stella_070308cd() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Bool {
  return true
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/bool-true-literal.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/core/duplicate-function-declaration-bad.stella")
    func test_no_generics_core_duplicate_function_declaration_bad_stella_4b5eacfc() throws {
        let source = #"""
language core;

fn f(x : Nat) -> Nat {
  return x
}

fn f(x : Nat) -> Bool {
  return true
}

fn main(n : Nat) -> Nat {
  return f(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/duplicate-function-declaration-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/core/higher-order-f-abstraction-bad.stella")
    func test_no_generics_core_higher_order_f_abstraction_bad_stella_f90eca75() throws {
        let source = #"""
language core;

fn f(x : fn(Nat) -> Bool) -> Bool {
    return false
}

fn main(n : Nat) -> Bool {
  return f(fn(x : Nat) { return x })
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/higher-order-f-abstraction-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/core/higher-order-f-abstraction.stella")
    func test_no_generics_core_higher_order_f_abstraction_stella_b40a5bf1() throws {
        let source = #"""
language core;

fn f(x : fn(Nat) -> Nat) -> Bool {
    return false
}

fn main(n : Nat) -> Bool {
  return f(fn(x : Nat) { return x })
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/higher-order-f-abstraction.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/core/higher-order-f-bad.stella")
    func test_no_generics_core_higher_order_f_bad_stella_4845a426() throws {
        let source = #"""
language core;

fn id(n : Bool) -> Bool {
    return n
}

fn f(x : fn(Nat) -> Nat) -> Bool {
    return false
}

fn main(n : Nat) -> Bool {
  return f(id)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/higher-order-f-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/core/higher-order-f-good.stella")
    func test_no_generics_core_higher_order_f_good_stella_30ed0090() throws {
        let source = #"""
language core;

fn id(n : Nat) -> Nat {
    return n
}

fn f(x : fn(Nat) -> Nat) -> Bool {
    return false
}

fn main(n : Nat) -> Bool {
  return f(id)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/higher-order-f-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/core/iszero-bad-arg.stella")
    func test_no_generics_core_iszero_bad_arg_stella_ef72b360() throws {
        let source = #"""
language core;

fn main(b : Bool) -> Bool {
  return Nat::iszero(b)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/iszero-bad-arg.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/core/iszero-good.stella")
    func test_no_generics_core_iszero_good_stella_7a164aec() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Bool {
  return Nat::iszero(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/iszero-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/core/missing-main-bad.stella")
    func test_no_generics_core_missing_main_bad_stella_80919e57() throws {
        let source = #"""
language core;

fn notMain(n : Nat) -> Nat {
  return n
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/missing-main-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/core/natrec-nat-bad-cnt.stella")
    func test_no_generics_core_natrec_nat_bad_cnt_stella_018f2a17() throws {
        let source = #"""
language core;


fn id(n : Nat) -> Nat {
    return n
}

fn next(n : Nat) -> fn(Nat) -> Nat{
    return id
}


fn main(n : Bool) -> Nat {
  return Nat::rec(n, 0, next)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/natrec-nat-bad-cnt.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/core/natrec-nat-bad-step.stella")
    func test_no_generics_core_natrec_nat_bad_step_stella_c90acea1() throws {
        let source = #"""
language core;


fn id(n : Bool) -> Bool {
    return n
}

fn next(n : Nat) -> (fn(Bool) -> Bool) {
    return id
}


fn main(n : Nat) -> Nat {
  return Nat::rec(n, 0, next)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/natrec-nat-bad-step.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/core/natrec-nat-good.stella")
    func test_no_generics_core_natrec_nat_good_stella_903130b8() throws {
        let source = #"""
language core;


fn id(n : Nat) -> Nat {
    return n
}

fn next(n : Nat) -> fn(Nat) -> Nat{
    return id
}


fn main(n : Nat) -> Nat {
  return Nat::rec(n, 0, next)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/natrec-nat-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/core/natrec-type-mismatch-bad.stella")
    func test_no_generics_core_natrec_type_mismatch_bad_stella_6d033140() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Bool {
    return Nat::rec(n, 0, fn(i : Nat) { return fn(acc : Nat) { return succ(acc) } })
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/natrec-type-mismatch-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/core/not-a-function-bad.stella")
    func test_no_generics_core_not_a_function_bad_stella_17022797() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return n(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/not-a-function-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/core/succ-bad.stella")
    func test_no_generics_core_succ_bad_stella_455ed9fc() throws {
        let source = #"""
language core;

fn main(n : Bool) -> Nat {
  return succ(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/succ-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/core/succ-ok.stella")
    func test_no_generics_core_succ_ok_stella_ffb6b241() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return succ(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/succ-ok.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/core/undefined-variable-bad.stella")
    func test_no_generics_core_undefined_variable_bad_stella_40a52a1b() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return y
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/undefined-variable-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/core/unexpected-lambda-bad.stella")
    func test_no_generics_core_unexpected_lambda_bad_stella_03c04f4a() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return fn(x : Nat) { return x }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/unexpected-lambda-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/core/unexpected-lambda-parameter.stella")
    func test_no_generics_core_unexpected_lambda_parameter_stella_dc4012db() throws {
        let source = #"""
language core;

fn main(n : Nat) -> fn(Bool) -> Nat {
  return fn(x : Nat) { return x }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/core/unexpected-lambda-parameter.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_PARAMETER")
        }
    }

    @Test("no-generics/fix/fix-abstraction-good.stella")
    func test_no_generics_fix_fix_abstraction_good_stella_96b12f18() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator;

fn main(n : Nat) -> Nat {
  return fix(fn (f : fn(Nat) -> Nat) {
    return fn (x : Nat) { return x }
  })(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/fix/fix-abstraction-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/fix/fix-not-a-function-bad.stella")
    func test_no_generics_fix_fix_not_a_function_bad_stella_ffdf384d() throws {
        let source = #"""
language core;

extend with #let-bindings, #fixpoint-combinator;

fn main(n : fn(Nat) -> Bool) -> Nat {
  return let a = fix(n) in a
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/fix/fix-not-a-function-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/fix/fix-sum-good.stella")
    func test_no_generics_fix_fix_sum_good_stella_15e04531() throws {
        let source = #"""
language core;

extend with #predecessor, #fixpoint-combinator;

fn sum(f : fn(Nat) -> Nat) -> fn(Nat) -> Nat {
  return fn (x : Nat) { return if Nat::iszero(x) then 0 else succ(f(Nat::pred(x))) }
}

fn main(n : Nat) -> Nat {
  return fix(sum)(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/fix/fix-sum-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/fix/fix-type-mismatch-bad.stella")
    func test_no_generics_fix_fix_type_mismatch_bad_stella_1cd3d0a9() throws {
        let source = #"""
language core;

extend with #let-bindings, #fixpoint-combinator;

fn main(n : Nat) -> Nat {
  return let a = fix(n) in a
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/fix/fix-type-mismatch-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/let-binding/let-binding-bad-rhs.stella")
    func test_no_generics_let_binding_let_binding_bad_rhs_stella_dc1b04d7() throws {
        let source = #"""
language core;

extend with #let-bindings;

fn main(n : Nat) -> Nat {
  return let x = succ(true) in x
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/let-binding/let-binding-bad-rhs.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/let-binding/let-binding-body-type-mismatch-bad.stella")
    func test_no_generics_let_binding_let_binding_body_type_mismatch_bad_stella_b2c4d5e9() throws {
        let source = #"""
language core;

extend with #let-bindings;

fn main(n : Nat) -> Nat {
  return let x = n in true
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/let-binding/let-binding-body-type-mismatch-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/let-binding/let-binding-good.stella")
    func test_no_generics_let_binding_let_binding_good_stella_5b4016ac() throws {
        let source = #"""
language core;

extend with #let-bindings;

fn main(n : Nat) -> Nat {
  return let x = n in x
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/let-binding/let-binding-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/let-binding/let-binding-multiple-good.stella")
    func test_no_generics_let_binding_let_binding_multiple_good_stella_1a566625() throws {
        let source = #"""
language core;

extend with #let-bindings, #let-many-bindings;

fn main(n : Nat) -> Nat {
  return let x = n, y = succ(n) in y
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/let-binding/let-binding-multiple-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/let-binding/let-binding-nat-good.stella")
    func test_no_generics_let_binding_let_binding_nat_good_stella_8efbf922() throws {
        let source = #"""
language core;

extend with #let-bindings;

fn main(n : Nat) -> Nat {
  return let x = succ(n) in succ(x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/let-binding/let-binding-nat-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/let-binding/let-binding-nested-good.stella")
    func test_no_generics_let_binding_let_binding_nested_good_stella_40cb10e3() throws {
        let source = #"""
language core;

extend with #let-bindings;

fn main(n : Nat) -> Nat {
  return let x = succ(n) in let y = succ(x) in y
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/let-binding/let-binding-nested-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/let-binding/let-binding-shadow-good.stella")
    func test_no_generics_let_binding_let_binding_shadow_good_stella_08ce4d48() throws {
        let source = #"""
language core;

extend with #let-bindings;

fn main(n : Nat) -> Nat {
  return let n = succ(n) in n
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/let-binding/let-binding-shadow-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/lists/list-ambiguous-bad.stella")
    func test_no_generics_lists_list_ambiguous_bad_stella_e703d659() throws {
        let source = #"""
language core;

extend with #lists;

fn main(n : fn(Nat) -> Nat) -> Nat {
  return n(List::head([]))
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/lists/list-ambiguous-bad.stella",
            input: source
        )

        _ = try Context(from: program)
    }

    @Test("no-generics/lists/list-cons-bad.stella")
    func test_no_generics_lists_list_cons_bad_stella_77a384b3() throws {
        let source = #"""
language core;

extend with #lists;

fn main(n : Nat) -> [Nat] {
  return cons(true, [n])
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/lists/list-cons-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/lists/list-cons-good.stella")
    func test_no_generics_lists_list_cons_good_stella_7abf0695() throws {
        let source = #"""
language core;

extend with #lists;

fn main(n : Nat) -> [Nat] {
  return cons(n, [succ(n)])
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/lists/list-cons-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/lists/list-empty-good.stella")
    func test_no_generics_lists_list_empty_good_stella_59cd4f19() throws {
        let source = #"""
language core;

extend with #lists;

fn main(n : Nat) -> [Nat] {
  return []
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/lists/list-empty-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/lists/list-head-good.stella")
    func test_no_generics_lists_list_head_good_stella_849b3e97() throws {
        let source = #"""
language core;

extend with #lists;

fn main(n : [Nat]) -> Nat {
  return List::head(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/lists/list-head-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/lists/list-head-not-a-list-bad.stella")
    func test_no_generics_lists_list_head_not_a_list_bad_stella_d6d06989() throws {
        let source = #"""
language core;

extend with #lists;

fn main(n : Nat) -> Nat {
  return List::head(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/lists/list-head-not-a-list-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/lists/list-isempty-good.stella")
    func test_no_generics_lists_list_isempty_good_stella_99e0ba04() throws {
        let source = #"""
language core;

extend with #lists;

fn main(n : [Nat]) -> Bool {
  return List::isempty(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/lists/list-isempty-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/lists/list-isempty-not-a-list-bad.stella")
    func test_no_generics_lists_list_isempty_not_a_list_bad_stella_7d4183f3() throws {
        let source = #"""
language core;

extend with #lists;

fn main(n : Nat) -> Bool {
  return List::isempty(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/lists/list-isempty-not-a-list-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/lists/list-literal-bad.stella")
    func test_no_generics_lists_list_literal_bad_stella_1a02550a() throws {
        let source = #"""
language core;

extend with #lists;

fn main(n : Nat) -> [Nat] {
  return [n, true]
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/lists/list-literal-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/lists/list-literal-good.stella")
    func test_no_generics_lists_list_literal_good_stella_ee8a56f2() throws {
        let source = #"""
language core;

extend with #lists;

fn main(n : Nat) -> [Nat] {
  return [n, succ(n), succ(succ(n))]
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/lists/list-literal-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/lists/list-tail-good.stella")
    func test_no_generics_lists_list_tail_good_stella_bf3dc67d() throws {
        let source = #"""
language core;

extend with #lists;

fn main(n : [Nat]) -> [Nat] {
  return List::tail(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/lists/list-tail-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/lists/list-tail-not-a-list-bad.stella")
    func test_no_generics_lists_list_tail_not_a_list_bad_stella_20b9ffff() throws {
        let source = #"""
language core;

extend with #lists;

fn main(n : Nat) -> [Nat] {
  return List::tail(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/lists/list-tail-not-a-list-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/lists/list-unexpected-list-bad.stella")
    func test_no_generics_lists_list_unexpected_list_bad_stella_5b9657cf() throws {
        let source = #"""
language core;

extend with #lists;

fn main(n : Bool) -> Nat {
  return [n]
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/lists/list-unexpected-list-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/multiple-parameters/function-call-good.stella")
    func test_no_generics_multiple_parameters_function_call_good_stella_a57f4d14() throws {
        let source = #"""
language core;

extend with #multiparameter-functions;

fn k(x : Nat, y : Bool) -> Nat {
  return x
}

fn main(n : Nat) -> Nat {
  return k(n, true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/multiple-parameters/function-call-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/multiple-parameters/incorrect-arity-of-main-bad.stella")
    func test_no_generics_multiple_parameters_incorrect_arity_of_main_bad_stella_17aeb2ae() throws {
        let source = #"""
language core;

extend with #multiparameter-functions;

fn main(x : Nat, y : Nat) -> Nat {
  return x
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/multiple-parameters/incorrect-arity-of-main-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/multiple-parameters/incorrect-number-of-arguments-bad.stella")
    func test_no_generics_multiple_parameters_incorrect_number_of_arguments_bad_stella_c97328f2() throws {
        let source = #"""
language core;

extend with #multiparameter-functions;

fn k(x : Nat, y : Bool) -> Nat {
  return x
}

fn main(n : Nat) -> Nat {
  return k(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/multiple-parameters/incorrect-number-of-arguments-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/multiple-parameters/lambda-good.stella")
    func test_no_generics_multiple_parameters_lambda_good_stella_0189af67() throws {
        let source = #"""
language core;

extend with #multiparameter-functions;

fn main(n : Nat) -> fn(Nat, Bool) -> Nat {
  return fn(x : Nat, y : Bool) { return x }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/multiple-parameters/lambda-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/multiple-parameters/unexpected-number-of-parameters-in-lambda-bad.stella")
    func test_no_generics_multiple_parameters_unexpected_number_of_parameters_in_lambda_bad_stella_05aef8af() throws {
        let source = #"""
language core;

extend with #multiparameter-functions;

fn main(n : Nat) -> fn(Nat, Bool) -> Nat {
  return fn(x : Nat) { return x }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/multiple-parameters/unexpected-number-of-parameters-in-lambda-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/nested-function/nested-function-forward-reference-good.stella")
    func test_no_generics_nested_function_nested_function_forward_reference_good_stella_6092c5a4() throws {
        let source = #"""
language core;

extend with #nested-function-declarations;

fn main(n : Nat) -> Nat {
  fn caller(x : Nat) -> Nat {
    return callee(x)
  }
  fn callee(x : Nat) -> Nat {
    return succ(x)
  }
  return caller(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/nested-function/nested-function-forward-reference-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/nested-function/nested-function-good.stella")
    func test_no_generics_nested_function_nested_function_good_stella_05fa95f4() throws {
        let source = #"""
language core;

extend with #nested-function-declarations;

fn main(n : Nat) -> Nat {
  fn increment(x : Nat) -> Nat {
    return succ(x)
  }
  return increment(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/nested-function/nested-function-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/nested-function/nested-function-multiple-good.stella")
    func test_no_generics_nested_function_nested_function_multiple_good_stella_990372e2() throws {
        let source = #"""
language core;

extend with #nested-function-declarations;



fn main(n : Nat) -> Nat {
  fn addTwo(x : Nat) -> Nat {
    return succ(succ(x))
  }
  fn addThree(x : Nat) -> Nat {
    return succ(succ(succ(x)))
  }
  return addTwo(addThree(n))
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/nested-function/nested-function-multiple-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/part-1-problems/main-161.stella")
    func test_no_generics_part_1_problems_main_161_stella_9df00fca() throws {
        let source = #"""
language core;

fn iszero(n : Nat) -> Bool {
    return Nat::rec(n, true, fn(i : Nat) {
        return fn(r : Bool) {
            return true
        }
    })
}

fn f(g : fn(Bool) -> Nat) -> fn(Nat) -> Nat {
    return fn(n : Nat) {
        return g(if iszero(n) then false else true)
    }
}

fn main(f : Nat) -> Nat {
  return f(fn (x : Bool) { return if x then n else succ(n) })(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/part-1-problems/main-161.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/part-1-problems/main-249.stella")
    func test_no_generics_part_1_problems_main_249_stella_7fd61872() throws {
        let source = #"""
language core;

extend with #let-bindings;
extend with #lists;

fn Nat::add(n : Nat) -> fn(Nat) -> Nat {
  return fn(m : Nat) {
    return Nat::rec(n, m, fn(i : Nat) {
      return fn(r : Nat) {
        return succ( r );
      };
    });
  };
}


fn square(n : Nat) -> Nat {
  return Nat::rec(n, 0, fn(i : Nat) {
      return fn(r : Nat) {

        return let double = false in Nat::add([double])(succ(r))
      }
  })
}

fn main(n : Nat) -> Nat {
  return square(n)}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/part-1-problems/main-249.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/part-1-problems/main-266.stella")
    func test_no_generics_part_1_problems_main_266_stella_5bc9a909() throws {
        let source = #"""
language core;

extend with #lists;

fn foo(a : Nat) -> Nat {
  return 0
}

fn main(n : Nat) -> [Nat] {
  return (fn (a : Nat) { return cons(0, [true]); } ) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/part-1-problems/main-266.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/part-1-problems/main-287.stella")
    func test_no_generics_part_1_problems_main_287_stella_add85e06() throws {
        let source = #"""
language core;

extend with #records;

fn main(x : Nat) -> Nat {
  return
    { f = 0, g = fn(x : Bool) { return if x then succ(0) else 0 }}.h(false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/part-1-problems/main-287.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/part-1-problems/main-318.stella")
    func test_no_generics_part_1_problems_main_318_stella_50bb6c0f() throws {
        let source = #"""
language core;
extend with #records;

fn main(x : Nat) -> Nat {
  return
    { x = { x = { x = { x = false, y = 0}
                , a = { x = 0, y = 0, z = true}}
          , y = { x = { x = false, y = 0}
                , y = { x = false, y = 0}}}
    , y = { a = { x = { x = 0, y = 0}
                , y = { x = 0, y = 0}}
          , y = { x = { a = 0, y = 0}
                , y = { x = false, y = 0}}}}.x.y.a.y
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/part-1-problems/main-318.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/part-1-problems/main-346.stella")
    func test_no_generics_part_1_problems_main_346_stella_3624656d() throws {
        let source = #"""
language core;
extend with #variants;

fn g(x : <| number : Nat, boolean : Bool, function : fn(Nat) -> Nat |>) -> Nat {
  return match x {
      <| number1   = n |> => succ(n)
    | <| function = f |> => f(f(succ(0)))
  }
}

fn main(x : Nat) -> Nat {
  return g(<| function = fn(n : Nat) { return g(<| number = n |>) } |>)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/part-1-problems/main-346.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/part-1-problems/main-358.stella")
    func test_no_generics_part_1_problems_main_358_stella_2e13f2c4() throws {
        let source = #"""
language core;
extend with #variants;
extend with #type-ascriptions;

fn g(x : <| number : Nat, boolean : Bool, function : fn(Nat) -> Nat |>) -> Nat {
  return match x {
      <| number   = n |> => succ(n)
    | <| boolean  = b |> => if b then succ(0) else 0
    | <| function = f |> => f(f(succ(0)))
    | <| unknown  = x |> => 0
  }
}

fn main(x : Nat) -> Nat {
  return g(<| function = fn(n : Nat) {
      return g(<| unknown = n |>
        as <| number : Nat, boolean : Bool, function : fn(Nat) -> Nat |>) }
  |> as <| number : Nat, boolean : Bool, function : fn(Nat) -> Nat |>)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/part-1-problems/main-358.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/part-1-problems/main-370.stella")
    func test_no_generics_part_1_problems_main_370_stella_aee713fc() throws {
        let source = #"""
language core;
extend with #lists;
extend with #variants;

fn proc(list : [Bool]) -> Nat {
  return if List::head(list)
    then 0
    else if List::head(list)
             then succ(0)
             else succ(succ(0));
}

fn main(n : Nat) -> Nat {
  return proc(cons(false, [true, false, <| value = n |>, false]))
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/part-1-problems/main-370.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/part-1-problems/main-377.stella")
    func test_no_generics_part_1_problems_main_377_stella_e7b65642() throws {
        let source = #"""
language core;
extend with #lists;
extend with #variants;

fn proc(list : [Bool]) -> Nat {
  return if List::head(list)
    then 0
    else if List::head(list)
             then succ(0)
             else succ(succ(0));
}

fn main(n : Nat) -> Nat {
  return proc(cons(false, [true, false, <| value = n |>, false]))
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/part-1-problems/main-377.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/part-1-problems/main-443.stella")
    func test_no_generics_part_1_problems_main_443_stella_d5ec0a8b() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return fn(a : Bool) {
    return if a then 0 else succ(0)  };
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/part-1-problems/main-443.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/records/record-duplicate-fields-bad.stella")
    func test_no_generics_records_record_duplicate_fields_bad_stella_b86939f0() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : Nat) -> {a : Nat} {
  return {a = n, a = n}
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-duplicate-fields-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/records/record-duplicate-type-fields-bad.stella")
    func test_no_generics_records_record_duplicate_type_fields_bad_stella_80328833() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : {a : Nat, a : Nat}) -> Nat {
  return n.a
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-duplicate-type-fields-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/records/record-duplicate-type-fields-in-lambda-check-bad.stella")
    func test_no_generics_records_record_duplicate_type_fields_in_lambda_check_bad_stella_728b2f73() throws {
        let source = #"""
language core;

extend with #records;

fn f(x : fn({a : Nat, a : Nat}) -> Nat) -> Nat {
  return 0
}

fn main(n : Nat) -> Nat {
  return f(fn(r : {a : Nat, a : Nat}) { return 0 })
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-duplicate-type-fields-in-lambda-check-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/records/record-duplicate-type-fields-in-lambda-infer-bad.stella")
    func test_no_generics_records_record_duplicate_type_fields_in_lambda_infer_bad_stella_8c9e94fc() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : Nat) -> Nat {
  return (fn(r : {a : Nat, a : Nat}) { return 0 })(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-duplicate-type-fields-in-lambda-infer-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/records/record-literal-bad.stella")
    func test_no_generics_records_record_literal_bad_stella_88113e13() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : Nat) -> { a : Nat, b : Bool } {
  return { a = n, b = n }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-literal-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/records/record-literal-good.stella")
    func test_no_generics_records_record_literal_good_stella_cefd1975() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : Nat) -> { a : Nat, b : Nat } {
  return { a = n, b = n }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-literal-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/records/record-missing-fields-bad.stella")
    func test_no_generics_records_record_missing_fields_bad_stella_9994cb68() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : Nat) -> {a : Nat, b : Nat} {
  return {a = n}
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-missing-fields-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/records/record-projection-bad-type.stella")
    func test_no_generics_records_record_projection_bad_type_stella_f1c9d7c4() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : Nat) -> { a : Bool } {
  return { a = n }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-projection-bad-type.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/records/record-projection-good-type.stella")
    func test_no_generics_records_record_projection_good_type_stella_3e077938() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : { a : Nat, b : Bool }) -> Nat {
  return n.a
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-projection-good-type.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/records/record-projection-missing-field.stella")
    func test_no_generics_records_record_projection_missing_field_stella_c01a8eff() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : { a : Nat }) -> Nat {
  return n.b
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-projection-missing-field.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            #expect(error.code == "ERROR_UNEXPECTED_FIELD_ACCESS")
        }
    }

    @Test("no-generics/records/record-projection-on-not-record.stella")
    func test_no_generics_records_record_projection_on_not_record_stella_7c79c154() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : Nat) -> Nat {
  return n.a
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-projection-on-not-record.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            #expect(error.code == "ERROR_NOT_A_RECORD")
        }
    }

    @Test("no-generics/records/record-type-bad.stella")
    func test_no_generics_records_record_type_bad_stella_fc48ee94() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : { a : Nat, b : Nat }) -> Bool {
  return n
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-type-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/records/record-type-good.stella")
    func test_no_generics_records_record_type_good_stella_418e04a4() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : { a : Nat, b : Nat }) -> { a : Nat, b : Nat } {
  return n
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-type-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/records/record-unexpected-field-access-bad.stella")
    func test_no_generics_records_record_unexpected_field_access_bad_stella_bcba4f5c() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : {a : Nat}) -> Nat {
  return n.b
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-unexpected-field-access-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/records/record-unexpected-fields-bad.stella")
    func test_no_generics_records_record_unexpected_fields_bad_stella_13333dea() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : Nat) -> {a : Nat} {
  return {a = n, b = n}
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/record-unexpected-fields-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/records/unexpected-record-bad.stella")
    func test_no_generics_records_unexpected_record_bad_stella_40121d48() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : Nat) -> Nat {
  return {a = n}
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/records/unexpected-record-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/sum-types/empty-matching-bad.stella")
    func test_no_generics_sum_types_empty_matching_bad_stella_e80ca346() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return match n {}
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/sum-types/empty-matching-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/sum-types/sum-ambiguous-in-let-bad.stella")
    func test_no_generics_sum_types_sum_ambiguous_in_let_bad_stella_d95ca204() throws {
        let source = #"""
language core;

extend with #let-bindings, #sum-types;

fn main(n : Nat) -> Nat {
  return let x = inl(n) in 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/sum-types/sum-ambiguous-in-let-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/sum-types/sum-inl-good.stella")
    func test_no_generics_sum_types_sum_inl_good_stella_ee6881ca() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(x : Nat) -> Nat + Bool {
  return inl(x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/sum-types/sum-inl-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/sum-types/sum-inl-wrong-type-bad.stella")
    func test_no_generics_sum_types_sum_inl_wrong_type_bad_stella_4d416049() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(x : Bool) -> Nat + Bool {
  return inl(x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/sum-types/sum-inl-wrong-type-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/sum-types/sum-inr-good.stella")
    func test_no_generics_sum_types_sum_inr_good_stella_bd7e421a() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(x : Bool) -> Nat + Bool {
  return inr(x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/sum-types/sum-inr-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/sum-types/sum-match-branch-mismatch-bad.stella")
    func test_no_generics_sum_types_sum_match_branch_mismatch_bad_stella_8dada2dc() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(x : Nat + Bool) -> Nat {
  return match x {
      inl(n) => n
    | inr(b) => b
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/sum-types/sum-match-branch-mismatch-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/sum-types/sum-match-exhaustive-var-good.stella")
    func test_no_generics_sum_types_sum_match_exhaustive_var_good_stella_6a36f3f2() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(x : Nat + Bool) -> Nat {
  return match x {
      y => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/sum-types/sum-match-exhaustive-var-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/sum-types/sum-match-good.stella")
    func test_no_generics_sum_types_sum_match_good_stella_2171eba1() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(x : Nat + Bool) -> Nat {
  return match x {
      inl(n) => n
    | inr(b) => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/sum-types/sum-match-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/sum-types/sum-match-missing-inl-bad.stella")
    func test_no_generics_sum_types_sum_match_missing_inl_bad_stella_105e8168() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(x : Nat + Bool) -> Nat {
  return match x {
      inr(b) => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/sum-types/sum-match-missing-inl-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/sum-types/sum-match-missing-inr-bad.stella")
    func test_no_generics_sum_types_sum_match_missing_inr_bad_stella_7d802c3e() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(x : Nat + Bool) -> Nat {
  return match x {
      inl(n) => n
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/sum-types/sum-match-missing-inr-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/sum-types/sum-nested-good.stella")
    func test_no_generics_sum_types_sum_nested_good_stella_ed9d6c55() throws {
        let source = #"""
language core;

extend with #sum-types;

fn wrap(x : Nat) -> (Nat + Bool) + Nat {
  return inl(inl(x))
}

fn main(n : Nat) -> (Nat + Bool) + Nat {
  return wrap(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/sum-types/sum-nested-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/sum-types/unexpected-inl-bad.stella")
    func test_no_generics_sum_types_unexpected_inl_bad_stella_d47948e6() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(n : Nat) -> Nat {
  return inl(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/sum-types/unexpected-inl-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/sum-types/unexpected-inr-bad.stella")
    func test_no_generics_sum_types_unexpected_inr_bad_stella_7a23d5f7() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(n : Nat) -> Nat {
  return inr(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/sum-types/unexpected-inr-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/tuple/tuple-index-out-of-bounds-bad.stella")
    func test_no_generics_tuple_tuple_index_out_of_bounds_bad_stella_25a61400() throws {
        let source = #"""
language core;

extend with #tuples;

fn main(n : {Nat, Bool}) -> Nat {
  return n.3
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/tuple/tuple-index-out-of-bounds-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/tuple/tuple-literal-bad.stella")
    func test_no_generics_tuple_tuple_literal_bad_stella_3f22f9c7() throws {
        let source = #"""
language core;

extend with #tuples;

fn main(n : Nat) -> {Nat, Bool} {
  return {n, n}
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/tuple/tuple-literal-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/tuple/tuple-literal-good.stella")
    func test_no_generics_tuple_tuple_literal_good_stella_4fd08bf8() throws {
        let source = #"""
language core;

extend with #tuples;

fn main(n : Nat) -> {Nat, Nat} {
  return {n, n}
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/tuple/tuple-literal-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/tuple/tuple-literal-inl-check-bad.stella")
    func test_no_generics_tuple_tuple_literal_inl_check_bad_stella_27d882b7() throws {
        let source = #"""
language core;
extend with #sum-types, #tuples;

fn main(n : Nat) -> {Nat + Bool, Bool} {
    return {inl(n), 0}
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/tuple/tuple-literal-inl-check-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/tuple/tuple-literal-inl-check-good.stella")
    func test_no_generics_tuple_tuple_literal_inl_check_good_stella_caae38c9() throws {
        let source = #"""
language core;
extend with #sum-types, #tuples;

fn main(n : Nat) -> {Nat + Bool, Bool} {
    return {inl(n), true}
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/tuple/tuple-literal-inl-check-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/tuple/tuple-projection-bad-type.stella")
    func test_no_generics_tuple_tuple_projection_bad_type_stella_d03ae5a7() throws {
        let source = #"""
language core;

extend with #tuples;

fn main(n : {Nat, Bool}) -> Nat {
  return n.2
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/tuple/tuple-projection-bad-type.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/tuple/tuple-projection-good-type.stella")
    func test_no_generics_tuple_tuple_projection_good_type_stella_52035773() throws {
        let source = #"""
language core;

extend with #tuples;

fn main(n : {Nat, Bool}) -> Nat {
  return n.1
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/tuple/tuple-projection-good-type.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/tuple/tuple-projection-on-noy-tuple.stella")
    func test_no_generics_tuple_tuple_projection_on_noy_tuple_stella_1f2ba2b2() throws {
        let source = #"""
language core;

extend with #tuples;

fn main(n : Nat) -> Nat {
  return n.2
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/tuple/tuple-projection-on-noy-tuple.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            #expect(error.code == "ERROR_NOT_A_TUPLE")
        }
    }

    @Test("no-generics/tuple/tuple-type-bad.stella")
    func test_no_generics_tuple_tuple_type_bad_stella_8b33bf29() throws {
        let source = #"""
language core;

extend with #tuples;

fn main(n : {Nat, Nat}) -> Bool {
  return n
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/tuple/tuple-type-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/tuple/tuple-type-good.stella")
    func test_no_generics_tuple_tuple_type_good_stella_f44bae53() throws {
        let source = #"""
language core;

extend with #tuples;

fn main(n : {Nat, Nat}) -> {Nat, Nat} {
  return n
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/tuple/tuple-type-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/tuple/tuple-unexpected-length-bad.stella")
    func test_no_generics_tuple_tuple_unexpected_length_bad_stella_efb4c718() throws {
        let source = #"""
language core;

extend with #pairs, #tuples;

fn main(n : Nat) -> {Nat, Nat} {
  return {n, n, n}
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/tuple/tuple-unexpected-length-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/tuple/unexpected-tuple-bad.stella")
    func test_no_generics_tuple_unexpected_tuple_bad_stella_5afe7747() throws {
        let source = #"""
language core;

extend with #tuples;

fn main(n : Nat) -> Nat {
  return {n, n}
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/tuple/unexpected-tuple-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/type-ascription/type-ascription-bad-context.stella")
    func test_no_generics_type_ascription_type_ascription_bad_context_stella_5103ffd1() throws {
        let source = #"""
language core;

extend with #type-ascriptions;

fn main(n : Nat) -> Bool {
  return n as Nat
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/type-ascription/type-ascription-bad-context.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/type-ascription/type-ascription-bad-inner-type.stella")
    func test_no_generics_type_ascription_type_ascription_bad_inner_type_stella_4dc55aa3() throws {
        let source = #"""
language core;

extend with #type-ascriptions;

fn main(n : Nat) -> Bool {
  return n as Bool
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/type-ascription/type-ascription-bad-inner-type.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/type-ascription/type-ascription-nat-good.stella")
    func test_no_generics_type_ascription_type_ascription_nat_good_stella_0bcb6ed2() throws {
        let source = #"""
language core;

extend with #type-ascriptions;

fn main(n : Nat) -> Nat {
  return n as Nat
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/type-ascription/type-ascription-nat-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/unit-types/unit-bad.stella")
    func test_no_generics_unit_types_unit_bad_stella_f7a43402() throws {
        let source = #"""
language core;

extend with #unit-type;

fn main(n : Nat) -> Unit {
  return n
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/unit-types/unit-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/unit-types/unit-constant-bad.stella")
    func test_no_generics_unit_types_unit_constant_bad_stella_206d90f4() throws {
        let source = #"""
language core;

extend with #unit-type;

fn main(n : Nat) -> Nat {
  return unit
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/unit-types/unit-constant-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/unit-types/unit-constant-good.stella")
    func test_no_generics_unit_types_unit_constant_good_stella_96466c4e() throws {
        let source = #"""
language core;

extend with #unit-type;

fn main(n : Nat) -> Unit {
  return unit
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/unit-types/unit-constant-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/unit-types/unit-good.stella")
    func test_no_generics_unit_types_unit_good_stella_4344658b() throws {
        let source = #"""
language core;

extend with #unit-type;

fn main(n : Unit) -> Unit {
  return n
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/unit-types/unit-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/variants/unexpected-injection-pattern-for-variant-bad.stella")
    func test_no_generics_variants_unexpected_injection_pattern_for_variant_bad_stella_3fcbdf4b() throws {
        let source = #"""
language core;

extend with #variants, #sum-types;

fn main(x : <| a : Nat, b : Bool |>) -> Nat {
  return match x {
      inl(n) => n
    | inr(b) => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/variants/unexpected-injection-pattern-for-variant-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/variants/unexpected-pattern-for-type-bad.stella")
    func test_no_generics_variants_unexpected_pattern_for_type_bad_stella_36ffcac4() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(n : Nat) -> Nat {
  return match n {
      inl(x) => x
    | inr(y) => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/variants/unexpected-pattern-for-type-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/variants/unexpected-variant-bad.stella")
    func test_no_generics_variants_unexpected_variant_bad_stella_ef1fd09c() throws {
        let source = #"""
language core;

extend with #variants;

fn main(n : Nat) -> Nat {
  return <| left = n |>
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/variants/unexpected-variant-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/variants/unexpected-variant-pattern-for-sum-bad.stella")
    func test_no_generics_variants_unexpected_variant_pattern_for_sum_bad_stella_331f3a10() throws {
        let source = #"""
language core;

extend with #sum-types, #variants;

fn main(x : Nat + Bool) -> Nat {
  return match x {
      <| a = n |> => n
    | <| b = b |> => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/variants/unexpected-variant-pattern-for-sum-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/variants/variant-ambiguous-in-let-bad.stella")
    func test_no_generics_variants_variant_ambiguous_in_let_bad_stella_52a13c44() throws {
        let source = #"""
language core;

extend with #let-bindings, #variants;

fn main(n : Nat) -> Nat {
  return let x = <| left = n |> in 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/variants/variant-ambiguous-in-let-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/variants/variant-construct-good.stella")
    func test_no_generics_variants_variant_construct_good_stella_d2f5fd5a() throws {
        let source = #"""
language core;

extend with #variants;

fn main(x : Nat) -> <| left : Nat, right : Bool |> {
  return <| left = x |>
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/variants/variant-construct-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/variants/variant-duplicate-type-fields-bad.stella")
    func test_no_generics_variants_variant_duplicate_type_fields_bad_stella_6dd361fa() throws {
        let source = #"""
language core;

extend with #variants;

fn main(n : <| a : Nat, a : Bool |>) -> Nat {
  return 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/variants/variant-duplicate-type-fields-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/variants/variant-match-all-data-good.stella")
    func test_no_generics_variants_variant_match_all_data_good_stella_76fbcacb() throws {
        let source = #"""
language core;

extend with #variants;

fn main(x : <| left : Nat, right : Bool |>) -> Nat {
  return match x {
      <| left = n |> => n
    | <| right = b |> => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/variants/variant-match-all-data-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/variants/variant-match-nonexhaustive-bad.stella")
    func test_no_generics_variants_variant_match_nonexhaustive_bad_stella_78463a89() throws {
        let source = #"""
language core;

extend with #variants;

fn main(x : <| left : Nat, right : Bool |>) -> Nat {
  return match x {
      <| left = n |> => n
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/variants/variant-match-nonexhaustive-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/variants/variant-match-type-mismatch-bad.stella")
    func test_no_generics_variants_variant_match_type_mismatch_bad_stella_90c054c4() throws {
        let source = #"""
language core;

extend with #variants;

fn main(x : <| left : Nat, right : Bool |>) -> Nat {
  return match x {
      <| left = n |> => n
    | <| right = b |> => b
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/variants/variant-match-type-mismatch-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/variants/variant-match-unexpected-label-bad.stella")
    func test_no_generics_variants_variant_match_unexpected_label_bad_stella_90fca53d() throws {
        let source = #"""
language core;

extend with #variants;

fn main(x : <| left : Nat, right : Bool |>) -> Nat {
  return match x {
      <| left = n |> => n
    | <| right = b |> => 0
    | <| unexistent = z |> => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/variants/variant-match-unexpected-label-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("no-generics/variants/variant-nested-good.stella")
    func test_no_generics_variants_variant_nested_good_stella_a2e90aaf() throws {
        let source = #"""
language core;

extend with #variants;

fn main(x : <| inner : <| a : Nat, b : Bool |>, outer : Nat |>) -> Nat {
  return match x {
      <| inner = v |> => match v {
          <| a = n |> => n
        | <| b = flag |> => 0
      }
    | <| outer = n |> => n
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/variants/variant-nested-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("no-generics/variants/variant-three-fields-good.stella")
    func test_no_generics_variants_variant_three_fields_good_stella_eeca9916() throws {
        let source = #"""
language core;

extend with #variants;

fn main(x : Nat) -> <| a : Nat, b : Bool, c : Nat |> {
  return <| c = succ(x) |>
}
"""#
        let program = try Program.parser.run(
            sourceName: "no-generics/variants/variant-three-fields-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }
}
