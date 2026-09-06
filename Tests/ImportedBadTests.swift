import Testing
@testable import StellaSemanticAnalyzer

@Suite("Imported bad tests")
@MainActor
struct ImportedBadTests {
    @Test("bad/ERROR_AMBIGUOUS_LIST_TYPE/head.st")
    func test_bad_ERROR_AMBIGUOUS_LIST_TYPE_head_st_5a82b7a5() throws {
        let source = #"""
language core;

extend with #lists ;

fn main(n : Nat) -> Nat {
  return List::head([])(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_LIST_TYPE/head.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_LIST_TYPE")
        }
    }

    @Test("bad/ERROR_AMBIGUOUS_LIST_TYPE/infer_match.st")
    func test_bad_ERROR_AMBIGUOUS_LIST_TYPE_infer_match_st_617f5390() throws {
        let source = #"""
language core;

extend with #lists ;

fn main(n : Nat) -> Nat {
  return (fn (a : Nat) { return match(0) {
    x => []
    | y => y
		}
  }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_LIST_TYPE/infer_match.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_LIST_TYPE")
        }
    }

    @Test("bad/ERROR_AMBIGUOUS_LIST_TYPE/let.st")
    func test_bad_ERROR_AMBIGUOUS_LIST_TYPE_let_st_fbd49d26() throws {
        let source = #"""
language core;

extend with #lists ;
extend with #let-bindings;

fn main(n : Nat) -> Nat {
  return let x = [] in x
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_LIST_TYPE/let.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_LIST_TYPE")
        }
    }

    @Test("bad/ERROR_AMBIGUOUS_PANIC_TYPE/panic_inside_lambda.st")
    func test_bad_ERROR_AMBIGUOUS_PANIC_TYPE_panic_inside_lambda_st_fdf49cd7() throws {
        let source = #"""
language core;
extend with #panic;

fn main(n : Nat) -> Nat {
  return (fn(x : Nat) {
    	return panic!
  }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_PANIC_TYPE/panic_inside_lambda.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_PANIC_TYPE")
        }
    }

    @Test("bad/ERROR_AMBIGUOUS_PANIC_TYPE/panic_or_function.st")
    func test_bad_ERROR_AMBIGUOUS_PANIC_TYPE_panic_or_function_st_6e457586() throws {
        let source = #"""
language core;
extend with #panic;

fn main(n : Nat) -> Nat {
  return (if false then panic! else fn (x : Nat) { return x }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_PANIC_TYPE/panic_or_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_PANIC_TYPE")
        }
    }

    @Test("bad/ERROR_AMBIGUOUS_PATTERN_TYPE/simple_letrec.st")
    func test_bad_ERROR_AMBIGUOUS_PATTERN_TYPE_simple_letrec_st_05bcfcde() throws {
        let source = #"""
language core;

extend with  #letrec-bindings;

fn foo(n : Nat) -> Nat {
	return n
}

fn main(n : Nat) -> Nat {
    return letrec x = 0 in x
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_PATTERN_TYPE/simple_letrec.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_PATTERN_TYPE")
        }
    }

    @Test("bad/ERROR_AMBIGUOUS_REFERENCE_TYPE/deref_memory_from_lambda.st")
    func test_bad_ERROR_AMBIGUOUS_REFERENCE_TYPE_deref_memory_from_lambda_st_d3c4e757() throws {
        let source = #"""
language core;
extend with #references, #type-ascriptions;

fn main(n : Nat) -> Nat {
	return *((fn (_ : Nat) {
    	return <0x01>
    }) (0))
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_REFERENCE_TYPE/deref_memory_from_lambda.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_REFERENCE_TYPE")
        }
    }

    @Test("bad/ERROR_AMBIGUOUS_SUM_TYPE/simple_inl.st")
    func test_bad_ERROR_AMBIGUOUS_SUM_TYPE_simple_inl_st_3ab207af() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(n : Nat) -> Nat + Nat {
  return (fn (a : Nat) { return inl(0) }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_SUM_TYPE/simple_inl.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_SUM_TYPE")
        }
    }

    @Test("bad/ERROR_AMBIGUOUS_SUM_TYPE/simple_inr.st")
    func test_bad_ERROR_AMBIGUOUS_SUM_TYPE_simple_inr_st_7ec1d355() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(n : Nat) -> Nat + Nat {
  return (fn (a : Nat) { return inr(0) }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_SUM_TYPE/simple_inr.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_SUM_TYPE")
        }
    }

    @Test("bad/ERROR_AMBIGUOUS_THROW_TYPE/throw_inside_lambda.st")
    func test_bad_ERROR_AMBIGUOUS_THROW_TYPE_throw_inside_lambda_st_59f3b742() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals, #exception-type-declaration;

exception type = Nat

fn main(n : Nat) -> Nat {
    return (fn(x : Nat) {
        return throw(1)
    }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_THROW_TYPE/throw_inside_lambda.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_THROW_TYPE")
        }
    }

    @Test("bad/ERROR_AMBIGUOUS_THROW_TYPE/throw_or_function.st")
    func test_bad_ERROR_AMBIGUOUS_THROW_TYPE_throw_or_function_st_6867c1c8() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals, #exception-type-declaration;

exception type = Nat
fn main(n : Nat) -> Nat {
  return (if false then throw(1) else fn (x : Nat) { return x }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_THROW_TYPE/throw_or_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_THROW_TYPE")
        }
    }

    @Test("bad/ERROR_AMBIGUOUS_VARIANT_TYPE/ambiguous-variant-type-1.stella")
    func test_bad_ERROR_AMBIGUOUS_VARIANT_TYPE_ambiguous_variant_type_1_stella_d06fffaf() throws {
        let source = #"""
language core;

extend with #variants;
extend with #type-ascriptions;

fn main(n : Nat) -> fn(Bool) -> Nat {
  return (fn (b : Bool) { return  <| value = n |>  })(true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_VARIANT_TYPE/ambiguous-variant-type-1.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_VARIANT_TYPE")
        }
    }

    @Test("bad/ERROR_AMBIGUOUS_VARIANT_TYPE/ambiguous-variant-type-2.stella")
    func test_bad_ERROR_AMBIGUOUS_VARIANT_TYPE_ambiguous_variant_type_2_stella_ffca8b13() throws {
        let source = #"""
language core;

extend with #variants;
extend with #type-ascriptions;
extend with #pairs;

fn main(n : Nat) -> Nat {
  return {<| value = n |>, 0}.2
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_VARIANT_TYPE/ambiguous-variant-type-2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_VARIANT_TYPE")
        }
    }

    @Test("bad/ERROR_AMBIGUOUS_VARIANT_TYPE/ambiguous-variant-type-3.stella")
    func test_bad_ERROR_AMBIGUOUS_VARIANT_TYPE_ambiguous_variant_type_3_stella_d38b09cc() throws {
        let source = #"""
language core;
extend with #variants;
extend with #type-ascriptions;

fn g(x : <| number : Nat, boolean : Bool, function : fn(Nat) -> Nat |>) -> Nat {
  return match  <| value = n |> {
      <| number   = n |> => succ(n)
    | <| boolean  = b |> => if b then succ(0) else 0
    | <| function = f |> => f(f(succ(0)))
  }
}

fn main(x : Nat) -> Nat {
  return g(<| function = fn(n : Nat) {
      return g(<| number = n |>
        as <| number : Nat, boolean : Bool, function : fn(Nat) -> Nat |>) }
  |> as <| number : Nat, boolean : Bool, function : fn(Nat) -> Nat |>)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_VARIANT_TYPE/ambiguous-variant-type-3.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_VARIANT_TYPE")
        }
    }

    @Test("bad/ERROR_AMBIGUOUS_VARIANT_TYPE/simple.st")
    func test_bad_ERROR_AMBIGUOUS_VARIANT_TYPE_simple_st_40f35729() throws {
        let source = #"""
language core;

extend with #letrec-bindings, #let-patterns, #pattern-ascriptions, #variants;

fn main(n : Nat) -> <| a : Nat, b : Bool |> {
   return (fn ( a : Nat) { return
    if true
      then <| a = 0 |>
      else <| b = true |>
     }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_AMBIGUOUS_VARIANT_TYPE/simple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_VARIANT_TYPE")
        }
    }

    @Test("bad/ERROR_EXCEPTION_TYPE_NOT_DECLARED/not_declared.st")
    func test_bad_ERROR_EXCEPTION_TYPE_NOT_DECLARED_not_declared_st_8025dac5() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals;

fn main(n : Nat) -> Nat {
  return try { throw(1) } with { 1 }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_EXCEPTION_TYPE_NOT_DECLARED/not_declared.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_EXCEPTION_TYPE_NOT_DECLARED")
        }
    }

    @Test("bad/ERROR_ILLEGAL_EMPTY_MATCHING/empty_match.st")
    func test_bad_ERROR_ILLEGAL_EMPTY_MATCHING_empty_match_st_847262f9() throws {
        let source = #"""
language core;

extend with #sum-types, #unit-type;

fn test(first : Bool) -> Nat + Unit {
  return if first then inl(succ(0)) else inr(unit)
}

fn main(input : Bool) -> Nat {
  return match test(input) {
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_ILLEGAL_EMPTY_MATCHING/empty_match.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_ILLEGAL_EMPTY_MATCHING")
        }
    }

    @Test("bad/ERROR_ILLEGAL_EMPTY_MATCHING/empty_match_reconstruct.st")
    func test_bad_ERROR_ILLEGAL_EMPTY_MATCHING_empty_match_reconstruct_st_268e7957() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types, #unit-type;

fn test(first : auto) -> auto {
  return if first 
then inl(succ(0)) 
else unit
}

fn main(input : auto) -> Nat {
  return 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_ILLEGAL_EMPTY_MATCHING/empty_match_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_INCORRECT_ARITY_OF_MAIN/main_with_two_params.st")
    func test_bad_ERROR_INCORRECT_ARITY_OF_MAIN_main_with_two_params_st_f6e75571() throws {
        let source = #"""
language core;

extend with #multiparameter-functions;

fn main(n : Nat, z : Nat) -> Nat {
    return z
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_INCORRECT_ARITY_OF_MAIN/main_with_two_params.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_ARITY_OF_MAIN")
        }
    }

    @Test("bad/ERROR_INCORRECT_ARITY_OF_MAIN/main_with_zero_param.st")
    func test_bad_ERROR_INCORRECT_ARITY_OF_MAIN_main_with_zero_param_st_8f01824f() throws {
        let source = #"""
language core;

extend with #nullary-functions;

fn main() -> Nat {
    return 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_INCORRECT_ARITY_OF_MAIN/main_with_zero_param.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_ARITY_OF_MAIN")
        }
    }

    @Test("bad/ERROR_INCORRECT_NUMBER_OF_ARGUMENTS/incorrect_num.st")
    func test_bad_ERROR_INCORRECT_NUMBER_OF_ARGUMENTS_incorrect_num_st_839c3be4() throws {
        let source = #"""
language core;

extend with #multiparameter-functions;

fn main(n : Nat) -> Nat {
    return (fn(a : Nat, b : Nat) {
    	return 0
    })(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_INCORRECT_NUMBER_OF_ARGUMENTS/incorrect_num.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_NUMBER_OF_ARGUMENTS")
        }
    }

    @Test("bad/ERROR_INCORRECT_NUMBER_OF_ARGUMENTS/infer_fix_multiple_param.st")
    func test_bad_ERROR_INCORRECT_NUMBER_OF_ARGUMENTS_infer_fix_multiple_param_st_bd997c0b() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator, #multiparameter-functions;

fn foo(a : Nat, b : Nat) -> Bool {
  return true
}

fn main(n : Nat) -> Nat {
  return (fn (a : Nat) { return fix(foo); } ) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_INCORRECT_NUMBER_OF_ARGUMENTS/infer_fix_multiple_param.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_NUMBER_OF_ARGUMENTS")
        }
    }

    @Test("bad/ERROR_INCORRECT_NUMBER_OF_ARGUMENTS/infer_fix_zero_param.st")
    func test_bad_ERROR_INCORRECT_NUMBER_OF_ARGUMENTS_infer_fix_zero_param_st_ecbcf387() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator, #nullary-functions;

fn foo() -> Bool {
  return true
}

fn main(n : Nat) -> Nat {
  return (fn (a : Nat) { return fix(foo); } ) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_INCORRECT_NUMBER_OF_ARGUMENTS/infer_fix_zero_param.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_NUMBER_OF_ARGUMENTS")
        }
    }

    @Test("bad/ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS/const_few_vars.st")
    func test_bad_ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS_const_few_vars_st_9f0265ec() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn const[X, Y](x : X) -> fn(Y) -> X {
  return fn(y : Y) {
    return x
  }
}

fn main(x : Nat) -> Nat {
  return const[Nat](x)(false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS/const_few_vars.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS")
        }
    }

    @Test("bad/ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS/const_many_vars.st")
    func test_bad_ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS_const_many_vars_st_180451f2() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn const[X, Y](x : X) -> fn(Y) -> X {
  return fn(y : Y) {
    return x
  }
}

fn main(x : Nat) -> Nat {
  return const[Nat, Bool, Bool](x)(false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS/const_many_vars.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS")
        }
    }

    @Test("bad/ERROR_MISSING_DATA_FOR_LABEL/simple.st")
    func test_bad_ERROR_MISSING_DATA_FOR_LABEL_simple_st_cd757ba0() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #variants, #nullary-variant-labels;

fn main(n : Nat) -> <| a : Nat, b, c |> {
  return <| a |>
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_MISSING_DATA_FOR_LABEL/simple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_DATA_FOR_LABEL")
        }
    }

    @Test("bad/ERROR_MISSING_MAIN/no_main.st")
    func test_bad_ERROR_MISSING_MAIN_no_main_st_9108cf9a() throws {
        let source = #"""
language core;

fn increment_twice(n : Nat) -> Nat {
  return succ(succ(n))
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_MISSING_MAIN/no_main.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_MAIN")
        }
    }

    @Test("bad/ERROR_MISSING_RECORD_FIELDS/call_function_with_missing_fields.st")
    func test_bad_ERROR_MISSING_RECORD_FIELDS_call_function_with_missing_fields_st_7b2bea8c() throws {
        let source = #"""
language core;
extend with #records;

fn foo(x : { fst : Nat, snd : Bool, thd : Bool }) -> Nat {
  return x.fst
}

fn main(n : Nat) -> Nat {
  return foo({ fst = 0, snd = true })
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_MISSING_RECORD_FIELDS/call_function_with_missing_fields.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_RECORD_FIELDS")
        }
    }

    @Test("bad/ERROR_MISSING_RECORD_FIELDS/record_in_abstraction.st")
    func test_bad_ERROR_MISSING_RECORD_FIELDS_record_in_abstraction_st_00b09aec() throws {
        let source = #"""
language core;
extend with #records;

fn foo(n : Nat) -> (fn(Nat) -> { current : Nat, next : Nat }) {
  return fn(i : Nat) {
    return { next = succ(n) }
  }
}

fn main(n : Nat) -> Nat {
  return foo(0)(succ(0)).next
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_MISSING_RECORD_FIELDS/record_in_abstraction.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_RECORD_FIELDS")
        }
    }

    @Test("bad/ERROR_MISSING_RECORD_FIELDS/record_in_record.st")
    func test_bad_ERROR_MISSING_RECORD_FIELDS_record_in_record_st_95b408c4() throws {
        let source = #"""
language core;
extend with #records;

fn foo(n : Nat) -> { i : Nat, inner : {x : Bool, y : Nat} } {

  return { i = 0, inner = { y = succ(0) }}
}

fn main(n : Nat) -> Nat {
  return foo(0).inner.y
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_MISSING_RECORD_FIELDS/record_in_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_RECORD_FIELDS")
        }
    }

    @Test("bad/ERROR_MISSING_RECORD_FIELDS/simple_missing_fields.st")
    func test_bad_ERROR_MISSING_RECORD_FIELDS_simple_missing_fields_st_46a926d7() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> { fst : Nat, snd : Bool } {
  return { fst = 0 }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_MISSING_RECORD_FIELDS/simple_missing_fields.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_RECORD_FIELDS")
        }
    }

    @Test("bad/ERROR_MISSING_RECORD_FIELDS/subtyping_record.st")
    func test_bad_ERROR_MISSING_RECORD_FIELDS_subtyping_record_st_1065f131() throws {
        let source = #"""
language core;

extend with #records,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn iterate(n : Nat) -> { current : Nat } {
  return { current = n, next = succ(n) }
}

fn main(n : Nat) -> { current : Nat, next : Nat } {
  return iterate(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_MISSING_RECORD_FIELDS/subtyping_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_RECORD_FIELDS")
        }
    }

    @Test("bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_bool.st")
    func test_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_bool_st_73339d11() throws {
        let source = #"""
language core;

extend with #structural-patterns;

fn main(n : Nat) -> Nat {
  return match true {
    	true => 0
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_bool.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_empty_list.st")
    func test_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_empty_list_st_b30fe887() throws {
        let source = #"""
language core;

extend with #structural-patterns, #lists;

fn main(n : [Nat]) -> Nat {
  return match n {
    	[0] => 0
    	| cons (x, cons(a, xs)) => 0
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_empty_list.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_sum.st")
    func test_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_sum_st_15cd7699() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #sum-types;

fn main(n : Nat + Bool) -> Nat {
  return match n {
    	inl(a) => a
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_sum.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_sum_nat.st")
    func test_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_sum_nat_st_2a22187a() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #sum-types;

fn main(n : Nat + Bool) -> Nat {
  return match n {
    	inl(0) => 0
    | inr(b) => 0
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_sum_nat.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_sum_reconstruct.st")
    func test_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_sum_reconstruct_st_8c9fc43f() throws {
        let source = #"""
language core;

extend with #natural-literals, #sum-types, #type-reconstruction;

fn main(n : Nat + Bool) -> auto {
  return match n {
    	inl(a) => a
   }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_sum_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/nonexhaustive_match.st")
    func test_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_nonexhaustive_match_st_276dc7ec() throws {
        let source = #"""
language core;

extend with #sum-types, #unit-type;

fn test(first : Bool) -> Nat + Unit {
  return if first then inl(succ(0)) else inr(unit)
}

fn main(input : Bool) -> Nat {
  return match test(input) {
      inl(n) => n
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/nonexhaustive_match.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/nonexhaustive_match_reconstruct.st")
    func test_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_nonexhaustive_match_reconstruct_st_b9b5a1d0() throws {
        let source = #"""
language core;

extend with #sum-types, #unit-type, #type-reconstruction;

fn test(first : auto) -> auto {
  return if first then inl(succ(0)) else inr(unit)
}

fn main(input : auto) -> auto {
  return match test(input) {
      inl(n) => n
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/nonexhaustive_match_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/nonexhaustive_variant.st")
    func test_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_nonexhaustive_variant_st_fb601b15() throws {
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
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/nonexhaustive_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("bad/ERROR_NOT_A_FUNCTION/apply_record.st")
    func test_bad_ERROR_NOT_A_FUNCTION_apply_record_st_2698b366() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> Nat {
  return {l1 = 0, l2 = false}(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_FUNCTION/apply_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test("bad/ERROR_NOT_A_FUNCTION/apply_tuple.st")
    func test_bad_ERROR_NOT_A_FUNCTION_apply_tuple_st_8052bb3f() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> Nat {
  return {0, false}(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_FUNCTION/apply_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test("bad/ERROR_NOT_A_FUNCTION/before_arg_type_check.st")
    func test_bad_ERROR_NOT_A_FUNCTION_before_arg_type_check_st_9ce66ed9() throws {
        let source = #"""
language core;

fn foo(arg : Nat) -> Nat {
    return 0
}

fn main(n : Nat) -> Nat {
  return n(foo(true))
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_FUNCTION/before_arg_type_check.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test("bad/ERROR_NOT_A_FUNCTION/infer_fix.st")
    func test_bad_ERROR_NOT_A_FUNCTION_infer_fix_st_2f4f5844() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator;

fn foo(a : Nat) -> Nat {
  return 0
}

fn main(n : Nat) -> Nat {
  return (fn (a : Nat) { return fix(0); } ) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_FUNCTION/infer_fix.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test("bad/ERROR_NOT_A_FUNCTION/not_a_f_fix.st")
    func test_bad_ERROR_NOT_A_FUNCTION_not_a_f_fix_st_b22d592d() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator;


fn main(n : Nat) -> Nat {
  return fix(true);
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_FUNCTION/not_a_f_fix.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_NOT_A_FUNCTION/simple_no_function.st")
    func test_bad_ERROR_NOT_A_FUNCTION_simple_no_function_st_3018df82() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return n(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_FUNCTION/simple_no_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test("bad/ERROR_NOT_A_GENERIC_FUNCTION/const2_not_generic.st")
    func test_bad_ERROR_NOT_A_GENERIC_FUNCTION_const2_not_generic_st_8c350292() throws {
        let source = #"""
language core;

extend with #universal-types;

fn const(x : Nat) -> forall Y. fn(Y) -> Nat {
  return generic [Y] fn(y : Y) { return x }
}

fn main(x : Nat) -> Nat {
  return const[Nat](x)[Bool](false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_GENERIC_FUNCTION/const2_not_generic.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_GENERIC_FUNCTION")
        }
    }

    @Test("bad/ERROR_NOT_A_LIST/head.st")
    func test_bad_ERROR_NOT_A_LIST_head_st_3a9d7332() throws {
        let source = #"""
language core;

extend with #lists;

fn main(arg : Nat) -> Nat {
  return (fn (a : Nat) { return List::head(arg) })(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_LIST/head.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_LIST")
        }
    }

    @Test("bad/ERROR_NOT_A_LIST/is_empty.st")
    func test_bad_ERROR_NOT_A_LIST_is_empty_st_1482940c() throws {
        let source = #"""
language core;

extend with #lists;

fn main(arg : Nat) -> Bool {
  return List::isempty(arg)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_LIST/is_empty.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_LIST")
        }
    }

    @Test("bad/ERROR_NOT_A_LIST/tail.st")
    func test_bad_ERROR_NOT_A_LIST_tail_st_14b01ebb() throws {
        let source = #"""
language core;

extend with #lists;

fn main(arg : Nat) -> [Nat] {
  return (fn (a : Nat) { return List::tail(arg) })(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_LIST/tail.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_LIST")
        }
    }

    @Test("bad/ERROR_NOT_A_RECORD/bool_is_not_a_record.st")
    func test_bad_ERROR_NOT_A_RECORD_bool_is_not_a_record_st_d62bed31() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Bool) -> Nat {
  return 0.field
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_RECORD/bool_is_not_a_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_RECORD")
        }
    }

    @Test("bad/ERROR_NOT_A_RECORD/func_is_not_a_record.st")
    func test_bad_ERROR_NOT_A_RECORD_func_is_not_a_record_st_8ba394d0() throws {
        let source = #"""
language core;
extend with #records;

fn main(f : (fn(Nat) -> Bool)) -> Nat {
  return f.field
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_RECORD/func_is_not_a_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_RECORD")
        }
    }

    @Test("bad/ERROR_NOT_A_RECORD/if_is_not_a_record.st")
    func test_bad_ERROR_NOT_A_RECORD_if_is_not_a_record_st_29834b99() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Bool) -> Nat {
  return (if (n) then 0 else succ(0)).field
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_RECORD/if_is_not_a_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_RECORD")
        }
    }

    @Test("bad/ERROR_NOT_A_RECORD/nat_is_not_a_record.st")
    func test_bad_ERROR_NOT_A_RECORD_nat_is_not_a_record_st_5ea901de() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> Nat {
  return 0.fst
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_RECORD/nat_is_not_a_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_RECORD")
        }
    }

    @Test("bad/ERROR_NOT_A_RECORD/unit_is_not_a_record.st")
    func test_bad_ERROR_NOT_A_RECORD_unit_is_not_a_record_st_cb4fcb57() throws {
        let source = #"""
language core;
extend with #records;

fn main(u : Unit) -> Nat {
  return u.field
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_RECORD/unit_is_not_a_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_RECORD")
        }
    }

    @Test("bad/ERROR_NOT_A_REFERENCE/assignment_to_non_ref_parameter.st")
    func test_bad_ERROR_NOT_A_REFERENCE_assignment_to_non_ref_parameter_st_c7df8576() throws {
        let source = #"""
language core;
extend with #references, #sequencing;

fn main(n : Nat) -> Nat {
	return n := 0; n
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_REFERENCE/assignment_to_non_ref_parameter.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_REFERENCE")
        }
    }

    @Test("bad/ERROR_NOT_A_REFERENCE/deref_parameter.st")
    func test_bad_ERROR_NOT_A_REFERENCE_deref_parameter_st_4dca3445() throws {
        let source = #"""
language core;
extend with #references;

fn foo(n : Nat) -> Nat { return *n }

fn main(n : Nat) -> Nat {
	return foo(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_REFERENCE/deref_parameter.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_REFERENCE")
        }
    }

    @Test("bad/ERROR_NOT_A_TUPLE/simple_not_a_tuple.st")
    func test_bad_ERROR_NOT_A_TUPLE_simple_not_a_tuple_st_856be06e() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> Nat {
  return true.1
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_NOT_A_TUPLE/simple_not_a_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_TUPLE")
        }
    }

    @Test("bad/ERROR_OCCURS_CHECK_INFINITE_TYPE/infinite_function_fix_type.st")
    func test_bad_ERROR_OCCURS_CHECK_INFINITE_TYPE_infinite_function_fix_type_st_9471b181() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn main(f : auto) -> auto {
    return fix(f(f))
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_OCCURS_CHECK_INFINITE_TYPE/infinite_function_fix_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_OCCURS_CHECK_INFINITE_TYPE")
        }
    }

    @Test("bad/ERROR_OCCURS_CHECK_INFINITE_TYPE/infinite_function_type.st")
    func test_bad_ERROR_OCCURS_CHECK_INFINITE_TYPE_infinite_function_type_st_476cbe89() throws {
        let source = #"""
language core;
extend with #type-reconstruction;

fn main(f : auto) -> auto {
    return f(f)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_OCCURS_CHECK_INFINITE_TYPE/infinite_function_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_OCCURS_CHECK_INFINITE_TYPE")
        }
    }

    @Test("bad/ERROR_TUPLE_INDEX_OUT_OF_BOUNDS/tuple_from_function.st")
    func test_bad_ERROR_TUPLE_INDEX_OUT_OF_BOUNDS_tuple_from_function_st_204794c6() throws {
        let source = #"""
language core;
extend with #tuples;

fn foo(x : Nat) -> {Nat, Bool, Nat} {
  return {0, true, 0}
}

fn main(n : Nat) -> {Nat, Nat} {
  return foo(n).4
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_TUPLE_INDEX_OUT_OF_BOUNDS/tuple_from_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_TUPLE_INDEX_OUT_OF_BOUNDS")
        }
    }

    @Test("bad/ERROR_TUPLE_INDEX_OUT_OF_BOUNDS/tuple_literal.st")
    func test_bad_ERROR_TUPLE_INDEX_OUT_OF_BOUNDS_tuple_literal_st_d21b396a() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> Nat {
  return {n, succ(n), true}.4
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_TUPLE_INDEX_OUT_OF_BOUNDS/tuple_literal.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_TUPLE_INDEX_OUT_OF_BOUNDS")
        }
    }

    @Test("bad/ERROR_UNDEFINED_TYPE_VARIABLE/const_undefined_var.st")
    func test_bad_ERROR_UNDEFINED_TYPE_VARIABLE_const_undefined_var_st_302462be() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn const[X](x : X) -> fn(Y) -> X {
  return fn(y : Y) {
    return x
  }
}

fn main(x : Nat) -> Nat {
  return const[Nat, Bool](x)(false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNDEFINED_TYPE_VARIABLE/const_undefined_var.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNDEFINED_TYPE_VARIABLE")
        }
    }

    @Test("bad/ERROR_UNDEFINED_VARIABLE/in_let.st")
    func test_bad_ERROR_UNDEFINED_VARIABLE_in_let_st_c134a061() throws {
        let source = #"""
language core;
extend with #let-bindings;


fn main(n : Nat) -> Nat {
  return let y = let x = 0 in x in x
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNDEFINED_VARIABLE/in_let.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNDEFINED_VARIABLE")
        }
    }

    @Test("bad/ERROR_UNDEFINED_VARIABLE/nested_func.st")
    func test_bad_ERROR_UNDEFINED_VARIABLE_nested_func_st_f8477d78() throws {
        let source = #"""
language core;

extend with #type-ascriptions, #nested-function-declarations;

fn main(n : Nat) -> Bool {
  fn foo(a : Nat) -> Bool {
    fn bar(a : Nat) -> Bool {
			return true
		}
		return true
	}
  return bar(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNDEFINED_VARIABLE/nested_func.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNDEFINED_VARIABLE")
        }
    }

    @Test("bad/ERROR_UNDEFINED_VARIABLE/simple_undefined_var.st")
    func test_bad_ERROR_UNDEFINED_VARIABLE_simple_undefined_var_st_6acc7dd8() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
    return a
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNDEFINED_VARIABLE/simple_undefined_var.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNDEFINED_VARIABLE")
        }
    }

    @Test("bad/ERROR_UNDEFINED_VARIABLE/undefined_var_in_other_fun.st")
    func test_bad_ERROR_UNDEFINED_VARIABLE_undefined_var_in_other_fun_st_563a4b6f() throws {
        let source = #"""
language core;

fn foo(a : Nat) -> Nat {
    return 0
}

fn main(n : Nat) -> Nat {
    return a
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNDEFINED_VARIABLE/undefined_var_in_other_fun.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNDEFINED_VARIABLE")
        }
    }

    @Test("bad/ERROR_UNDEFINED_VARIABLE/undefined_var_reconstruct.st")
    func test_bad_ERROR_UNDEFINED_VARIABLE_undefined_var_reconstruct_st_bef3d140() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> auto {
    return foo(n);
}

fn foo(n : auto) -> auto {
		return if n then unk else false;
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNDEFINED_VARIABLE/undefined_var_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNDEFINED_VARIABLE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_DATA_FOR_NULLARY_LABEL/simple.st")
    func test_bad_ERROR_UNEXPECTED_DATA_FOR_NULLARY_LABEL_simple_st_bfbd7a5c() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #variants, #nullary-variant-labels;

fn main(n : Nat) -> <| a : Nat, b, c |> {
  return <| b = true |>
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_DATA_FOR_NULLARY_LABEL/simple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_DATA_FOR_NULLARY_LABEL")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_FIELD_ACCESS/simple_field_access.st")
    func test_bad_ERROR_UNEXPECTED_FIELD_ACCESS_simple_field_access_st_34ce3d83() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> Nat {
  return { fst = 0, snd = true }.thd
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_FIELD_ACCESS/simple_field_access.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_FIELD_ACCESS")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_INJECTION/simple_unexpected_inl.st")
    func test_bad_ERROR_UNEXPECTED_INJECTION_simple_unexpected_inl_st_77bd373e() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(input : Bool) -> Nat {
  return inl(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_INJECTION/simple_unexpected_inl.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_INJECTION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_INJECTION/simple_unexpected_inr.st")
    func test_bad_ERROR_UNEXPECTED_INJECTION_simple_unexpected_inr_st_807cf477() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(input : Bool) -> Nat {
  return inr(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_INJECTION/simple_unexpected_inr.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_INJECTION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_LAMBDA/simple_unexpected_lambda.st")
    func test_bad_ERROR_UNEXPECTED_LAMBDA_simple_unexpected_lambda_st_06399682() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Bool {
    return fn(i : Nat) { return i }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_LAMBDA/simple_unexpected_lambda.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_LAMBDA")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_LIST/cons.st")
    func test_bad_ERROR_UNEXPECTED_LIST_cons_st_6b2eee1e() throws {
        let source = #"""
language core;

extend with #lists;


fn main(n : Nat) -> Nat {
  return  cons(0, []);
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_LIST/cons.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_LIST")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_LIST/infer_match.st")
    func test_bad_ERROR_UNEXPECTED_LIST_infer_match_st_86fd20f1() throws {
        let source = #"""
language core;

extend with #lists ;

fn main(n : Nat) -> Nat {
  return (fn (a : Nat) { return match(0) {
    x => x
    | y => []
		}
  }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_LIST/infer_match.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_LIST")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_LIST/simple.st")
    func test_bad_ERROR_UNEXPECTED_LIST_simple_st_a0de222a() throws {
        let source = #"""
language core;

extend with #lists;

fn main(arg : Nat) -> Nat {
  return [arg, 0]
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_LIST/simple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_LIST")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_MEMORY_ADDRESS/memory_in_if_2.st")
    func test_bad_ERROR_UNEXPECTED_MEMORY_ADDRESS_memory_in_if_2_st_a372d329() throws {
        let source = #"""
language core;
extend with #references, #type-ascriptions;

fn main(n : Nat) -> Nat {
	return if Nat::iszero(n) then <0x01> else <0x02>
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_MEMORY_ADDRESS/memory_in_if_2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_MEMORY_ADDRESS")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_NON_NULLARY_VARIANT_PATTERN/simple.st")
    func test_bad_ERROR_UNEXPECTED_NON_NULLARY_VARIANT_PATTERN_simple_st_a3cd3693() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #variants, #nullary-variant-labels;

fn main(n : <| a : Nat, b, c |>) -> Nat {
  return match n {
      <| b = t |> => 0
      | m => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_NON_NULLARY_VARIANT_PATTERN/simple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_NON_NULLARY_VARIANT_PATTERN")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_NULLARY_VARIANT_PATTERN/simple.st")
    func test_bad_ERROR_UNEXPECTED_NULLARY_VARIANT_PATTERN_simple_st_812926a9() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #variants, #nullary-variant-labels;

fn main(n : <| a : Nat, b, c |>) -> Nat {
  return match n {
      <| a |> => 0
      | m => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_NULLARY_VARIANT_PATTERN/simple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_NULLARY_VARIANT_PATTERN")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_NUMBER_OF_PARAMETERS_IN_LAMBDA/simple_unexpected_number.st")
    func test_bad_ERROR_UNEXPECTED_NUMBER_OF_PARAMETERS_IN_LAMBDA_simple_unexpected_number_st_3d218116() throws {
        let source = #"""
language core;

extend with #multiparameter-functions;

fn main(n : Nat) -> (fn(Nat) -> Nat) {
    return fn(a : Nat, b : Nat) {
    	return 0
    }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_NUMBER_OF_PARAMETERS_IN_LAMBDA/simple_unexpected_number.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_NUMBER_OF_PARAMETERS_IN_LAMBDA")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/bad-sum-types-13.stella")
    func test_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_bad_sum_types_13_stella_f91fcf7c() throws {
        let source = #"""
language core;
extend with #sum-types ;
extend with #pairs ;

fn g(x : Nat + (Bool + (fn(Nat) -> Nat))) -> Nat {
  return match x {
      inl(n) => succ(n)
    | inr(bf) => match {succ(0), 0} {
          inr(f) => f(f(succ(0)))
        | inl(b) => if b then succ(0) else 0
      }
  }
}

fn main(x : Nat) -> Nat {
  return g(inr(inr(fn(n : Nat) { return g(inl(n)) })))
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/bad-sum-types-13.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/let_as.st")
    func test_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_let_as_st_6ae78fb7() throws {
        let source = #"""
language core;

extend with  #let-patterns, #pattern-ascriptions, #let-bindings;

fn foo(n : Nat) -> Nat {
	return n
}

fn main(n : Nat) -> Bool {
    return let ((x as Nat) as Bool) = true in x
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/let_as.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/letrec_asc.st")
    func test_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_letrec_asc_st_28c3e081() throws {
        let source = #"""
language core;

extend with  #let-patterns, #pattern-ascriptions, #let-bindings, #letrec-bindings;

fn foo(n : Nat) -> Nat {
	return n
}

fn main(n : Nat) -> Bool {
    return letrec ((x as Nat) as Bool) = true in x
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/letrec_asc.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/try_cast_as.st")
    func test_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_try_cast_as_st_686bc181() throws {
        let source = #"""
language core;

extend with #try-cast-as, #structural-patterns, #natural-literals;

fn main(n : Nat) -> Nat {
  return try { true } cast as Nat
    { true => 12 }
    with
    { 0 }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/try_cast_as.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/try_catch_unepected_pattern.st")
    func test_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_try_catch_unepected_pattern_st_892c2faf() throws {
        let source = #"""
language core;
extend with #exceptions, #exception-type-declaration, #structural-patterns;
exception type = Nat

fn fail(n : Nat) -> Bool {
	return throw(succ(0))
}

fn main(n : Nat) -> Bool {
	return try { fail(n) } catch { true => true }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/try_catch_unepected_pattern.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/try_catch_variant.st")
    func test_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_try_catch_variant_st_1169f1da() throws {
        let source = #"""
language core;
extend with #exceptions, #exception-type-declaration, #variants, #structural-patterns, #open-variant-exceptions;

exception variant bool : Bool
exception variant nat : Nat

fn fail(n : Nat) -> Bool {
	return throw(<| bool = true |>)
}

fn main(n : Nat) -> Bool {
	return try { true } catch { <| x = 1 |> => true }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/try_catch_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/tuple_size.st")
    func test_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_tuple_size_st_3d679c80() throws {
        let source = #"""
language core;

extend with #tuples, #structural-patterns;

fn foo(a : Nat) -> { Nat, Bool } {
  return { 0, true }
}

fn main(n : Nat) -> Nat {
  return match(foo(0)) {
    {x, y, z} => x
	}
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/tuple_size.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_pattern.st")
    func test_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_unexpected_pattern_st_2dd18954() throws {
        let source = #"""
language core;

extend with #sum-types, #unit-type;

fn test(first : Bool) -> Nat + Unit {
  return if first then inl(succ(0)) else inr(unit)
}

fn main(input : Bool) -> Nat {
  return match input {
      inl(n) => n
    | inr(_) => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_pattern.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_pattern_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_unexpected_pattern_reconstruct_st_999b091d() throws {
        let source = #"""
language core;

extend with #sum-types, #unit-type, #type-reconstruction;

fn test(first : auto) -> auto {
  return if first then inl(succ(0)) else inr(unit)
}

fn main(input : Bool) -> auto {
  return match input {
      inl(n) => n
    | inr(_) => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_pattern_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_variant_pattern.st")
    func test_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_unexpected_variant_pattern_st_8b64c1a4() throws {
        let source = #"""
language core;

extend with #sum-types, #unit-type, #variants;

fn main(input : Bool) -> Nat {
  return match input {
     <| failure = f |>  => n
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_variant_pattern.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_variant_pattern_label.st")
    func test_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_unexpected_variant_pattern_label_st_43bcf92a() throws {
        let source = #"""
language core;

extend with #variants, #unit-type, #sum-types;

fn attempt(get_one? : Bool) -> <| value : Nat, failure : Unit |> {
  return
    if get_one?
      then <| value = 0 |>
      else <| failure = unit |>
}

fn main(succeed : Bool) -> Nat {
  return match attempt(succeed) {
    <| fail = f |> => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_variant_pattern_label.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/variant_asc.st")
    func test_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_variant_asc_st_2ff73d20() throws {
        let source = #"""
language core;

extend with #variants, #type-ascriptions;

fn main(succeed : Bool) -> Nat {
  return match (<| a = succ(0) |>) as <| a : Nat, c : Bool |> {
        <| a = t |> => t
        | <| b = t |> => 0
    }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/variant_asc.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/variant_asc_2.st")
    func test_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_variant_asc_2_st_d00fef1f() throws {
        let source = #"""
language core;

extend with #variants, #type-ascriptions;

fn main(succeed : Bool) -> Nat {
  return match (<| a = succ(0) |>) as <| a : Nat, b : Bool |> {
        <| a = t |> => t
        | <| c = t |> => 0
    }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/variant_asc_2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/variant_unexpected_pattern.st")
    func test_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_variant_unexpected_pattern_st_c0017906() throws {
        let source = #"""
language core;

extend with #variants, #unit-type, #sum-types;

fn attempt(get_one? : Bool) -> <| value : Nat, failure : Unit |> {
  return
    if get_one?
      then <| value = 0 |>
      else <| failure = unit |>
}

fn main(succeed : Bool) -> Nat {
  return match attempt(succeed) {
      inl(n) => succ(n)
    | <| failure = f |> => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/variant_unexpected_pattern.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_RECORD/application_record.st")
    func test_bad_ERROR_UNEXPECTED_RECORD_application_record_st_b446b904() throws {
        let source = #"""
language core;
extend with #records;

fn foo(x : Nat) -> Nat{
   return x
}

fn main(n : Nat) -> Nat {
  return foo ({ a = 0, b = false })
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_RECORD/application_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_RECORD")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_RECORD/simple_unexpected_record.st")
    func test_bad_ERROR_UNEXPECTED_RECORD_simple_unexpected_record_st_a3f2f093() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> Nat {
  return { fst = 0, snd = true }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_RECORD/simple_unexpected_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_RECORD")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_RECORD/succ_record.st")
    func test_bad_ERROR_UNEXPECTED_RECORD_succ_record_st_8b3a380d() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> Nat {
  return succ({ a = 0, b = false })
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_RECORD/succ_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_RECORD")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_RECORD_FIELDS/return_record_with_missing_fields.st")
    func test_bad_ERROR_UNEXPECTED_RECORD_FIELDS_return_record_with_missing_fields_st_be08ee07() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> { fst : Nat, snd : Bool } {
  return { fst = 0, snd = true, thd = true }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_RECORD_FIELDS/return_record_with_missing_fields.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_RECORD_FIELDS")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_REFERENCE/return_ref_from_non_reference_function.st")
    func test_bad_ERROR_UNEXPECTED_REFERENCE_return_ref_from_non_reference_function_st_07c3e94d() throws {
        let source = #"""
language core;
extend with #references;

fn main(n : Nat) -> Bool {
	return new (true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_REFERENCE/return_ref_from_non_reference_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_REFERENCE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_REFERENCE/return_ref_from_non_reference_function_call_func.st")
    func test_bad_ERROR_UNEXPECTED_REFERENCE_return_ref_from_non_reference_function_call_func_st_929ca8a3() throws {
        let source = #"""
language core;
extend with #references;

fn foo(n : Nat) -> Nat { return 0 }

fn main(n : Nat) -> Nat {
	return new (foo(0))
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_REFERENCE/return_ref_from_non_reference_function_call_func.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_REFERENCE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_REFERENCE/return_ref_from_non_reference_function_complex.st")
    func test_bad_ERROR_UNEXPECTED_REFERENCE_return_ref_from_non_reference_function_complex_st_ca0afcb1() throws {
        let source = #"""
language core;
extend with #references;

fn main(n : Nat) -> Nat {
	return new (succ(0))
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_REFERENCE/return_ref_from_non_reference_function_complex.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_REFERENCE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_SUBTYPE/bot.st")
    func test_bad_ERROR_UNEXPECTED_SUBTYPE_bot_st_cecffc15() throws {
        let source = #"""
language core;

extend with #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(b : Bool) -> Bot {
    return 1
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_SUBTYPE/bot.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_SUBTYPE/error.st")
    func test_bad_ERROR_UNEXPECTED_SUBTYPE_error_st_a587cc8d() throws {
        let source = #"""
language core;

extend with #exceptions,
            #exception-type-declaration,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

exception type = Nat

fn main(n : Nat) -> Top {
  return throw(true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_SUBTYPE/error.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_SUBTYPE/func.st")
    func test_bad_ERROR_UNEXPECTED_SUBTYPE_func_st_d824d88c() throws {
        let source = #"""
language core;

extend with #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(b : Bool) -> (fn(Top) -> Top) {
    return fn(x : Bool) {
        return false
    }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_SUBTYPE/func.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_SUBTYPE/func2.st")
    func test_bad_ERROR_UNEXPECTED_SUBTYPE_func2_st_1acfecff() throws {
        let source = #"""
language core;

extend with #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(b : Bool) -> (fn(Bool) -> Bool) {
    return fn(x : Bool) {
        return 12
    }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_SUBTYPE/func2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_SUBTYPE/list.st")
    func test_bad_ERROR_UNEXPECTED_SUBTYPE_list_st_37b0d0bc() throws {
        let source = #"""
language core;

extend with #lists,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> [Bool] {
  return cons(0, (cons(0, [])))
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_SUBTYPE/list.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_SUBTYPE/record.st")
    func test_bad_ERROR_UNEXPECTED_SUBTYPE_record_st_4c8332be() throws {
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

fn main(n : Nat) -> { current : Bool } {
  return iterate(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_SUBTYPE/record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_SUBTYPE/ref.st")
    func test_bad_ERROR_UNEXPECTED_SUBTYPE_ref_st_51bf5d54() throws {
        let source = #"""
language core;

extend with #references,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> &Nat {
  return new(true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_SUBTYPE/ref.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_SUBTYPE/ref2.st")
    func test_bad_ERROR_UNEXPECTED_SUBTYPE_ref2_st_344ea61e() throws {
        let source = #"""
language core;

extend with #references,
            #variants,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> &<| a : Nat, b : Bool |> {
  return new(<| b = 1 |>)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_SUBTYPE/ref2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_SUBTYPE/sum.st")
    func test_bad_ERROR_UNEXPECTED_SUBTYPE_sum_st_4fbb561c() throws {
        let source = #"""
language core;

extend with #sum-types,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> Nat + Bool {
  return inr(12)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_SUBTYPE/sum.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_SUBTYPE/tuple.st")
    func test_bad_ERROR_UNEXPECTED_SUBTYPE_tuple_st_8f1a99d2() throws {
        let source = #"""
language core;

extend with #tuples,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn tuple_gen(n : Nat) -> {Top, Top} {
  return {1, true}
}


fn main(n : Nat) -> {Top, Bool} {
  return tuple_gen(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_SUBTYPE/tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_SUBTYPE/tuple2.st")
    func test_bad_ERROR_UNEXPECTED_SUBTYPE_tuple2_st_dca9e0a9() throws {
        let source = #"""
language core;

extend with #tuples,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn main(n : Nat) -> {Nat, Bool} {
  return {true, 12}
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_SUBTYPE/tuple2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_SUBTYPE/variant.st")
    func test_bad_ERROR_UNEXPECTED_SUBTYPE_variant_st_32190013() throws {
        let source = #"""
language core;

extend with #variants,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn fail(n : Nat) -> <| failure : Nat, value : Nat |> {
	return <| failure = 1 |>
}

fn main(n : Nat) -> <| value : Nat, failure : Bool |> {
  return fail(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_SUBTYPE/variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TUPLE/application_record.st")
    func test_bad_ERROR_UNEXPECTED_TUPLE_application_record_st_7e9ffdbc() throws {
        let source = #"""
language core;
extend with #tuples;

fn foo(x : Nat) -> Nat{
   return x
}

fn main(n : Nat) -> Nat {
  return foo ({0, false})
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TUPLE/application_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TUPLE/return_tuple_from_function.st")
    func test_bad_ERROR_UNEXPECTED_TUPLE_return_tuple_from_function_st_c6bcb94b() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> Nat {
  return {n, succ(n), true}
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TUPLE/return_tuple_from_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TUPLE/succ_record.st")
    func test_bad_ERROR_UNEXPECTED_TUPLE_succ_record_st_795400c6() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> Nat {
  return succ({0, false })
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TUPLE/succ_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TUPLE_LENGTH/functional_type.st")
    func test_bad_ERROR_UNEXPECTED_TUPLE_LENGTH_functional_type_st_51a80fc8() throws {
        let source = #"""
language core;
extend with #tuples;

fn foo(x : Nat) -> (fn(Nat) -> {Nat, Nat}) {
  return fn(i : Nat) {
    return {i, i, i}
  }
}

fn main(n : Nat) -> {Nat, Nat} {
  return foo(n)(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TUPLE_LENGTH/functional_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE_LENGTH")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TUPLE_LENGTH/return_tuple_literal.st")
    func test_bad_ERROR_UNEXPECTED_TUPLE_LENGTH_return_tuple_literal_st_0171654d() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> {Nat, Nat} {
  return {n, succ(n), true}
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TUPLE_LENGTH/return_tuple_literal.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE_LENGTH")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TUPLE_LENGTH/subtyping_tuple.st")
    func test_bad_ERROR_UNEXPECTED_TUPLE_LENGTH_subtyping_tuple_st_12998cf9() throws {
        let source = #"""
language core;

extend with #tuples,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn tuple_gen(n : Nat) -> {Top, Bool, Nat} {
  return {1, true, 12}
}


fn main(n : Nat) -> {Top, Bool} {
  return tuple_gen(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TUPLE_LENGTH/subtyping_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE_LENGTH")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TUPLE_LENGTH/subtyping_tuple2.st")
    func test_bad_ERROR_UNEXPECTED_TUPLE_LENGTH_subtyping_tuple2_st_4e44fc61() throws {
        let source = #"""
language core;

extend with #tuples,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn tuple_gen(n : Nat) -> {Top} {
  return {1}
}


fn main(n : Nat) -> {Top, Bool} {
  return tuple_gen(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TUPLE_LENGTH/subtyping_tuple2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE_LENGTH")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/apply_pair_2_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_apply_pair_2_reconstruct_st_6d9fa92f() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #pairs;

fn main(f : Nat) -> { Nat, auto } {
  return { f, f(0) }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/apply_pair_2_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/apply_pair_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_apply_pair_reconstruct_st_95411b8e() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #pairs;

fn main(n : Nat) -> Nat {
  return {0, false}(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/apply_pair_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/asc.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_asc_st_3ab4cce3() throws {
        let source = #"""
language core;

extend with #type-ascriptions;

fn main(n : Nat) -> Bool {
  return 0 as Nat
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/asc.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/asc_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_asc_reconstruct_st_ae14da54() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #type-ascriptions;

fn main(n : Nat) -> Bool {
  return 0 as Nat
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/asc_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/assignment_ref_ref_wrong_type.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_assignment_ref_ref_wrong_type_st_615aa0d0() throws {
        let source = #"""
language core;
extend with #references, #sequencing;

fn main(n : &&Nat) -> Nat {
	return *n := true; succ(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/assignment_ref_ref_wrong_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-let-6.stella")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_bad_let_6_stella_114d145c() throws {
        let source = #"""
language core;

extend with #let-bindings;

fn main(m : Nat) -> Bool {
  return
		let n = fn(b : Bool) { return if b then false else true } in
		let c = fn(f : fn(Bool) -> Bool) { return fn(g : fn(Bool) -> Bool) { return fn(b : Bool) { return f(g(b)) } } } in
		let x = false in
		let y = 0 in
		let z = if Nat::iszero(y) then x else n(x) in
  	let x = if n(n(z)) then n else c(c(n)(n))(n) in
		let y = if z then fn(z : Bool) { return Nat::iszero(y) } else n in
		c(y(Nat::iszero(m)))
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-let-6.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-pairs-16-reconstruction.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_bad_pairs_16_reconstruction_st_e05563da() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #pairs;

fn main(x : Nat) -> Nat {
  return
    (fn(x : Nat) { return { { { x, x }, { x, x } }, { { x, Nat::iszero(x) }, { x, x } } } })(0).2.1
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-pairs-16-reconstruction.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-pairs-16.stella")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_bad_pairs_16_stella_73a75fbd() throws {
        let source = #"""
language core;

extend with #pairs;

fn main(x : Nat) -> Nat {
  return
    (fn(x : Nat) { return { { { x, x }, { x, x } }, { { x, Nat::iszero(x) }, { x, x } } } })(0).2.1
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-pairs-16.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-records-13.stella")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_bad_records_13_stella_0338feeb() throws {
        let source = #"""
language core;

extend with #records;

fn mk(k : fn(Nat) -> Bool) -> { x : fn(Bool) -> Nat, y : Nat } {
  return
    { x = { x = fn(x : Bool) {
                  return if k(succ(0))
                    then if x then 0 else succ(0)
                    else succ(succ(0))
                }
          , y = succ(0) }
    , y = { x = fn(x : Bool) {
                  return if k(succ(0))
                    then if x then 0 else succ(0)
                    else succ(succ(0))
                }
          , y = succ(0) } }.x.x
}

fn main(x : Nat) -> Nat {
  return mk(fn(x : Nat) { return Nat::iszero(x)}).x(false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-records-13.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-records-6.stella")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_bad_records_6_stella_e6a07d71() throws {
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
                , y = { x = false, y = 0}}}}.x.y.x
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-records-6.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-return-type-reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_bad_return_type_reconstruct_st_6fec44b7() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn badReturn(n : Nat) -> (fn(Nat) -> Nat){
    return succ(n)
}

fn main(n : Nat) -> Nat {
  return 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-return-type-reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-return-type.stella")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_bad_return_type_stella_f50da4b9() throws {
        let source = #"""
language core;

fn badReturn(n : Nat) -> (fn(Nat) -> Nat){
    return succ(n)
}

fn main(n : Nat) -> Nat {
  return 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-return-type.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/call_with_wrong_ref_type.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_call_with_wrong_ref_type_st_22143f15() throws {
        let source = #"""
language core;
extend with #references;

fn foo(n : &Nat) -> Nat { return *n }

fn main(n : Nat) -> Nat {
	return foo(new (true))
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/call_with_wrong_ref_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inl.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_check_inl_st_956dc465() throws {
        let source = #"""
language core;

extend with #sum-types;


fn main(succeed : Bool) -> Nat+Bool {
  return inl(true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inl.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inl_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_check_inl_reconstruct_st_2ce92bb2() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;


fn main(succeed : Bool) -> Nat+Bool {
  return inl(true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inl_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inr.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_check_inr_st_305be53c() throws {
        let source = #"""
language core;

extend with #sum-types;


fn main(succeed : Bool) -> Nat+Bool {
  return inr(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inr.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inr_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_check_inr_reconstruct_st_00388eeb() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;


fn main(succeed : Bool) -> Nat+Bool {
  return inr(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inr_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/cons_head.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_cons_head_st_9d61f370() throws {
        let source = #"""
language core;

extend with #lists;


fn main(n : Nat) -> [Nat] {
  return  cons(true, []);
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/cons_head.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/cons_head_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_cons_head_reconstruct_st_d37d7004() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;


fn main(n : Nat) -> [Nat] {
  return  cons(true, []);
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/cons_head_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/cons_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_cons_reconstruct_st_3e749f4e() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;


fn main(n : Nat) -> Nat {
  return cons(0, []);
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/cons_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const2_no_forall.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_const2_no_forall_st_557ec011() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn const[X](x : X) -> fn(X) -> X {
  return generic [Y] fn(y : Y) { return x }
}

fn main(x : Nat) -> Nat {
  return const[Nat](x)[Bool](false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const2_no_forall.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_identity.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_const_identity_st_4f58b465() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn identity[T](x : T) -> T {
  return x
}

generic fn const[X, Y](x : X) -> fn(Y) -> X {
  return identity[fn(Y) -> Y](
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
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_identity.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_succ.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_const_succ_st_d9f55df0() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn const[X, Y](x : X) -> fn(Y) -> X {
  return fn(y : Y) {
    return succ(x)
  }
}

fn main(x : Nat) -> Nat {
  return const[Nat, Bool](x)(false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_succ.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_tail.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_const_tail_st_3ad41a05() throws {
        let source = #"""
language core;

extend with #lists;


fn main(n : Nat) -> [Nat] {
  return  cons(0, [true]);
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_tail.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_tail_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_const_tail_reconstruct_st_a89b592c() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;


fn main(n : Nat) -> auto {
  return  cons(0, [true]);
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_tail_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/deref_memory.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_deref_memory_st_2cb3fccc() throws {
        let source = #"""
language core;
extend with #references, #type-ascriptions;

fn main(n : Nat) -> Nat {
	return *(<0x01> as &Bool)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/deref_memory.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/different_branches.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_different_branches_st_09a32d00() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Bool {
    return if true then false else 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/different_branches.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/different_branches_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_different_branches_reconstruct_st_4ce18749() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> auto {
    return if true then false else n
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/different_branches_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/false_return.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_false_return_st_cafc2cea() throws {
        let source = #"""
language core;

fn increment_twice(n : Nat) -> Nat {
  return false
}

fn main(n : Nat) -> Nat {
  return increment_twice(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/false_return.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/false_return_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_false_return_reconstruct_st_188d3e7f() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn increment_twice(n : auto) -> auto {
  return false
}

fn main(n : Nat) -> Nat {
  return increment_twice(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/false_return_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fix_from_arg.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_fix_from_arg_st_7a7f64fb() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator;

fn main(f : fn(Nat) -> Bool) -> Nat {
  return fix(f);
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fix_from_arg.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fix_from_arg_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_fix_from_arg_reconstruct_st_95af44fa() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn main(f : fn(Nat) -> Bool) -> Nat {
  return fix(f);
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fix_from_arg_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fixpoint.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_fixpoint_st_5fae1d29() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator;


fn main(n : Nat) -> Nat {
  return fix(fn(y : Nat) { return true });
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fixpoint.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fixpoint_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_fixpoint_reconstruct_st_bf9cb1b2() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;


fn main(n : Nat) -> auto {
  return fix(fn(y : Nat) { return true });
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fixpoint_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/function_return.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_function_return_st_d0111463() throws {
        let source = #"""
language core;

fn foo(a : Nat) -> Nat {
  return a
}

fn main(n : Nat) -> Bool {
    return foo(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/function_return.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/function_return_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_function_return_reconstruct_st_a9f38292() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn foo(a : auto) -> auto {
  return a
}

fn main(n : Nat) -> Bool {
    return foo(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/function_return_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/head_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_head_reconstruct_st_3b73016a() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(arg : Nat) -> auto {
  return (fn (a : auto) { return List::head(arg) })(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/head_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/if_nat.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_if_nat_st_917fe266() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Bool {
    return if 0 then false else true
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/if_nat.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/if_nat_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_if_nat_reconstruct_st_fcb06245() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> Bool {
    return if 0 then false else true
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/if_nat_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_cons.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_infer_cons_st_0d81b7e3() throws {
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
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_cons.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_cons_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_infer_cons_reconstruct_st_73a6d5f7() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn foo(a : Nat) -> Nat {
  return 0
}

fn main(n : Nat) -> auto {
  return (fn (a : Nat) { return cons(0, [true]); } ) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_cons_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_fix.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_infer_fix_st_bcb1ce2d() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator;

fn foo(a : Nat) -> Bool {
  return true
}

fn main(n : Nat) -> Bool {
  return (fn (a : Nat) { return fix(foo); } ) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_fix.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_fix_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_infer_fix_reconstruct_st_fbe7c088() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn foo(a : Nat) -> Nat {
  return 0
}

fn main(n : Nat) -> Nat {
  return (fn (a : Nat) { return fix(0); } ) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_fix_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_match.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_infer_match_st_f7919cc2() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return (fn (a : Nat) { return match(0) {
    x => x
    | y => true
		}
  }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_match.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_match_list_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_infer_match_list_reconstruct_st_c42d5e8d() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(n : Nat) -> Nat {
  return (fn (a : auto) { return match(0) {
    x => x
    | y => []
		}
  }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_match_list_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_match_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_infer_match_reconstruct_st_70a2f255() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> Nat {
  return (fn (a : Nat) { return match(0) {
    x => x
    | y => true
		}
  }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_match_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/int_literal.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_int_literal_st_dc4489c3() throws {
        let source = #"""
language core;

extend with #natural-literals;


fn main(n : Nat) -> Bool {
  return 5;
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/int_literal.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/int_literal_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_int_literal_reconstruct_st_575cb958() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #natural-literals;


fn main(n : Nat) -> Bool {
  return 5;
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/int_literal_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/is_empty_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_is_empty_reconstruct_st_f14f91ac() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(arg : Nat) -> auto {
  return List::isempty(arg)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/is_empty_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/is_zero_bool.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_is_zero_bool_st_d7a44979() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Bool {
    return if Nat::iszero(true) then false else true
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/is_zero_bool.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/is_zero_bool_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_is_zero_bool_reconstruct_st_c5c1edca() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> Bool {
    return if Nat::iszero(true) then false else true
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/is_zero_bool_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/lambda_wrong_argument_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_lambda_wrong_argument_reconstruct_st_926204ef() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> (fn(Bool) -> Nat) {
    return fn(i : auto) { return i }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/lambda_wrong_argument_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/lambda_wrong_second_argument_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_lambda_wrong_second_argument_reconstruct_st_b35ca9e5() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> (fn(Bool) -> fn(Bool) -> auto) {
    return fn(i : Bool) {
      return fn(j : Nat) {
        return n
      }
    }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/lambda_wrong_second_argument_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/lamda_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_lamda_reconstruct_st_7595167d() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> Bool {
    return (fn(i : auto) { return i })(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/lamda_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/let_list.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_let_list_st_e6687ee2() throws {
        let source = #"""
language core;
extend with #let-bindings;
extend with #lists;


fn main(n : Nat) -> Nat {
  return let y = [0, true] in y
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/let_list.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/let_list_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_let_list_reconstruct_st_a033142e() throws {
        let source = #"""
language core;
extend with #type-reconstruction, #let-bindings;
extend with #lists;


fn main(n : Nat) -> auto {
  return let y = [0, true] in y
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/let_list_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/my-ill-test-2.stella")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_my_ill_test_2_stella_7e1252e6() throws {
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


fn main(b : Bool) -> (fn(Bool) -> Bool) {
  return twice(Bool::not)(b)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/my-ill-test-2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/my-mismatch.stella")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_my_mismatch_stella_d7b6dd17() throws {
        let source = #"""
language core;

fn main(x : Bool) -> fn(Nat) -> Nat {
    return if x then succ(0) else 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/my-mismatch.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/nested_function_params_shadowing.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_nested_function_params_shadowing_st_d1141790() throws {
        let source = #"""
language core;

extend with #nested-function-declarations;

fn main(n : Bool) -> Nat {
  fn nested(n : Nat) -> Bool {
   	return if (n) then n else false
  }

  return if (nested(0)) then 0 else succ(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/nested_function_params_shadowing.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/no_nat_rec.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_no_nat_rec_st_aa88a8d3() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return Nat::rec(true, succ(0), fn(i : Nat) {
             return fn(r : Nat) {
             return succ( r )
           } })
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/no_nat_rec.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/no_nat_rec_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_no_nat_rec_reconstruct_st_26b2db30() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> auto {
  return Nat::rec(true, succ(0), fn(i : auto) {
             return fn(r : auto) {
             return succ( r )
           } })
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/no_nat_rec_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/not_a_f_fix_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_not_a_f_fix_reconstruct_st_a2256247() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn main(n : Nat) -> Nat {
  return fix(true);
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/not_a_f_fix_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/panic_in_one_branch_bool_in_another.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_panic_in_one_branch_bool_in_another_st_cc1be2a8() throws {
        let source = #"""
language core;
extend with #panic, #sequencing;

fn main(n : Nat) -> Nat {
  return if false then panic! else true; 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/panic_in_one_branch_bool_in_another.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/record_dot.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_record_dot_st_0339d959() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> Bool {
  return {x = 0, y = 0}.x
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/record_dot.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/record_fields_order.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_record_fields_order_st_3535895b() throws {
        let source = #"""
language core;

extend with #records;
fn foo(succeed : Bool) -> { a : Nat, b : Nat } {
  	return { a = 0, b = 0 }
}

fn main(succeed : Nat) -> { b : Nat, a : Nat } {
  return foo(true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/record_fields_order.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/recurstion_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_recurstion_reconstruct_st_f9cca20f() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : auto) -> auto {
  return Nat::rec(n, succ(0), fn(i : auto) {
             return fn(r : Bool) {
             return 0
           } })
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/recurstion_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/return_deref_wrong_ref.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_return_deref_wrong_ref_st_5e1d2e41() throws {
        let source = #"""
language core;
extend with #references;

fn foo(n : Nat) -> Nat { return 0 }

fn main(n : Nat) -> Bool {
	return *(new (foo(0)))
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/return_deref_wrong_ref.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/return_lambda_with_wrong_return.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_return_lambda_with_wrong_return_st_e816371b() throws {
        let source = #"""
language core;

fn main(n : Nat) -> (fn(Nat) -> Bool) {
    return fn(i : Nat) { return i }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/return_lambda_with_wrong_return.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/return_panic_from_lambda_as_bot.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_return_panic_from_lambda_as_bot_st_1a04ee50() throws {
        let source = #"""
language core;
extend with #panic, #ambiguous-type-as-bottom;

fn main(n : Nat) -> Nat {
  return (fn(x : Nat) {
    	return panic!
  }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/return_panic_from_lambda_as_bot.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/sequencing_non_unit_type1.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_sequencing_non_unit_type1_st_4737327a() throws {
        let source = #"""
language core;
extend with #sequencing;

fn main(n : Nat) -> Nat {
	return (fn(a : Nat) { return 0 }) (0); 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/sequencing_non_unit_type1.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/sequencing_non_unit_type2.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_sequencing_non_unit_type2_st_e7e609e8() throws {
        let source = #"""
language core;
extend with #sequencing, #unit-type;

fn main(n : Nat) -> Nat {
	return (fn(a : Nat) { return unit }) (0); (fn(a : Nat) { return a }) (0); 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/sequencing_non_unit_type2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/sequencing_wrong_return_type.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_sequencing_wrong_return_type_st_66fc9680() throws {
        let source = #"""
language core;
extend with #sequencing, #unit-type;

fn main(n : Nat) -> Bool {
	return (fn(a : Nat) { return unit }) (0); (fn(a : Nat) { return a }) (0); 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/sequencing_wrong_return_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_simple_ascription_st_461e2723() throws {
        let source = #"""
language core;
extend with #type-ascriptions;


fn main(n : Nat) -> Bool {
  return 0 as Bool
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription2.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_simple_ascription2_st_af7fa5c4() throws {
        let source = #"""
language core;
extend with #type-ascriptions;

fn main(n : Nat) -> Nat {
  return 0 as Bool
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription2_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_simple_ascription2_reconstruct_st_5e131fcf() throws {
        let source = #"""
language core;
extend with #type-reconstruction, #type-ascriptions;

fn main(n : Nat) -> Nat {
  return 0 as Bool
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription2_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_simple_ascription_reconstruct_st_66893563() throws {
        let source = #"""
language core;
extend with #type-reconstruction, #type-ascriptions;


fn main(n : Nat) -> Bool {
  return 0 as Bool
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_let.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_simple_let_st_9e5a7e44() throws {
        let source = #"""
language core;
extend with #let-bindings;

fn main(n : Nat) -> Nat {
  return let t = true in t
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_let.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_let_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_simple_let_reconstruct_st_89e94e6e() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #let-bindings;

fn main(n : Nat) -> Nat {
  return let t = true in t
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_let_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_list_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_simple_list_reconstruct_st_1f973027() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(arg : auto) -> Nat {
  return [arg, 0]
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_list_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/square_bad_add_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_square_bad_add_reconstruct_st_9a10385e() throws {
        let source = #"""
language core;

extend with #type-reconstruction;


fn Nat::add(n : auto) -> auto {
  return fn(m : auto) {
    return Nat::rec(n, m, fn(i : auto) {
      return succ( i );
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
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/square_bad_add_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/square_bad_square_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_square_bad_square_reconstruct_st_cd9a7ae2() throws {
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
        return Nat::add(i)( Nat::add(i)( succ( i )));
  });
}

fn main(n : auto) -> auto {
  return square(n);
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/square_bad_square_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/succ_true.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_succ_true_st_963e06df() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Bool {
    return succ(succ(true))
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/succ_true.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/succ_true_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_succ_true_reconstruct_st_bbf9e585() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> Bool {
    return succ(succ(true))
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/succ_true_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/tail_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_tail_reconstruct_st_052370fa() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(arg : Nat) -> auto {
  return (fn (a : auto) { return List::tail(arg) })(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/tail_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/test-1.stella")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_test_1_stella_047caabf() throws {
        let source = #"""
language core;
extend with #unit-type;

fn seq(_ : Unit) -> fn(Unit) -> Unit {
  return fn(x : Unit) { return x }
}

fn main(x : Nat) -> Unit {
	return seq(seq(unit)(seq(unit)))(unit)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/test-1.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/test-1_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_test_1_reconstruct_st_517dd3df() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #unit-type;

fn seq(_ : auto) -> auto {
  return fn(x : auto) { return x }
}

fn main(x : Nat) -> Unit {
	return seq(seq(seq(unit)(unit))(seq(unit)))(seq(seq(unit)(unit))(seq(unit)(unit)))
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/test-1_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/throw_invalid_type.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_throw_invalid_type_st_248fb39c() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals, #exception-type-declaration;

exception type = Nat

fn main(n : Nat) -> Nat {
  return throw(true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/throw_invalid_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/try_cast_as_expr.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_try_cast_as_expr_st_394ae59a() throws {
        let source = #"""
language core;

extend with #try-cast-as, #structural-patterns, #natural-literals;

fn main(n : Nat) -> Nat {
  return try { true } cast as Nat
    { 1 => true }
    with
    { 12 }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/try_cast_as_expr.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/try_cast_as_fallback.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_try_cast_as_fallback_st_7b8d1e25() throws {
        let source = #"""
language core;

extend with #try-cast-as, #structural-patterns, #natural-literals;

fn main(n : Nat) -> Nat {
  return try { true } cast as Nat
    { 1 => 12 }
    with
    { true }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/try_cast_as_fallback.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/tuple_dot.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_tuple_dot_st_9779f855() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> Bool {
  return {0, 0}.1
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/tuple_dot.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected-type-for-expression-1.stella")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_type_for_expression_1_stella_2efb775d() throws {
        let source = #"""
language core;

fn twice(f : fn(Nat) -> Nat) -> fn(Nat) -> Nat {
  return fn(n : Nat) {
    return f(f(n))
  }
}

fn main(n : Nat) -> Nat {
  return twice( fn(x : Nat){ return n } )
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected-type-for-expression-1.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_application.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_application_st_54797003() throws {
        let source = #"""
language core;

fn main(f : fn(Bool) -> Bool) -> Bool {
    return f(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_application.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_application_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_application_reconstruct_st_4ddf897b() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(f : fn(Bool) -> auto) -> auto {
    return f(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_application_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_inl_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_inl_reconstruct_st_b24e2d8c() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;

fn main(input : Bool) -> Nat {
  return inl(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_inl_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_inr_reconstruct.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_inr_reconstruct_st_fceea36b() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;

fn main(input : Bool) -> Nat {
  return inr(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_inr_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_isempty.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_isempty_st_25681e0c() throws {
        let source = #"""
language core;

extend with #lists;
extend with #type-ascriptions;

fn main(n : Nat) -> Nat {
    return List::isempty([0] as [Nat])
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_isempty.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_iszero.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_iszero_st_02e961ff() throws {
        let source = #"""
language core;


fn main(n : Nat) -> Nat {
    return Nat::iszero(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_iszero.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_label_type.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_label_type_st_ecb3add3() throws {
        let source = #"""
language core;

extend with #variants, #unit-type;

fn main(succeed : Bool) -> <| value : Nat, failure : Unit |> {
  return
    if succeed
      then <| value = true |>
      else <| failure = unit |>
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_label_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_multiparam.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_multiparam_st_187a8452() throws {
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
    return get_m_f(0, true, 0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_multiparam.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_s_rec.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_s_rec_st_403258bd() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return Nat::rec(n, succ(0), fn(i : Nat) {
             return fn(r : Nat) {
             return true
           } })
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_s_rec.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_tail.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_tail_st_8c5ae294() throws {
        let source = #"""
language core;

extend with #lists;
extend with #type-ascriptions;

fn main(n : Nat) -> Bool {
    return List::tail([0] as [Nat])
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_tail.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_unit.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_unit_st_defacf81() throws {
        let source = #"""
language core;
extend with #unit-type;

fn main(_ : Nat) -> Nat {
    return unit
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_unit.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_zero_param.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_zero_param_st_702adc0f() throws {
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
    return getZero()
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_zero_param.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unref_bool.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unref_bool_st_d3ab926a() throws {
        let source = #"""
language core;
extend with #references;

fn main(n : Nat) -> Nat {
	return *(true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unref_bool.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/variant_fields_order.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_variant_fields_order_st_df65635f() throws {
        let source = #"""
language core;

extend with #variants, #unit-type;
fn foo(succeed : Bool) -> <|failure : Nat, value : Nat|> {
  	return <| value = 0 |>
}

fn main(succeed : Nat) -> <|value : Nat, failure : Nat|> {
  return foo(true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/variant_fields_order.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_PARAMETER/recursion.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_PARAMETER_recursion_st_028e7d35() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return Nat::rec(n, succ(0), fn(i : Bool) {
             return fn(r : Nat) {
             return 0
           } })
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_PARAMETER/recursion.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_PARAMETER")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_PARAMETER/return_lambda_with_wrong_argument.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_PARAMETER_return_lambda_with_wrong_argument_st_e40fd85d() throws {
        let source = #"""
language core;

fn main(n : Nat) -> (fn(Bool) -> Nat) {
    return fn(i : Nat) { return i }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_PARAMETER/return_lambda_with_wrong_argument.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_PARAMETER")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_TYPE_FOR_PARAMETER/return_lambda_with_wrong_second_argument.st")
    func test_bad_ERROR_UNEXPECTED_TYPE_FOR_PARAMETER_return_lambda_with_wrong_second_argument_st_f8153281() throws {
        let source = #"""
language core;

fn main(n : Nat) -> (fn(Bool) -> fn(Bool) -> Nat) {
    return fn(i : Bool) {
      return fn(j : Nat) {
        return n
      }
    }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_TYPE_FOR_PARAMETER/return_lambda_with_wrong_second_argument.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_PARAMETER")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_VARIANT/simple_unexpected_variant.st")
    func test_bad_ERROR_UNEXPECTED_VARIANT_simple_unexpected_variant_st_7341622b() throws {
        let source = #"""
language core;

extend with #variants, #unit-type;

fn main(succeed : Bool) -> Nat {
  return
    if succeed
      then <| value = 0 |>
      else <| failure = unit |>
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_VARIANT/simple_unexpected_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_VARIANT")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_VARIANT/unexpected-variant-3.stella")
    func test_bad_ERROR_UNEXPECTED_VARIANT_unexpected_variant_3_stella_2df1a092() throws {
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
            sourceName: "bad/ERROR_UNEXPECTED_VARIANT/unexpected-variant-3.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_VARIANT")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_VARIANT_LABEL/simple_unexpected_label.st")
    func test_bad_ERROR_UNEXPECTED_VARIANT_LABEL_simple_unexpected_label_st_a529dd42() throws {
        let source = #"""
language core;

extend with #variants, #unit-type;

fn main(succeed : Bool) -> <| value : Nat, failure : Unit |> {
  return
    if succeed
      then <| v = 0 |>
      else <| failure = unit |>
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_VARIANT_LABEL/simple_unexpected_label.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_VARIANT_LABEL")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_VARIANT_LABEL/subtyping_variant.st")
    func test_bad_ERROR_UNEXPECTED_VARIANT_LABEL_subtyping_variant_st_15ef2bd1() throws {
        let source = #"""
language core;

extend with #variants,
            #natural-literals,
            #top-type,
            #bottom-type,
            #structural-subtyping;

fn fail(n : Nat) -> <| failure : Top, value : Nat, value2 : Bool |> {
	return <| failure = 1 |>
}

fn main(n : Nat) -> <| value : Nat, failure : Top, value3 : Top |> {
  return fail(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_VARIANT_LABEL/subtyping_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_VARIANT_LABEL")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_VARIANT_LABEL/unexpected_nullary_label.st")
    func test_bad_ERROR_UNEXPECTED_VARIANT_LABEL_unexpected_nullary_label_st_9c6a10a2() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #variants, #nullary-variant-labels;

fn main(n : Nat) -> <| a : Nat, b, c |> {
  return <| e |>
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_VARIANT_LABEL/unexpected_nullary_label.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_VARIANT_LABEL")
        }
    }

    @Test("bad/ERROR_UNEXPECTED_VARIANT_LABEL/variant_asc.st")
    func test_bad_ERROR_UNEXPECTED_VARIANT_LABEL_variant_asc_st_d2d88f82() throws {
        let source = #"""
language core;

extend with #variants, #type-ascriptions;

fn main(succeed : Bool) -> Nat {
  return match (<| a = succ(0) |>) as <| b : Nat, c : Bool |> {
        <| b = t |> => t
        | <| c = t |> => 0
    }
}
"""#
        let program = try Program.parser.run(
            sourceName: "bad/ERROR_UNEXPECTED_VARIANT_LABEL/variant_asc.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_VARIANT_LABEL")
        }
    }
}
