import Testing
@testable import StellaSemanticAnalyzer

@Suite("Imported ok tests")
@MainActor
struct ImportedOKTests {
    @Test("ok/ambiguous_type_as_bottom_from_task.st")
    func test_ok_ambiguous_type_as_bottom_from_task_st_a4539e94() throws {
        let source = #"""
language core;
extend with #ambiguous-type-as-bottom, #structural-subtyping, #sum-types;
fn main(n : Nat) -> Bool + Nat {
  return (fn (x : Nat) {
    return inr(x)
  })(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/ambiguous_type_as_bottom_from_task.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/assignment_ref_ref.st")
    func test_ok_assignment_ref_ref_st_363d84ef() throws {
        let source = #"""
language core;
extend with #references, #sequencing;

fn main(n : &&Nat) -> Nat {
	return *n := 0; succ(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/assignment_ref_ref.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/assignment_to_parameter.st")
    func test_ok_assignment_to_parameter_st_c764cf21() throws {
        let source = #"""
language core;
extend with #references, #sequencing;

fn main(n : &Nat) -> Nat {
	return n := 0; succ(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/assignment_to_parameter.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/cast_as.st")
    func test_ok_cast_as_st_22773a5f() throws {
        let source = #"""
language core;

extend with #natural-literals, #type-cast, #pairs, #top-type, #structural-subtyping;

fn main(n : Nat) -> Nat {
	return (1 cast as {Nat, Nat}).1
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/cast_as.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/cons.st")
    func test_ok_cons_st_fbb235d8() throws {
        let source = #"""
language core;

extend with #lists;


fn main(n : Nat) -> [Nat] {
  return  cons(0, []);
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/cons.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/cons_reconstruct.st")
    func test_ok_cons_reconstruct_st_665b9dc1() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;


fn main(n : Nat) -> [Nat] {
  return  cons(0, []);
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/cons_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/const.st")
    func test_ok_const_st_2df95d16() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn const[X, Y](x : X) -> fn(Y) -> X {
  return fn(y : Y) {
    return x
  }
}

fn main(x : Nat) -> Nat {
  return const[Nat, Bool](x)(false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/const.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/const2.st")
    func test_ok_const2_st_d34c64ab() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn const[X](x : X) -> forall Y. fn(Y) -> X {
  return generic [Y] fn(y : Y) { return x }
}

fn main(x : Nat) -> Nat {
  return const[Nat](x)[Bool](false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/const2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/const_identity.st")
    func test_ok_const_identity_st_c47b4164() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn identity[T](x : T) -> T {
  return x
}

generic fn const[X, Y](x : X) -> fn(Y) -> X {
  return identity[fn(Y) -> X](
  	fn(y : Y) {
    	return x
  	}
  )
}

fn main(x : Nat) -> Nat {
  return const[Nat, Bool](x)(false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/const_identity.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/deref_deref_ref_ref.st")
    func test_ok_deref_deref_ref_ref_st_3786f822() throws {
        let source = #"""
language core;
extend with #references, #sequencing;

fn main(n : &&Nat) -> Nat {
	return **n
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/deref_deref_ref_ref.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/deref_parameter.st")
    func test_ok_deref_parameter_st_ba4b3182() throws {
        let source = #"""
language core;
extend with #references;

fn foo(n : &Nat) -> Nat { return *n }

fn main(n : Nat) -> Nat {
	return foo(new (n))
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/deref_parameter.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/exhaustive_bool.st")
    func test_ok_exhaustive_bool_st_769ff903() throws {
        let source = #"""
language core;

extend with #structural-patterns;

fn main(n : Nat) -> Nat {
  return match true {
    	true => 0
    | false => 0
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/exhaustive_bool.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/exhaustive_fun.st")
    func test_ok_exhaustive_fun_st_bf934e30() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #variants;

fn main(n : (fn(Nat) -> Nat)) -> Nat {
  return match n {
    	a => 0
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/exhaustive_fun.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/exhaustive_list.st")
    func test_ok_exhaustive_list_st_5ec2cd90() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #lists;

fn test(n : [Nat]) -> Nat {
  return match n {
    	[] => 0
    	| [a] => a
      | [a, b] => a
      | [a, b, c] => a
      | cons (1, xs) => 1
    	| cons (2, cons(3, xs)) => 2
    	| cons (a, cons(b, [1, 2])) => b
    	| cons (a, cons(b, cons(c, cs))) => c
   }
}

fn main(n : [Nat]) -> Nat {
  return match n {
    	[] => 0
    	| cons (x, xs) => 0
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/exhaustive_list.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/exhaustive_nat_constructors.st")
    func test_ok_exhaustive_nat_constructors_st_3e9e6d90() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals;

fn test(input : Nat) -> Nat {
  return match input {
      succ(succ(n)) => n
    | succ(n) => n
    | _ => 0
  }
}

fn main(n : Nat) -> Nat {
  return match 5 {
    	0 => 0
    | succ(n) => 0
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/exhaustive_nat_constructors.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/exhaustive_nested_tuple.st")
    func test_ok_exhaustive_nested_tuple_st_bda3befb() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #tuples;

fn main(n : Nat) -> Nat {
  return match {{0, true}, {0, true}} {
    	{a, b} => 0
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/exhaustive_nested_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/exhaustive_record.st")
    func test_ok_exhaustive_record_st_d138064c() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #records;

fn main(n : Nat) -> Nat {
  return match {a = true, b = 0} {
    	{b = c, a = d} => c
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/exhaustive_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/exhaustive_sum.st")
    func test_ok_exhaustive_sum_st_b46367de() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #sum-types;

fn main(n : Nat + Bool) -> Nat {
  return match n {
    	inl(a) => a
    | inr(b) => 0
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/exhaustive_sum.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/exhaustive_sum_arg.st")
    func test_ok_exhaustive_sum_arg_st_6adfaaaf() throws {
        let source = #"""
language core;

extend with #sum-types, #unit-type;

fn test(first : Nat + Bool) -> Nat {
  return match first {
     a => 0
  }
}

fn main(input : Bool) -> Nat {
  return test(inl(0))
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/exhaustive_sum_arg.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/exhaustive_tuple.st")
    func test_ok_exhaustive_tuple_st_9e65b9b3() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #tuples;

fn main(n : Nat) -> Nat {
  return match {0, true} {
    	{a, b} => 0
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/exhaustive_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/exhaustive_unit.st")
    func test_ok_exhaustive_unit_st_adb9722c() throws {
        let source = #"""
language core;

extend with #structural-patterns, #unit-type;

fn main(n : Nat) -> Nat {
  return match unit {
    	unit => 0
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/exhaustive_unit.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/exhaustive_unit_var.st")
    func test_ok_exhaustive_unit_var_st_7341f91b() throws {
        let source = #"""
language core;

extend with #structural-patterns, #unit-type;

fn main(n : Nat) -> Nat {
  return match unit {
    	a => 0
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/exhaustive_unit_var.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/exhaustive_variant.st")
    func test_ok_exhaustive_variant_st_ea81d68b() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #variants;

fn main(n : <| a : Nat, b : Bool |>) -> Nat {
  return match n {
    	<| a = t |> => t
    | <| b = t |> => 0
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/exhaustive_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/expections_from_task.st")
    func test_ok_expections_from_task_st_b1f0d8d9() throws {
        let source = #"""
language core;
extend with #exceptions, #exception-type-declaration;
exception type = Nat
fn fail(n : Nat) -> Bool {
  return throw(succ(0))
}
fn main(n : Nat) -> Bool {
  return try { fail(n) } catch { a => true }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/expections_from_task.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/fix_from_arg.st")
    func test_ok_fix_from_arg_st_c65ec32f() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator;

fn main(f : fn(Nat) -> Nat) -> Nat {
  return fix(f);
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/fix_from_arg.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/fix_from_arg_reconstruct.st")
    func test_ok_fix_from_arg_reconstruct_st_f0fd4f58() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn main(f : fn(auto) -> auto) -> auto {
  return fix(f);
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/fix_from_arg_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            #expect(error.code == "ERROR_AMBIGUOUS_TYPE")
        }
    }

    @Test("ok/fixpoint.st")
    func test_ok_fixpoint_st_2461c115() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator;

fn main(n : Nat) -> Nat {
  return fix(fn(y : Nat) { return n });
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/fixpoint.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/fixpoint_reconstruct.st")
    func test_ok_fixpoint_reconstruct_st_c9853a41() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn main(n : auto) -> auto {
  return fix(fn(y : auto) { return n });
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/fixpoint_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            #expect(error.code == "ERROR_AMBIGUOUS_TYPE")
        }
    }

    @Test("ok/identity.st")
    func test_ok_identity_st_7bd6ecf6() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn identity[T](x : T) -> T {
  return x
}

fn main(x : Nat) -> Nat {
  return identity[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/identity.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/increment_twice.st")
    func test_ok_increment_twice_st_c475f19a() throws {
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
            sourceName: "ok/increment_twice.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/increment_twice_reconstruct.st")
    func test_ok_increment_twice_reconstruct_st_9cea810f() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn increment_twice(n : auto) -> auto {
  return succ(succ(n))
}

fn main(n : auto) -> auto {
  return increment_twice(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/increment_twice_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/infer_cons.st")
    func test_ok_infer_cons_st_5f375053() throws {
        let source = #"""
language core;

extend with #lists;

fn foo(a : Nat) -> Nat {
  return 0
}

fn main(n : Nat) -> [Nat] {
  return (fn (a : Nat) { return cons(0, []); } ) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/infer_cons.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/infer_cons_reconstruct.st")
    func test_ok_infer_cons_reconstruct_st_50bb44e2() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn foo(a : auto) -> auto {
  return 0
}

fn main(n : Nat) -> [Nat] {
  return (fn (a : auto) { return cons(0, []); } ) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/infer_cons_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            #expect(error.code == "ERROR_AMBIGUOUS_TYPE")
        }
    }

    @Test("ok/infer_fix.st")
    func test_ok_infer_fix_st_93e63c3b() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator;

fn foo(a : Nat) -> Nat {
  return 0
}

fn main(n : Nat) -> Nat {
  return (fn (a : Nat) { return fix(foo); } ) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/infer_fix.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/infer_fix_reconstruct.st")
    func test_ok_infer_fix_reconstruct_st_8599da5f() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn foo(a : auto) -> auto {
  return 0
}

fn main(n : auto) -> auto {
  return (fn (a : auto) { return fix(foo); } ) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/infer_fix_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            #expect(error.code == "ERROR_AMBIGUOUS_TYPE")
        }
    }

    @Test("ok/infer_iszero.st")
    func test_ok_infer_iszero_st_4a615385() throws {
        let source = #"""
language core;

fn main(a : Nat) -> Bool {
 	return (fn (a : Nat) { return Nat::iszero(0); } ) (a)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/infer_iszero.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/infer_match.st")
    func test_ok_infer_match_st_2a418b7a() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return (fn (a : Nat) { return match(0) {
    x => x
		}
  }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/infer_match.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/infer_with_semicolon.st")
    func test_ok_infer_with_semicolon_st_91a9b494() throws {
        let source = #"""
language core;

fn main(a : Nat) -> Nat {
 return (fn (a : Nat) { return 0; } ) (a)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/infer_with_semicolon.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/int_literal.st")
    func test_ok_int_literal_st_014bc7aa() throws {
        let source = #"""
language core;

extend with #natural-literals;


fn main(n : Nat) -> Nat {
  return 5;
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/int_literal.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/let_asc.st")
    func test_ok_let_asc_st_79775283() throws {
        let source = #"""
language core;

extend with  #let-patterns, #pattern-ascriptions, #let-bindings;

fn foo(n : Nat) -> Nat {
	return n
}

fn main(n : Nat) -> Bool {
    return let (x as Bool) = true in x
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/let_asc.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/let_bool.st")
    func test_ok_let_bool_st_10bfce97() throws {
        let source = #"""
language core;
extend with #let-bindings;

fn foo(n : Nat) -> Bool {
  return let t = true in t
}

fn main(n : Nat) -> Bool {
  return let t = false in t
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/let_bool.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/let_fun.st")
    func test_ok_let_fun_st_f934d62d() throws {
        let source = #"""
language core;
extend with #let-bindings;


fn main(n : Nat) -> Nat {
  return let zeroFun = (fn (a : Nat) {return a}) in zeroFun(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/let_fun.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/let_fun_reconstruct.st")
    func test_ok_let_fun_reconstruct_st_9d7a16dd() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #let-bindings;


fn main(n : auto) -> auto {
  return let zeroFun = (fn (a : auto) {return a}) in zeroFun(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/let_fun_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_TYPE")
        }
    }

    @Test("ok/let_if.st")
    func test_ok_let_if_st_b8f70ed7() throws {
        let source = #"""
language core;
extend with #let-bindings;


fn main(n : Nat) -> Nat {
  return let x = if false then 0 else succ(0) in x
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/let_if.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/let_isempty.st")
    func test_ok_let_isempty_st_7b0e27cd() throws {
        let source = #"""
language core;
extend with #let-bindings;
extend with #lists;


fn main(n : Nat) -> Bool {
 return let x = List::isempty([0, 0]) in x
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/let_isempty.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/let_let.st")
    func test_ok_let_let_st_f9ab3eed() throws {
        let source = #"""
language core;
extend with #let-bindings;


fn main(n : Nat) -> Nat {
  return let y = let x = 0 in x in y
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/let_let.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/let_let_reconstruct.st")
    func test_ok_let_let_reconstruct_st_0b7a1efe() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #let-bindings;


fn main(n : auto) -> auto {
  return let y = let x = 0 in x in y
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/let_let_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            #expect(error.code == "ERROR_AMBIGUOUS_TYPE")
        }
    }

    @Test("ok/let_rec.st")
    func test_ok_let_rec_st_10adc4f1() throws {
        let source = #"""
language core;
extend with #let-bindings;


fn main(n : Nat) -> Nat {
  return let y = let step = (fn (i : Nat) { return fn (cur : Nat) { return succ(cur) } })
              in Nat::rec(succ(0), 0, step)
         in y

}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/let_rec.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/let_square.st")
    func test_ok_let_square_st_1b5f80dc() throws {
        let source = #"""
language core;
extend with #let-bindings;

fn Nat::add(n : Nat) -> (fn(Nat) -> Nat) {
  return fn(m : Nat) {
    return Nat::rec(n, m, fn(i : Nat) {
      return fn(r : Nat) { return succ(r) } })
  }
}

fn square(n : Nat) -> Nat {
  return Nat::rec(n, 0, fn(i : Nat) {
      return fn(r : Nat) {

        return let double = Nat::add(i)(i) in Nat::add(double)(succ(r))
      }
  })
}

fn main(n : Nat) -> Nat {
  return square(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/let_square.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/let_square_reconstruct.st")
    func test_ok_let_square_reconstruct_st_86e09e62() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #let-bindings;

fn Nat::add(n : auto) -> auto {
  return fn(m : auto) {
    return Nat::rec(n, m, fn(i : auto) {
      return fn(r : auto) { return succ(r) } })
  }
}

fn square(n : auto) -> auto {
  return Nat::rec(n, 0, fn(i : auto) {
      return fn(r : auto) {

        return let double = Nat::add(i)(i) in Nat::add(double)(succ(r))
      }
  })
}

fn main(n : auto) -> auto {
  return square(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/let_square_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/let_unit.st")
    func test_ok_let_unit_st_e09c7eb6() throws {
        let source = #"""
language core;
extend with #unit-type;
extend with #let-bindings;


fn main(n : Nat) -> Unit {
  return let x = unit in x
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/let_unit.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/letrec.st")
    func test_ok_letrec_st_5ef87093() throws {
        let source = #"""
language core;

extend with  #let-patterns, #pattern-ascriptions, #let-bindings, #letrec-bindings;

fn foo(n : Nat) -> Nat {
	return n
}

fn main(n : Nat) -> Bool {
    return letrec (x as Bool) = true in x
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/letrec.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/letrec_fn.st")
    func test_ok_letrec_fn_st_ee919597() throws {
        let source = #"""
language core;

extend with  #let-patterns, #pattern-ascriptions, #let-bindings, #letrec-bindings;

fn foo(n : Nat) -> Nat {
	return n
}

fn main(n : Nat) -> Nat {
    return letrec (f as fn (Nat) -> Nat) = fn (a : Nat) {
          return if Nat::iszero(a) then 0 else f(a)
  	}
  	in f(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/letrec_fn.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/list_ascription.st")
    func test_ok_list_ascription_st_cebda89f() throws {
        let source = #"""
language core;
extend with #type-ascriptions;
extend with #lists;

fn main(n : Nat) -> [Bool] {
  return [] as [Bool]
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/list_ascription.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/list_ascription_reconstruct.st")
    func test_ok_list_ascription_reconstruct_st_d04ea6a7() throws {
        let source = #"""
language core;
extend with #type-ascriptions;
extend with #type-reconstruction, #lists;

fn main(n : Nat) -> [Bool] {
  return [] as [Bool]
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/list_ascription_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/list_lenght_letrec.st")
    func test_ok_list_lenght_letrec_st_09dada55() throws {
        let source = #"""
language core;

extend with  #let-patterns, #pattern-ascriptions, #let-bindings, #letrec-bindings, #lists;

fn foo(n : Nat) -> Nat {
	return n
}

fn main(n : Nat) -> Nat {
    return letrec length as (fn ([Nat]) -> Nat) =
      (
        fn(xs : [Nat]) { return
          if List::isempty(xs)
            then 0
          else succ (length (List::tail(xs)))
          }
      ) in let list = cons(0, (cons(0, []))) in length (list)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/list_lenght_letrec.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/list_operations.st")
    func test_ok_list_operations_st_11b5d8b8() throws {
        let source = #"""
language core;

extend with #lists;

fn first_or_default(list : [Nat]) -> Nat {
  return if List::isempty(list) then List::head(List::tail([0,0,0])) else List::head(list)
}

fn main(arg : Nat) -> Nat {
  return first_or_default([0, 0, 0])
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/list_operations.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/list_operations_reconstruct.st")
    func test_ok_list_operations_reconstruct_st_41745cc0() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn first_or_default(list : [auto]) -> auto {
  return if List::isempty(list) then List::head(List::tail([0,0,0])) else List::head(list)
}

fn main(arg : auto) -> auto {
  return first_or_default([0, 0, 0])
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/list_operations_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            #expect(error.code == "ERROR_AMBIGUOUS_TYPE")
        }
    }

    @Test("ok/memory_in_if.st")
    func test_ok_memory_in_if_st_54013864() throws {
        let source = #"""
language core;
extend with #references, #type-ascriptions;

fn foo(n : Nat) -> &Nat { return if Nat::iszero(n) then <0x01> else <0x02> }

fn main(n : Nat) -> Nat {
	return *foo(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/memory_in_if.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/memory_in_if_2.st")
    func test_ok_memory_in_if_2_st_fd403b37() throws {
        let source = #"""
language core;
extend with #references, #type-ascriptions;

fn main(n : Nat) -> Nat {
	return *(if Nat::iszero(n) then <0x01> else <0x02>)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/memory_in_if_2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/memory_pass_to_func.st")
    func test_ok_memory_pass_to_func_st_013b9a2d() throws {
        let source = #"""
language core;
extend with #references, #type-ascriptions;

fn foo(n : &Nat) -> Nat { return *n }

fn main(n : Nat) -> Nat {
	return foo(<0x01>)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/memory_pass_to_func.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/memory_write_read.st")
    func test_ok_memory_write_read_st_d8433de6() throws {
        let source = #"""
language core;
extend with #references, #sequencing, #type-ascriptions;

fn main(n : Nat) -> Nat {
	return ((<0x01> as &Nat) := 0); *(<0x01> as &Nat)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/memory_write_read.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/memory_write_read_2.st")
    func test_ok_memory_write_read_2_st_644b90dc() throws {
        let source = #"""
language core;
extend with #references, #sequencing, #type-ascriptions;

fn main(n : Nat) -> Nat {
	return ((<0x01> as &Bool) := true); *(<0x01> as &Nat)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/memory_write_read_2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/memory_write_read_3.st")
    func test_ok_memory_write_read_3_st_3ab2a45d() throws {
        let source = #"""
language core;
extend with #references, #type-ascriptions;

fn main(n : Nat) -> Nat {
	return *(<0x01> as &Nat)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/memory_write_read_3.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/multiparameter_fun.st")
    func test_ok_multiparameter_fun_st_22e76a09() throws {
        let source = #"""
language core;

extend with #multiparameter-functions;

fn m_f(a : Nat, b : Bool) -> Nat {
    return if (b) then a else 0
}

fn get_m_f(a : Nat, b : Bool, c : Nat) -> (fn(Nat, Bool) -> Nat) {
    return m_f
}

fn main(n : Nat) -> Nat {
    return get_m_f(0, true, 0)(0, false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/multiparameter_fun.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/nested_functions.st")
    func test_ok_nested_functions_st_4e1bbe6e() throws {
        let source = #"""
language core;

extend with #nested-function-declarations;

fn main(n : Nat) -> Nat {
  fn nested(x : Nat) -> Bool {
   	return if (Nat::iszero(x)) then Nat::iszero(n) else false
  }

  return if (nested(n)) then 0 else succ(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/nested_functions.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/nested_functions_params_shadowing.st")
    func test_ok_nested_functions_params_shadowing_st_be0a32a2() throws {
        let source = #"""
language core;

extend with #nested-function-declarations;

fn main(n : Nat) -> Nat {
  fn nested(n : Bool) -> Bool {
   	return if (n) then n else false
  }

  return if (nested(Nat::iszero(n))) then 0 else succ(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/nested_functions_params_shadowing.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/nullary_function.st")
    func test_ok_nullary_function_st_0d1442db() throws {
        let source = #"""
language core;

extend with #nullary-functions;

fn zero() -> Nat {
    return 0
}

fn getZero() -> (fn() -> Nat) {
    return fn() {
        return zero()
    }
}

fn main(n : Nat) -> Nat {
    return getZero()()
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/nullary_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/nullary_variant.st")
    func test_ok_nullary_variant_st_15ae5dc0() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #variants, #nullary-variant-labels;

fn main(n : Nat) -> <| a : Nat, b, c |> {
  return <| c |>
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/nullary_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/nullary_variant_pattern.st")
    func test_ok_nullary_variant_pattern_st_6c7e9916() throws {
        let source = #"""
language core;

extend with #variants, #nullary-variant-labels;

fn foo(a : Nat) -> <| a : Nat, b |> {
  return <| a = 0 |>
}

fn main(n : Nat) -> Nat {
  return match(foo(0)) {
    <| a = x |> => x
    | <| b |> => 0
	}
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/nullary_variant_pattern.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/panic.st")
    func test_ok_panic_st_b7ed1b7a() throws {
        let source = #"""
language core;

extend with #panic;

fn main(n : Nat) -> Nat {
  return panic!
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/panic.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/panic_from_task.st")
    func test_ok_panic_from_task_st_fa96e8b2() throws {
        let source = #"""
language core;
extend with #panic, #pairs, #fixpoint-combinator;

fn dec(n : Nat) -> Nat {
  return Nat::rec(n, {0, 0},
    fn(k : Nat) {
      return fn(p : {Nat, Nat}) {
return { succ(p.1), p.1 }
} }).2
}


fn sub(n : Nat) -> fn(Nat) -> Nat {
  return fn(m : Nat) {
    return Nat::rec(m, n, fn(k : Nat) { return dec })
  }
}


fn mkdiv(div : fn(Nat) -> fn(Nat) -> Nat) -> fn(Nat) -> fn(Nat) -> Nat {
  return fn(n : Nat) {
    return fn(m : Nat) {
      return if Nat::iszero(n) then 0 else
        succ(div(sub(n)(m))(m))
    }
} }


fn div(n : Nat) -> fn(Nat) -> Nat {
  return fn(m : Nat) {
    return
      if Nat::iszero(m)
        then panic!
        else fix(mkdiv)(n)(m)
} }

fn main(n : Nat) -> Nat {
  return div(n)(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/panic_from_task.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/panic_in_if.st")
    func test_ok_panic_in_if_st_dfb8091a() throws {
        let source = #"""
language core;
extend with #panic, #pairs, #fixpoint-combinator, #sequencing;

fn main(n : Nat) -> Nat {
  return if false then panic! else panic!; 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/panic_in_if.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/panic_inside_lambda_as_bot.st")
    func test_ok_panic_inside_lambda_as_bot_st_60f70d23() throws {
        let source = #"""
language core;
extend with #panic, #unit-type;

fn main(n : Nat) -> Nat {
  return (fn(x : Nat) {
    	return if false then x else panic!
  }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/panic_inside_lambda_as_bot.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/panic_or_bool_as_parameter.st")
    func test_ok_panic_or_bool_as_parameter_st_c51734ac() throws {
        let source = #"""
language core;
extend with #panic, #unit-type;

fn foo(b : Bool) -> Nat {
  return 0
}

fn main(n : Nat) -> Nat {
  return foo(if false then panic! else true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/panic_or_bool_as_parameter.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/parenthesis.st")
    func test_ok_parenthesis_st_84090485() throws {
        let source = #"""
language core;
extend with #unit-type;
extend with #let-bindings;


fn main(n : Nat) -> Nat {
  return (let x = ((fn (a : Nat) { return ((succ(a))) } )) in ((x))((0)))
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/parenthesis.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/parenthesis_reconstruct.st")
    func test_ok_parenthesis_reconstruct_st_29b574a6() throws {
        let source = #"""
language core;
extend with #type-reconstruction, #unit-type;
extend with #let-bindings;


fn main(n : auto) -> auto {
  return (let x = ((fn (a : auto) { return ((succ(a))) } )) in ((x))((0)))
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/parenthesis_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            #expect(error.code == "ERROR_AMBIGUOUS_TYPE")
        }
    }

    @Test("ok/record_apply_to_function.st")
    func test_ok_record_apply_to_function_st_0f4484bf() throws {
        let source = #"""
language core;
extend with #records;

fn foo(x : { fst : Nat, snd : Bool, thd : Bool }) -> Nat {
  return x.fst
}

fn main(n : Nat) -> Nat {
  return foo({ fst = 0, snd = true, thd = true })
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/record_apply_to_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/record_diff_order.st")
    func test_ok_record_diff_order_st_450aab3b() throws {
        let source = #"""
language core;

extend with #records;


fn main(succeed : Nat) -> { b : Nat, a : Bool } {
  return { a = true, b = 0 }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/record_diff_order.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/record_in_abstraction.st")
    func test_ok_record_in_abstraction_st_2d2f73f2() throws {
        let source = #"""
language core;
extend with #records;

fn foo(n : Nat) -> (fn(Nat) -> { current : Nat, next : Nat }) {
  return fn(i : Nat) {
    return { current = i, next = succ(n) }
  }
}

fn main(n : Nat) -> Nat {
  return foo(0)(succ(0)).next
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/record_in_abstraction.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/record_in_record.st")
    func test_ok_record_in_record_st_fad81fbb() throws {
        let source = #"""
language core;
extend with #records;

fn foo(n : Nat) -> { i : Nat, inner : {x : Bool, y : Nat} } {
  return { i = 0, inner = { x = true, y = succ(0) }}
}

fn main(n : Nat) -> Nat {
  return foo(0).inner.y
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/record_in_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/reference_from_task.st")
    func test_ok_reference_from_task_st_fa66107b() throws {
        let source = #"""
language core;
extend with #unit-type, #references, #let-bindings, #sequencing;
fn inc_ref(ref : &Nat) -> Unit {
  return
    ref := succ(*ref)
}
fn inc3(ref : &Nat) -> Nat {
  return
    inc_ref(ref);
    inc_ref(ref);
    inc_ref(ref);
    *ref
}
fn main(n : Nat) -> Nat {
  return let ref = new(n) in inc3(ref)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/reference_from_task.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/return_deref_ref.st")
    func test_ok_return_deref_ref_st_9dd21d47() throws {
        let source = #"""
language core;
extend with #references;

fn foo(n : Nat) -> Nat { return 0 }

fn main(n : Nat) -> Nat {
	return *(new (foo(0)))
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/return_deref_ref.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/self_app.st")
    func test_ok_self_app_st_1bd962da() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn self_app[X](f : forall X . fn(X) -> X) -> forall X . fn(X) -> X {
  return f[forall X . fn(X) -> X](f)
}

fn main(x : Nat) -> Nat {
  return 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/self_app.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/semicolon.st")
    func test_ok_semicolon_st_a7559897() throws {
        let source = #"""
language core;

fn main(a : Nat) -> Nat {
return 0;
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/semicolon.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/sequencing_basic.st")
    func test_ok_sequencing_basic_st_c6255033() throws {
        let source = #"""
language core;
extend with #sequencing, #unit-type;

fn main(n : Nat) -> Nat {
	return (fn(a : Nat) { return unit }) (0); 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/sequencing_basic.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/simple_ascription.st")
    func test_ok_simple_ascription_st_c65bac34() throws {
        let source = #"""
language core;
extend with #type-ascriptions;


fn main(n : Nat) -> Nat {
  return 0 as Nat
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/simple_ascription.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/simple_ascription_reconstruct.st")
    func test_ok_simple_ascription_reconstruct_st_dc977b98() throws {
        let source = #"""
language core;
extend with #type-reconstruction, #type-ascriptions;


fn main(n : Nat) -> Nat {
  return 0 as Nat
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/simple_ascription_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/simple_inl_reconstruct.st")
    func test_ok_simple_inl_reconstruct_st_25f45b38() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;

fn main(n : Nat) -> Nat + Nat {
  return (fn (a : Nat) { return inl(0) }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/simple_inl_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/simple_inr_reconstruct.st")
    func test_ok_simple_inr_reconstruct_st_03bcc038() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;

fn main(n : Nat) -> Nat + Nat {
  return (fn (a : Nat) { return inr(0) }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/simple_inr_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/simple_letrec.st")
    func test_ok_simple_letrec_st_03313c9f() throws {
        let source = #"""
language core;

extend with  #letrec-bindings, #let-patterns, #pattern-ascriptions;

fn foo(n : Nat) -> Nat {
	return n
}

fn main(n : Nat) -> Nat {
    return letrec (x as Nat) = 0 in x
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/simple_letrec.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/simple_pair.st")
    func test_ok_simple_pair_st_80d59339() throws {
        let source = #"""
language core;
extend with #pairs;

fn main(n : Nat) -> {Nat, Nat} {
  return {succ(n), {succ(succ(n)), n}}.2
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/simple_pair.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/simple_records.st")
    func test_ok_simple_records_st_72bc3de7() throws {
        let source = #"""
language core;
extend with #records;

fn iterate(n : Nat) -> { current : Nat, next : Nat } {
  return { current = n, next = succ(n) }
}

fn main(n : Nat) -> Nat {
  return iterate(0).next
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/simple_records.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/simple_sum.st")
    func test_ok_simple_sum_st_0ce121ea() throws {
        let source = #"""
language core;

extend with #sum-types, #unit-type;

fn test(first : Bool) -> Nat + Unit {
  return if first then inl(succ(0)) else inr(unit)
}

fn main(input : Bool) -> Nat {
  return match test(input) {
      inl(n) => n
    | inr(_) => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/simple_sum.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/simple_sum_reconstruct.st")
    func test_ok_simple_sum_reconstruct_st_a7c6179f() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types, #unit-type;

fn test(first : auto) -> auto {
  return if first then inl(succ(0)) else inr(unit)
}

fn main(input : auto) -> auto {
  return match test(input) {
      inl(n) => n
    | inr(_) => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/simple_sum_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/simple_tuple.st")
    func test_ok_simple_tuple_st_8381d5eb() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> {Nat, Nat, Bool} {
  return {n, succ(n), true}
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/simple_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/simple_unit.st")
    func test_ok_simple_unit_st_8319b17c() throws {
        let source = #"""
language core;
extend with #unit-type;

fn main(_ : Nat) -> Unit {
    return unit
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/simple_unit.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/square_reconstruct.st")
    func test_ok_square_reconstruct_st_d3b29fc5() throws {
        let source = #"""
language core;

extend with #type-reconstruction;


fn Nat::add(n : auto) -> auto {
  return fn(m : auto) {
    return Nat::rec(n, m, fn(i : auto) {
      return fn(r : auto) {
        return succ( r );
      };
    });
  };
}


fn square(n : auto) -> auto {
  return Nat::rec(n, 0, fn(i : auto) {
      return fn(r : auto) {

        return Nat::add(i)( Nat::add(i)( succ( r )));
      };
  });
}

fn main(n : auto) -> auto {
  return square(n);
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/square_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_bool.st")
    func test_ok_subtyping_bool_st_b6aa3d7e() throws {
        let source = #"""
language core;

extend with #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> Top {
  return true
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_bool.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_error.st")
    func test_ok_subtyping_error_st_1f1bd4be() throws {
        let source = #"""
language core;

extend with #exceptions,
            #exception-type-declaration,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

exception type = Top

fn main(n : Nat) -> Top {
  return throw(true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_error.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_func.st")
    func test_ok_subtyping_func_st_499d4ed6() throws {
        let source = #"""
language core;

extend with #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(b : Bool) -> (fn(Bool) -> Bool) {
    return fn(x : Top) {
        return false
    }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_func.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_func2.st")
    func test_ok_subtyping_func2_st_bb0f65d6() throws {
        let source = #"""
language core;

extend with #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(b : Bool) -> (fn(Bool) -> Top) {
    return fn(x : Top) {
        return false
    }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_func2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_func3.st")
    func test_ok_subtyping_func3_st_a30daad2() throws {
        let source = #"""
language core;

extend with #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(b : Bool) -> (fn(Bool) -> Top) {
    return fn(x : Bool) {
        return false
    }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_func3.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_list.st")
    func test_ok_subtyping_list_st_7f54c665() throws {
        let source = #"""
language core;

extend with #lists,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> [Top] {
  return cons(0, (cons(0, [])))
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_list.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_list2.st")
    func test_ok_subtyping_list2_st_1d5eb306() throws {
        let source = #"""
language core;

extend with #lists,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> Top {
  return cons(0, (cons(0, [])))
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_list2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_nat.st")
    func test_ok_subtyping_nat_st_e7416827() throws {
        let source = #"""
language core;

extend with #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> Top {
  return n
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_nat.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_record.st")
    func test_ok_subtyping_record_st_3477eba8() throws {
        let source = #"""
language core;

extend with #records,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn iterate(n : Nat) -> { current : Nat, next : Nat } {
  return { current = n, next = succ(n) }
}

fn main(n : Nat) -> { current : Nat } {
  return iterate(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_record2.st")
    func test_ok_subtyping_record2_st_bda11621() throws {
        let source = #"""
language core;

extend with #records,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn iterate(n : Nat) -> { current : Nat, next : Nat } {
  return { current = n, next = succ(n) }
}

fn main(n : Nat) -> Top {
  return iterate(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_record2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_ref.st")
    func test_ok_subtyping_ref_st_967ef37e() throws {
        let source = #"""
language core;

extend with #references,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> &Top {
  return new(12)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_ref.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_ref2.st")
    func test_ok_subtyping_ref2_st_0a451bb8() throws {
        let source = #"""
language core;

extend with #references,
            #variants,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> &<| a : Nat, b : Bool |> {
  return new(<| a = 1 |>)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_ref2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_ref3.st")
    func test_ok_subtyping_ref3_st_9bf06159() throws {
        let source = #"""
language core;

extend with #references,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> Top {
  return new(12)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_ref3.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_sum.st")
    func test_ok_subtyping_sum_st_3e3cd10d() throws {
        let source = #"""
language core;

extend with #sum-types,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> Top + Bool {
  return inl(12)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_sum.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_sum2.st")
    func test_ok_subtyping_sum2_st_6caf43ba() throws {
        let source = #"""
language core;

extend with #sum-types,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn fail(n : Nat) -> Top + Bool {
	return inl(1)
}

fn main(n : Nat) -> Top {
  return fail(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_sum2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_top.st")
    func test_ok_subtyping_top_st_4e4a2bf3() throws {
        let source = #"""
language core;

extend with #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> Top {
  return 123
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_top.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_top2.st")
    func test_ok_subtyping_top2_st_e7bdc38c() throws {
        let source = #"""
language core;

extend with #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> Top {
  return true
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_top2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_tuple.st")
    func test_ok_subtyping_tuple_st_95d236e0() throws {
        let source = #"""
language core;

extend with #tuples,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> {Top, Bool} {
  return {1, true}
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_tuple2.st")
    func test_ok_subtyping_tuple2_st_061a07d9() throws {
        let source = #"""
language core;

extend with #tuples,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> {Top, Bool} {
  return {1, true}
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_tuple2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_unit.st")
    func test_ok_subtyping_unit_st_624cc9c1() throws {
        let source = #"""
language core;

extend with #unit-type,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> Top {
  return unit
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_unit.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_variant2.st")
    func test_ok_subtyping_variant2_st_21dba2cb() throws {
        let source = #"""
language core;

extend with #variants,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> <| value : Nat, failure : Top |> {
  return <| failure = true |>
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_variant2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_variant3.st")
    func test_ok_subtyping_variant3_st_412fb29e() throws {
        let source = #"""
language core;

extend with #variants,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn fail(n : Nat) -> <| failure : Top, value : Nat |> {
	return <| failure = 1 |>
}

fn main(n : Nat) -> Top {
  return fail(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_variant3.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/subtyping_variants.st")
    func test_ok_subtyping_variants_st_bd18f72f() throws {
        let source = #"""
language core;

extend with #variants,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn fail(n : Nat) -> <| failure : Top, value : Nat |> {
	return <| failure = 1 |>
}

fn main(n : Nat) -> <| value : Nat, failure : Top, value2 : Bool |> {
  return fail(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/subtyping_variants.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/sum_arg.st")
    func test_ok_sum_arg_st_0a90a72d() throws {
        let source = #"""
language core;

extend with #sum-types, #unit-type;

fn test(first : Nat + Bool) -> Nat {
  return match first {
      inl(n) => n
    | inr(_) => 0
  }
}

fn main(input : Bool) -> Nat {
  return test(inl(0))
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/sum_arg.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/sum_arg_reconstruct.st")
    func test_ok_sum_arg_reconstruct_st_40274d40() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types, #unit-type;

fn test(first : auto) -> auto {
  return match first {
      inl(n) => n
    | inr(_) => 0
  }
}

fn main(input : auto) -> auto {
  return test(inl(0))
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/sum_arg_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            #expect(error.code == "ERROR_AMBIGUOUS_TYPE")
        }
    }

    @Test("ok/throw.st")
    func test_ok_throw_st_b986321a() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals, #exception-type-declaration;

exception type = Nat

fn main(n : Nat) -> Nat {
  return throw(1)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/throw.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/try_cast_as.st")
    func test_ok_try_cast_as_st_7ef750c4() throws {
        let source = #"""
language core;

extend with #try-cast-as, #structural-patterns, #natural-literals;

fn main(n : Nat) -> Nat {
  return try { true } cast as Nat
    { 1 => 12 }
    with
    { 0 }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/try_cast_as.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/try_catch.st")
    func test_ok_try_catch_st_5916eccc() throws {
        let source = #"""
language core;
extend with #exceptions, #exception-type-declaration;
exception type = Nat

fn fail(n : Nat) -> Bool {
	return throw(succ(0))
}

fn main(n : Nat) -> Bool {
	return try { fail(n) } catch { a => true }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/try_catch.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/try_catch_no_error.st")
    func test_ok_try_catch_no_error_st_3a4dada0() throws {
        let source = #"""
language core;
extend with #exceptions, #exception-type-declaration, #structural-patterns;
exception type = Nat

fn main(n : Nat) -> Bool {
	return try { true } catch { 0 => true }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/try_catch_no_error.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/try_catch_unepected_pattern_2.st")
    func test_ok_try_catch_unepected_pattern_2_st_57654a29() throws {
        let source = #"""
language core;
extend with #exceptions, #exception-type-declaration;
exception type = Nat

fn fail(n : Nat) -> Bool {
	return throw(succ(0))
}

fn main(n : Nat) -> Bool {
	return try { fail(n) } catch { x => true }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/try_catch_unepected_pattern_2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/try_catch_variant.st")
    func test_ok_try_catch_variant_st_a4c512b9() throws {
        let source = #"""
language core;
extend with #exceptions, #exception-type-declaration, #variants, #structural-patterns, #open-variant-exceptions;

exception variant bool : Bool
exception variant nat : Nat

fn fail(n : Nat) -> Bool {
	return throw(<| bool = true |>)
}

fn main(n : Nat) -> Bool {
	return try { true } catch { <| bool = true |> => true }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/try_catch_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/try_catch_variant2.st")
    func test_ok_try_catch_variant2_st_39ad5e54() throws {
        let source = #"""
language core;
extend with #exceptions, #exception-type-declaration, #variants, #structural-patterns, #open-variant-exceptions;

exception variant bool : Bool
exception variant nat : Nat

fn fail(n : Nat) -> Bool {
	return throw(<| bool = true |>)
}

fn main(n : Nat) -> Bool {
	return try { true } catch { <| nat = 1 |> => true }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/try_catch_variant2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/try_catch_with_structural_pattern.st")
    func test_ok_try_catch_with_structural_pattern_st_64d234e6() throws {
        let source = #"""
language core;
extend with #exceptions, #exception-type-declaration, #structural-patterns;
exception type = Nat

fn fail(n : Nat) -> Bool {
	return throw(succ(0))
}

fn main(n : Nat) -> Bool {
	return try { fail(n) } catch { 2 => true }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/try_catch_with_structural_pattern.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/try_with.st")
    func test_ok_try_with_st_b012368c() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals, #exception-type-declaration;

exception type = Nat

fn main(n : Nat) -> Nat {
  return try { 1 } with { 1 }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/try_with.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/try_with_try_and_with_throws.st")
    func test_ok_try_with_try_and_with_throws_st_2d780b24() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals, #exception-type-declaration;

exception type = Nat

fn main(n : Nat) -> Nat {
  return try { throw(1) } with { throw(0) }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/try_with_try_and_with_throws.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/try_with_try_throws.st")
    func test_ok_try_with_try_throws_st_fe1fb06a() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals, #exception-type-declaration;

exception type = Nat

fn main(n : Nat) -> Nat {
  return try { throw(1) } with { 1 }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/try_with_try_throws.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/twice_bool_not.st")
    func test_ok_twice_bool_not_st_2e964be6() throws {
        let source = #"""
language core;

fn Bool::not(b : Bool) -> Bool {
    return
        if b then false else true
}

fn twice(f : fn(Bool) -> Bool) -> (fn(Bool) -> Bool) {
    return fn(x : Bool) {
        return f(f(x))
    }
}

fn main(b : Bool) -> Bool {
    return twice(Bool::not)(b)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/twice_bool_not.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/twice_bool_not_reconstruct.st")
    func test_ok_twice_bool_not_reconstruct_st_2539df54() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn Bool::not(b : auto) -> auto {
    return
        if b then false else true
}

fn twice(f : fn(auto) -> auto) -> auto {
    return fn(x : auto) {
        return f(f(x))
    }
}

fn main(b : auto) -> auto {
    return twice(Bool::not)(b)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/twice_bool_not_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/type_cast_from_task.st")
    func test_ok_type_cast_from_task_st_fb2a361e() throws {
        let source = #"""
language core;
extend with #type-cast, #pairs, #top-type, #structural-subtyping;
fn dup(x : Top) -> { Top, Top } {
  return { x, x }
}
fn main(n : Nat) -> Nat {
  return (dup(n) cast as {Nat, Nat}).1
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/type_cast_from_task.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/variant_asc.st")
    func test_ok_variant_asc_st_fe2192ef() throws {
        let source = #"""
language core;

extend with #variants, #type-ascriptions;

fn main(succeed : Bool) -> Nat {
  return match (<| a = succ(0) |>) as <| a : Nat, b : Bool |> {
        <| a = t |> => t
        | <| b = t |> => 0
    }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/variant_asc.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("ok/variant_attempt.st")
    func test_ok_variant_attempt_st_85553fd5() throws {
        let source = #"""
language core;

extend with #variants, #unit-type;

fn attempt(get_one? : Bool) -> <| value : Nat, failure : Unit |> {
  return
    if get_one?
      then <| value = 0 |>
      else <| failure = unit |>
}

fn main(succeed : Bool) -> Nat {
  return match attempt(succeed) {
      <| value = n |> => succ(n)
    | <| failure = f |> => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ok/variant_attempt.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }
}
