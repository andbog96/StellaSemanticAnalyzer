import Testing
@testable import StellaSemanticAnalyzer

@Suite("Imported examples")
@MainActor
struct ImportedExamplesTests {
    @Test("examples/bad/ERROR_AMBIGUOUS_LIST_TYPE/head.st")
    func test_examples_bad_ERROR_AMBIGUOUS_LIST_TYPE_head_st_b68bff85() throws {
        let source = #"""
language core;

extend with #lists ;

fn main(n : Nat) -> Nat {
  return List::head([])(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_AMBIGUOUS_LIST_TYPE/head.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_LIST_TYPE")
        }
    }

    @Test("examples/bad/ERROR_AMBIGUOUS_LIST_TYPE/infer_match.st")
    func test_examples_bad_ERROR_AMBIGUOUS_LIST_TYPE_infer_match_st_8e2abd6b() throws {
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
            sourceName: "examples/bad/ERROR_AMBIGUOUS_LIST_TYPE/infer_match.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_LIST_TYPE")
        }
    }

    @Test("examples/bad/ERROR_AMBIGUOUS_LIST_TYPE/let.st")
    func test_examples_bad_ERROR_AMBIGUOUS_LIST_TYPE_let_st_1d77355b() throws {
        let source = #"""
language core;

extend with #lists ;
extend with #let-bindings;

fn main(n : Nat) -> Nat {
  return let x = [] in x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_AMBIGUOUS_LIST_TYPE/let.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_LIST_TYPE")
        }
    }

    @Test("examples/bad/ERROR_AMBIGUOUS_PANIC_TYPE/panic_inside_lambda.st")
    func test_examples_bad_ERROR_AMBIGUOUS_PANIC_TYPE_panic_inside_lambda_st_a0d9740b() throws {
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
            sourceName: "examples/bad/ERROR_AMBIGUOUS_PANIC_TYPE/panic_inside_lambda.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_PANIC_TYPE")
        }
    }

    @Test("examples/bad/ERROR_AMBIGUOUS_PANIC_TYPE/panic_or_function.st")
    func test_examples_bad_ERROR_AMBIGUOUS_PANIC_TYPE_panic_or_function_st_f0232581() throws {
        let source = #"""
language core;
extend with #panic;

fn main(n : Nat) -> Nat {
  return (if false then panic! else fn (x : Nat) { return x }) (0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_AMBIGUOUS_PANIC_TYPE/panic_or_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_PANIC_TYPE")
        }
    }

    @Test("examples/bad/ERROR_AMBIGUOUS_PATTERN_TYPE/simple_letrec.st")
    func test_examples_bad_ERROR_AMBIGUOUS_PATTERN_TYPE_simple_letrec_st_8b070d2c() throws {
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
            sourceName: "examples/bad/ERROR_AMBIGUOUS_PATTERN_TYPE/simple_letrec.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_PATTERN_TYPE")
        }
    }

    @Test("examples/bad/ERROR_AMBIGUOUS_REFERENCE_TYPE/deref_memory_from_lambda.st")
    func test_examples_bad_ERROR_AMBIGUOUS_REFERENCE_TYPE_deref_memory_from_lambda_st_849b0aac() throws {
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
            sourceName: "examples/bad/ERROR_AMBIGUOUS_REFERENCE_TYPE/deref_memory_from_lambda.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_REFERENCE_TYPE")
        }
    }

    @Test("examples/bad/ERROR_AMBIGUOUS_SUM_TYPE/simple_inl.st")
    func test_examples_bad_ERROR_AMBIGUOUS_SUM_TYPE_simple_inl_st_d76e345f() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(n : Nat) -> Nat + Nat {
  return (fn (a : Nat) { return inl(0) }) (0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_AMBIGUOUS_SUM_TYPE/simple_inl.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_SUM_TYPE")
        }
    }

    @Test("examples/bad/ERROR_AMBIGUOUS_SUM_TYPE/simple_inr.st")
    func test_examples_bad_ERROR_AMBIGUOUS_SUM_TYPE_simple_inr_st_3dc6798c() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(n : Nat) -> Nat + Nat {
  return (fn (a : Nat) { return inr(0) }) (0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_AMBIGUOUS_SUM_TYPE/simple_inr.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_SUM_TYPE")
        }
    }

    @Test("examples/bad/ERROR_AMBIGUOUS_THROW_TYPE/throw_inside_lambda.st")
    func test_examples_bad_ERROR_AMBIGUOUS_THROW_TYPE_throw_inside_lambda_st_c3510a5e() throws {
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
            sourceName: "examples/bad/ERROR_AMBIGUOUS_THROW_TYPE/throw_inside_lambda.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_THROW_TYPE")
        }
    }

    @Test("examples/bad/ERROR_AMBIGUOUS_THROW_TYPE/throw_or_function.st")
    func test_examples_bad_ERROR_AMBIGUOUS_THROW_TYPE_throw_or_function_st_249ce5f7() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals, #exception-type-declaration;

exception type = Nat
fn main(n : Nat) -> Nat {
  return (if false then throw(1) else fn (x : Nat) { return x }) (0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_AMBIGUOUS_THROW_TYPE/throw_or_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_THROW_TYPE")
        }
    }

    @Test("examples/bad/ERROR_AMBIGUOUS_VARIANT_TYPE/ambiguous-variant-type-1.stella")
    func test_examples_bad_ERROR_AMBIGUOUS_VARIANT_TYPE_ambiguous_variant_type_1_stella_dfb70ff3() throws {
        let source = #"""
language core;

extend with #variants;
extend with #type-ascriptions;

fn main(n : Nat) -> fn(Bool) -> Nat {
  return (fn (b : Bool) { return  <| value = n |>  })(true)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_AMBIGUOUS_VARIANT_TYPE/ambiguous-variant-type-1.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_VARIANT_TYPE")
        }
    }

    @Test("examples/bad/ERROR_AMBIGUOUS_VARIANT_TYPE/ambiguous-variant-type-2.stella")
    func test_examples_bad_ERROR_AMBIGUOUS_VARIANT_TYPE_ambiguous_variant_type_2_stella_6d8acd84() throws {
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
            sourceName: "examples/bad/ERROR_AMBIGUOUS_VARIANT_TYPE/ambiguous-variant-type-2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_VARIANT_TYPE")
        }
    }

    @Test("examples/bad/ERROR_AMBIGUOUS_VARIANT_TYPE/ambiguous-variant-type-3.stella")
    func test_examples_bad_ERROR_AMBIGUOUS_VARIANT_TYPE_ambiguous_variant_type_3_stella_63801b99() throws {
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
            sourceName: "examples/bad/ERROR_AMBIGUOUS_VARIANT_TYPE/ambiguous-variant-type-3.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_VARIANT_TYPE")
        }
    }

    @Test("examples/bad/ERROR_AMBIGUOUS_VARIANT_TYPE/simple.st")
    func test_examples_bad_ERROR_AMBIGUOUS_VARIANT_TYPE_simple_st_c4166f79() throws {
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
            sourceName: "examples/bad/ERROR_AMBIGUOUS_VARIANT_TYPE/simple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_VARIANT_TYPE")
        }
    }

    @Test("examples/bad/ERROR_EXCEPTION_TYPE_NOT_DECLARED/not_declared.st")
    func test_examples_bad_ERROR_EXCEPTION_TYPE_NOT_DECLARED_not_declared_st_0cad2988() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals;

fn main(n : Nat) -> Nat {
  return try { throw(1) } with { 1 }
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_EXCEPTION_TYPE_NOT_DECLARED/not_declared.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_EXCEPTION_TYPE_NOT_DECLARED")
        }
    }

    @Test("examples/bad/ERROR_ILLEGAL_EMPTY_MATCHING/empty_match.st")
    func test_examples_bad_ERROR_ILLEGAL_EMPTY_MATCHING_empty_match_st_4deaa113() throws {
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
            sourceName: "examples/bad/ERROR_ILLEGAL_EMPTY_MATCHING/empty_match.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_ILLEGAL_EMPTY_MATCHING")
        }
    }

    @Test("examples/bad/ERROR_ILLEGAL_EMPTY_MATCHING/empty_match_reconstruct.st")
    func test_examples_bad_ERROR_ILLEGAL_EMPTY_MATCHING_empty_match_reconstruct_st_ab364c3c() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types, #unit-type;

fn test(first : auto) -> auto {
  return if first then inl(succ(0)) else unit
}

fn main(input : auto) -> Nat {
  return match test(input) {
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_ILLEGAL_EMPTY_MATCHING/empty_match_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_ILLEGAL_EMPTY_MATCHING")
        }
    }

    @Test("examples/bad/ERROR_INCORRECT_ARITY_OF_MAIN/main_with_two_params.st")
    func test_examples_bad_ERROR_INCORRECT_ARITY_OF_MAIN_main_with_two_params_st_93f2d5c6() throws {
        let source = #"""
language core;

extend with #multiparameter-functions;

fn main(n : Nat, z : Nat) -> Nat {
    return z
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_INCORRECT_ARITY_OF_MAIN/main_with_two_params.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_ARITY_OF_MAIN")
        }
    }

    @Test("examples/bad/ERROR_INCORRECT_ARITY_OF_MAIN/main_with_zero_param.st")
    func test_examples_bad_ERROR_INCORRECT_ARITY_OF_MAIN_main_with_zero_param_st_cf0c643e() throws {
        let source = #"""
language core;

extend with #nullary-functions;

fn main() -> Nat {
    return 0
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_INCORRECT_ARITY_OF_MAIN/main_with_zero_param.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_ARITY_OF_MAIN")
        }
    }

    @Test("examples/bad/ERROR_INCORRECT_NUMBER_OF_ARGUMENTS/incorrect_num.st")
    func test_examples_bad_ERROR_INCORRECT_NUMBER_OF_ARGUMENTS_incorrect_num_st_69a51be8() throws {
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
            sourceName: "examples/bad/ERROR_INCORRECT_NUMBER_OF_ARGUMENTS/incorrect_num.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_NUMBER_OF_ARGUMENTS")
        }
    }

    @Test("examples/bad/ERROR_INCORRECT_NUMBER_OF_ARGUMENTS/infer_fix_multiple_param.st")
    func test_examples_bad_ERROR_INCORRECT_NUMBER_OF_ARGUMENTS_infer_fix_multiple_param_st_6bb5ae70() throws {
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
            sourceName: "examples/bad/ERROR_INCORRECT_NUMBER_OF_ARGUMENTS/infer_fix_multiple_param.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_NUMBER_OF_ARGUMENTS")
        }
    }

    @Test("examples/bad/ERROR_INCORRECT_NUMBER_OF_ARGUMENTS/infer_fix_zero_param.st")
    func test_examples_bad_ERROR_INCORRECT_NUMBER_OF_ARGUMENTS_infer_fix_zero_param_st_da7735ea() throws {
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
            sourceName: "examples/bad/ERROR_INCORRECT_NUMBER_OF_ARGUMENTS/infer_fix_zero_param.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_NUMBER_OF_ARGUMENTS")
        }
    }

    @Test("examples/bad/ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS/const_few_vars.st")
    func test_examples_bad_ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS_const_few_vars_st_c52d9e87() throws {
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
            sourceName: "examples/bad/ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS/const_few_vars.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS")
        }
    }

    @Test("examples/bad/ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS/const_many_vars.st")
    func test_examples_bad_ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS_const_many_vars_st_ad38b253() throws {
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
            sourceName: "examples/bad/ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS/const_many_vars.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS")
        }
    }

    @Test("examples/bad/ERROR_MISSING_DATA_FOR_LABEL/simple.st")
    func test_examples_bad_ERROR_MISSING_DATA_FOR_LABEL_simple_st_39337fc1() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #variants, #nullary-variant-labels;

fn main(n : Nat) -> <| a : Nat, b, c |> {
  return <| a |>
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_MISSING_DATA_FOR_LABEL/simple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_DATA_FOR_LABEL")
        }
    }

    @Test("examples/bad/ERROR_MISSING_MAIN/no_main.st")
    func test_examples_bad_ERROR_MISSING_MAIN_no_main_st_1915e8d3() throws {
        let source = #"""
language core;

fn increment_twice(n : Nat) -> Nat {
  return succ(succ(n))
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_MISSING_MAIN/no_main.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_MAIN")
        }
    }

    @Test("examples/bad/ERROR_MISSING_RECORD_FIELDS/call_function_with_missing_fields.st")
    func test_examples_bad_ERROR_MISSING_RECORD_FIELDS_call_function_with_missing_fields_st_dce30c44() throws {
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
            sourceName: "examples/bad/ERROR_MISSING_RECORD_FIELDS/call_function_with_missing_fields.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_RECORD_FIELDS")
        }
    }

    @Test("examples/bad/ERROR_MISSING_RECORD_FIELDS/record_in_abstraction.st")
    func test_examples_bad_ERROR_MISSING_RECORD_FIELDS_record_in_abstraction_st_dd312153() throws {
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
            sourceName: "examples/bad/ERROR_MISSING_RECORD_FIELDS/record_in_abstraction.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_RECORD_FIELDS")
        }
    }

    @Test("examples/bad/ERROR_MISSING_RECORD_FIELDS/record_in_record.st")
    func test_examples_bad_ERROR_MISSING_RECORD_FIELDS_record_in_record_st_6b64ca21() throws {
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
            sourceName: "examples/bad/ERROR_MISSING_RECORD_FIELDS/record_in_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_RECORD_FIELDS")
        }
    }

    @Test("examples/bad/ERROR_MISSING_RECORD_FIELDS/simple_missing_fields.st")
    func test_examples_bad_ERROR_MISSING_RECORD_FIELDS_simple_missing_fields_st_9e9a64b5() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> { fst : Nat, snd : Bool } {
  return { fst = 0 }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_MISSING_RECORD_FIELDS/simple_missing_fields.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_RECORD_FIELDS")
        }
    }

    @Test("examples/bad/ERROR_MISSING_RECORD_FIELDS/subtyping_record.st")
    func test_examples_bad_ERROR_MISSING_RECORD_FIELDS_subtyping_record_st_e4444d5c() throws {
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
            sourceName: "examples/bad/ERROR_MISSING_RECORD_FIELDS/subtyping_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_RECORD_FIELDS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_bool.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_bool_st_4f7ceecb() throws {
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
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_bool.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_empty_list.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_empty_list_st_37bc1674() throws {
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
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_empty_list.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_list.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_list_st_c26b39b5() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #lists;

fn main(n : [Nat]) -> Nat {
  return match n {
    	[] => 0
    	| cons (x, cons(a, xs)) => 0
   }
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_list.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_nat_1.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_nat_1_st_b86be814() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals;

fn main(n : Nat) -> Nat {
  return match 5 {
    	0 => 0
    | succ(succ(n)) => 0
   }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_nat_1.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_nat_2.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_nat_2_st_8d3202a8() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals;

fn main(n : Nat) -> Nat {
  return match 5 {
    	0 => 0
    | 5 => 0
    | 4 => 0
   }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_nat_2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_nat_3.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_nat_3_st_858407e7() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals;

fn main(n : Nat) -> Nat {
  return match 5 {
    	0 => 0
    | 5 => 0
    | succ(succ(succ(4))) => 0
   }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_nat_3.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_nat_4.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_nat_4_st_89083406() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals;

fn main(n : Nat) -> Nat {
  return match 5 {
    	0 => 0
	    | succ(succ(succ(_))) => 0
   }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_nat_4.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_record.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_record_st_a53d739d() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #records;

fn main(n : Nat) -> Nat {
  return match {a = true, b = 0} {
    	{b = 0, a = d} => 0
   }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_sum.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_sum_st_b47175a1() throws {
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
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_sum.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_sum_nat.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_sum_nat_st_5c9434c3() throws {
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
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_sum_nat.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_sum_reconstruct.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_sum_reconstruct_st_f18c317f() throws {
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
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_sum_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_tuple.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_ne_tuple_st_13ac5ca3() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #tuples;

fn main(n : Nat) -> Nat {
  return match {{0, true}, true} {
    	{{a, c}, true} => 0
   }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/ne_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/nonexhaustive_match.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_nonexhaustive_match_st_cc687838() throws {
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
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/nonexhaustive_match.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/nonexhaustive_match_reconstruct.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_nonexhaustive_match_reconstruct_st_788ad43f() throws {
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
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/nonexhaustive_match_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/nonexhaustive_variant.st")
    func test_examples_bad_ERROR_NONEXHAUSTIVE_MATCH_PATTERNS_nonexhaustive_variant_st_31996153() throws {
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
            sourceName: "examples/bad/ERROR_NONEXHAUSTIVE_MATCH_PATTERNS/nonexhaustive_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_FUNCTION/apply_record.st")
    func test_examples_bad_ERROR_NOT_A_FUNCTION_apply_record_st_69d18a22() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> Nat {
  return {l1 = 0, l2 = false}(0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_FUNCTION/apply_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_FUNCTION/apply_tuple.st")
    func test_examples_bad_ERROR_NOT_A_FUNCTION_apply_tuple_st_5cab16db() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> Nat {
  return {0, false}(0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_FUNCTION/apply_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_FUNCTION/before_arg_type_check.st")
    func test_examples_bad_ERROR_NOT_A_FUNCTION_before_arg_type_check_st_44574541() throws {
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
            sourceName: "examples/bad/ERROR_NOT_A_FUNCTION/before_arg_type_check.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_FUNCTION/infer_fix.st")
    func test_examples_bad_ERROR_NOT_A_FUNCTION_infer_fix_st_4f0be011() throws {
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
            sourceName: "examples/bad/ERROR_NOT_A_FUNCTION/infer_fix.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_FUNCTION/not_a_f_fix.st")
    func test_examples_bad_ERROR_NOT_A_FUNCTION_not_a_f_fix_st_ba805208() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator;


fn main(n : Nat) -> Nat {
  return fix(true);
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_FUNCTION/not_a_f_fix.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_FUNCTION/simple_no_function.st")
    func test_examples_bad_ERROR_NOT_A_FUNCTION_simple_no_function_st_4eda6d2a() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return n(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_FUNCTION/simple_no_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_GENERIC_FUNCTION/const2_not_generic.st")
    func test_examples_bad_ERROR_NOT_A_GENERIC_FUNCTION_const2_not_generic_st_5e3a59f3() throws {
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
            sourceName: "examples/bad/ERROR_NOT_A_GENERIC_FUNCTION/const2_not_generic.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_GENERIC_FUNCTION")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_LIST/head.st")
    func test_examples_bad_ERROR_NOT_A_LIST_head_st_abb707b3() throws {
        let source = #"""
language core;

extend with #lists;

fn main(arg : Nat) -> Nat {
  return (fn (a : Nat) { return List::head(arg) })(0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_LIST/head.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_LIST")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_LIST/is_empty.st")
    func test_examples_bad_ERROR_NOT_A_LIST_is_empty_st_fed20570() throws {
        let source = #"""
language core;

extend with #lists;

fn main(arg : Nat) -> Bool {
  return List::isempty(arg)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_LIST/is_empty.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_LIST")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_LIST/tail.st")
    func test_examples_bad_ERROR_NOT_A_LIST_tail_st_c82d8a61() throws {
        let source = #"""
language core;

extend with #lists;

fn main(arg : Nat) -> [Nat] {
  return (fn (a : Nat) { return List::tail(arg) })(0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_LIST/tail.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_LIST")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_RECORD/bool_is_not_a_record.st")
    func test_examples_bad_ERROR_NOT_A_RECORD_bool_is_not_a_record_st_5f762359() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Bool) -> Nat {
  return 0.field
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_RECORD/bool_is_not_a_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_RECORD")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_RECORD/func_is_not_a_record.st")
    func test_examples_bad_ERROR_NOT_A_RECORD_func_is_not_a_record_st_8c1d32b9() throws {
        let source = #"""
language core;
extend with #records;

fn main(f : (fn(Nat) -> Bool)) -> Nat {
  return f.field
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_RECORD/func_is_not_a_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_RECORD")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_RECORD/if_is_not_a_record.st")
    func test_examples_bad_ERROR_NOT_A_RECORD_if_is_not_a_record_st_74517e1f() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Bool) -> Nat {
  return (if (n) then 0 else succ(0)).field
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_RECORD/if_is_not_a_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_RECORD")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_RECORD/nat_is_not_a_record.st")
    func test_examples_bad_ERROR_NOT_A_RECORD_nat_is_not_a_record_st_6cba097e() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> Nat {
  return 0.fst
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_RECORD/nat_is_not_a_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_RECORD")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_RECORD/unit_is_not_a_record.st")
    func test_examples_bad_ERROR_NOT_A_RECORD_unit_is_not_a_record_st_a877ef26() throws {
        let source = #"""
language core;
extend with #records, #unit-type;

fn main(u : Unit) -> Nat {
  return u.field
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_RECORD/unit_is_not_a_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_RECORD")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_REFERENCE/assignment_to_non_ref_parameter.st")
    func test_examples_bad_ERROR_NOT_A_REFERENCE_assignment_to_non_ref_parameter_st_c5ceea27() throws {
        let source = #"""
language core;
extend with #references, #sequencing;

fn main(n : Nat) -> Nat {
	return n := 0; n
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_REFERENCE/assignment_to_non_ref_parameter.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_REFERENCE")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_REFERENCE/deref_parameter.st")
    func test_examples_bad_ERROR_NOT_A_REFERENCE_deref_parameter_st_33dc8de8() throws {
        let source = #"""
language core;
extend with #references;

fn foo(n : Nat) -> Nat { return *n }

fn main(n : Nat) -> Nat {
	return foo(n)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_REFERENCE/deref_parameter.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_REFERENCE")
        }
    }

    @Test("examples/bad/ERROR_NOT_A_TUPLE/simple_not_a_tuple.st")
    func test_examples_bad_ERROR_NOT_A_TUPLE_simple_not_a_tuple_st_ab04657e() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> Nat {
  return true.1
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_NOT_A_TUPLE/simple_not_a_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_TUPLE")
        }
    }

    @Test("examples/bad/ERROR_OCCURS_CHECK_INFINITE_TYPE/infinite_function_fix_type.st")
    func test_examples_bad_ERROR_OCCURS_CHECK_INFINITE_TYPE_infinite_function_fix_type_st_19fc50a4() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn main(f : auto) -> auto {
    return fix(f(f))
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_OCCURS_CHECK_INFINITE_TYPE/infinite_function_fix_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_OCCURS_CHECK_INFINITE_TYPE")
        }
    }

    @Test("examples/bad/ERROR_OCCURS_CHECK_INFINITE_TYPE/infinite_function_type.st")
    func test_examples_bad_ERROR_OCCURS_CHECK_INFINITE_TYPE_infinite_function_type_st_fb03d641() throws {
        let source = #"""
language core;
extend with #type-reconstruction;

fn main(f : auto) -> auto {
    return f(f)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_OCCURS_CHECK_INFINITE_TYPE/infinite_function_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_OCCURS_CHECK_INFINITE_TYPE")
        }
    }

    @Test("examples/bad/ERROR_TUPLE_INDEX_OUT_OF_BOUNDS/tuple_from_function.st")
    func test_examples_bad_ERROR_TUPLE_INDEX_OUT_OF_BOUNDS_tuple_from_function_st_25ca31df() throws {
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
            sourceName: "examples/bad/ERROR_TUPLE_INDEX_OUT_OF_BOUNDS/tuple_from_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_TUPLE_INDEX_OUT_OF_BOUNDS")
        }
    }

    @Test("examples/bad/ERROR_TUPLE_INDEX_OUT_OF_BOUNDS/tuple_literal.st")
    func test_examples_bad_ERROR_TUPLE_INDEX_OUT_OF_BOUNDS_tuple_literal_st_630f144b() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> Nat {
  return {n, succ(n), true}.4
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_TUPLE_INDEX_OUT_OF_BOUNDS/tuple_literal.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_TUPLE_INDEX_OUT_OF_BOUNDS")
        }
    }

    @Test("examples/bad/ERROR_UNDEFINED_TYPE_VARIABLE/const_undefined_var.st")
    func test_examples_bad_ERROR_UNDEFINED_TYPE_VARIABLE_const_undefined_var_st_fe53f69b() throws {
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
            sourceName: "examples/bad/ERROR_UNDEFINED_TYPE_VARIABLE/const_undefined_var.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNDEFINED_TYPE_VARIABLE")
        }
    }

    @Test("examples/bad/ERROR_UNDEFINED_VARIABLE/in_let.st")
    func test_examples_bad_ERROR_UNDEFINED_VARIABLE_in_let_st_2fb04ac4() throws {
        let source = #"""
language core;
extend with #let-bindings;


fn main(n : Nat) -> Nat {
  return let y = let x = 0 in x in x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNDEFINED_VARIABLE/in_let.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNDEFINED_VARIABLE")
        }
    }

    @Test("examples/bad/ERROR_UNDEFINED_VARIABLE/nested_func.st")
    func test_examples_bad_ERROR_UNDEFINED_VARIABLE_nested_func_st_43cd1386() throws {
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
            sourceName: "examples/bad/ERROR_UNDEFINED_VARIABLE/nested_func.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNDEFINED_VARIABLE")
        }
    }

    @Test("examples/bad/ERROR_UNDEFINED_VARIABLE/simple_undefined_var.st")
    func test_examples_bad_ERROR_UNDEFINED_VARIABLE_simple_undefined_var_st_8e008783() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
    return a
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNDEFINED_VARIABLE/simple_undefined_var.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNDEFINED_VARIABLE")
        }
    }

    @Test("examples/bad/ERROR_UNDEFINED_VARIABLE/undefined_var_in_other_fun.st")
    func test_examples_bad_ERROR_UNDEFINED_VARIABLE_undefined_var_in_other_fun_st_dbb726b8() throws {
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
            sourceName: "examples/bad/ERROR_UNDEFINED_VARIABLE/undefined_var_in_other_fun.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNDEFINED_VARIABLE")
        }
    }

    @Test("examples/bad/ERROR_UNDEFINED_VARIABLE/undefined_var_reconstruct.st")
    func test_examples_bad_ERROR_UNDEFINED_VARIABLE_undefined_var_reconstruct_st_c108900a() throws {
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
            sourceName: "examples/bad/ERROR_UNDEFINED_VARIABLE/undefined_var_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNDEFINED_VARIABLE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_DATA_FOR_NULLARY_LABEL/simple.st")
    func test_examples_bad_ERROR_UNEXPECTED_DATA_FOR_NULLARY_LABEL_simple_st_65131684() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #variants, #nullary-variant-labels;

fn main(n : Nat) -> <| a : Nat, b, c |> {
  return <| b = true |>
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_DATA_FOR_NULLARY_LABEL/simple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_DATA_FOR_NULLARY_LABEL")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_FIELD_ACCESS/simple_field_access.st")
    func test_examples_bad_ERROR_UNEXPECTED_FIELD_ACCESS_simple_field_access_st_093a6d80() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> Nat {
  return { fst = 0, snd = true }.thd
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_FIELD_ACCESS/simple_field_access.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_FIELD_ACCESS")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_INJECTION/simple_unexpected_inl.st")
    func test_examples_bad_ERROR_UNEXPECTED_INJECTION_simple_unexpected_inl_st_2ca92785() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(input : Bool) -> Nat {
  return inl(0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_INJECTION/simple_unexpected_inl.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_INJECTION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_INJECTION/simple_unexpected_inr.st")
    func test_examples_bad_ERROR_UNEXPECTED_INJECTION_simple_unexpected_inr_st_eabf129c() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(input : Bool) -> Nat {
  return inr(0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_INJECTION/simple_unexpected_inr.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_INJECTION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_LAMBDA/simple_unexpected_lambda.st")
    func test_examples_bad_ERROR_UNEXPECTED_LAMBDA_simple_unexpected_lambda_st_d62ea6d4() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Bool {
    return fn(i : Nat) { return i }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_LAMBDA/simple_unexpected_lambda.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_LAMBDA")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_LIST/cons.st")
    func test_examples_bad_ERROR_UNEXPECTED_LIST_cons_st_12ac3bb4() throws {
        let source = #"""
language core;

extend with #lists;


fn main(n : Nat) -> Nat {
  return  cons(0, []);
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_LIST/cons.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_LIST")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_LIST/infer_match.st")
    func test_examples_bad_ERROR_UNEXPECTED_LIST_infer_match_st_9fd08743() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_LIST/infer_match.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_LIST")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_LIST/simple.st")
    func test_examples_bad_ERROR_UNEXPECTED_LIST_simple_st_2d53f3b3() throws {
        let source = #"""
language core;

extend with #lists;

fn main(arg : Nat) -> Nat {
  return [arg, 0]
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_LIST/simple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_LIST")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_MEMORY_ADDRESS/memory_in_if_2.st")
    func test_examples_bad_ERROR_UNEXPECTED_MEMORY_ADDRESS_memory_in_if_2_st_71bb0265() throws {
        let source = #"""
language core;
extend with #references, #type-ascriptions;

fn main(n : Nat) -> Nat {
	return if Nat::iszero(n) then <0x01> else <0x02>
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_MEMORY_ADDRESS/memory_in_if_2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_MEMORY_ADDRESS")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_NON_NULLARY_VARIANT_PATTERN/simple.st")
    func test_examples_bad_ERROR_UNEXPECTED_NON_NULLARY_VARIANT_PATTERN_simple_st_4165980c() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_NON_NULLARY_VARIANT_PATTERN/simple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_NON_NULLARY_VARIANT_PATTERN")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_NULLARY_VARIANT_PATTERN/simple.st")
    func test_examples_bad_ERROR_UNEXPECTED_NULLARY_VARIANT_PATTERN_simple_st_8393493c() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_NULLARY_VARIANT_PATTERN/simple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_NULLARY_VARIANT_PATTERN")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_NUMBER_OF_PARAMETERS_IN_LAMBDA/simple_unexpected_number.st")
    func test_examples_bad_ERROR_UNEXPECTED_NUMBER_OF_PARAMETERS_IN_LAMBDA_simple_unexpected_number_st_5c6b88e0() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_NUMBER_OF_PARAMETERS_IN_LAMBDA/simple_unexpected_number.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_NUMBER_OF_PARAMETERS_IN_LAMBDA")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/bad-sum-types-13.stella")
    func test_examples_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_bad_sum_types_13_stella_5d09ec8d() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/bad-sum-types-13.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/let_as.st")
    func test_examples_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_let_as_st_1cfe6fbd() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/let_as.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/letrec_asc.st")
    func test_examples_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_letrec_asc_st_1fa4794b() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/letrec_asc.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/try_cast_as.st")
    func test_examples_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_try_cast_as_st_34aea858() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/try_cast_as.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/try_catch_unepected_pattern.st")
    func test_examples_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_try_catch_unepected_pattern_st_b690d459() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/try_catch_unepected_pattern.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/try_catch_variant.st")
    func test_examples_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_try_catch_variant_st_510d07e9() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/try_catch_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/tuple_size.st")
    func test_examples_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_tuple_size_st_68c1ad5c() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/tuple_size.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_pattern.st")
    func test_examples_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_unexpected_pattern_st_2267baea() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_pattern.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_pattern_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_unexpected_pattern_reconstruct_st_4c2efe8c() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_pattern_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_variant_pattern.st")
    func test_examples_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_unexpected_variant_pattern_st_4e88bd0e() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_variant_pattern.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_variant_pattern_label.st")
    func test_examples_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_unexpected_variant_pattern_label_st_a5d7472e() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/unexpected_variant_pattern_label.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/variant_asc.st")
    func test_examples_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_variant_asc_st_0e74d475() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/variant_asc.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/variant_asc_2.st")
    func test_examples_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_variant_asc_2_st_25599c82() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/variant_asc_2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/variant_unexpected_pattern.st")
    func test_examples_bad_ERROR_UNEXPECTED_PATTERN_FOR_TYPE_variant_unexpected_pattern_st_10a80647() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_PATTERN_FOR_TYPE/variant_unexpected_pattern.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_RECORD/application_record.st")
    func test_examples_bad_ERROR_UNEXPECTED_RECORD_application_record_st_952cc1bd() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_RECORD/application_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_RECORD")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_RECORD/simple_unexpected_record.st")
    func test_examples_bad_ERROR_UNEXPECTED_RECORD_simple_unexpected_record_st_a7ace8ca() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> Nat {
  return { fst = 0, snd = true }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_RECORD/simple_unexpected_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_RECORD")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_RECORD/succ_record.st")
    func test_examples_bad_ERROR_UNEXPECTED_RECORD_succ_record_st_9aeac703() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> Nat {
  return succ({ a = 0, b = false })
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_RECORD/succ_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_RECORD")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_RECORD_FIELDS/return_record_with_missing_fields.st")
    func test_examples_bad_ERROR_UNEXPECTED_RECORD_FIELDS_return_record_with_missing_fields_st_d07c812d() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> { fst : Nat, snd : Bool } {
  return { fst = 0, snd = true, thd = true }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_RECORD_FIELDS/return_record_with_missing_fields.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_RECORD_FIELDS")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_REFERENCE/return_ref_from_non_reference_function.st")
    func test_examples_bad_ERROR_UNEXPECTED_REFERENCE_return_ref_from_non_reference_function_st_fe303e33() throws {
        let source = #"""
language core;
extend with #references;

fn main(n : Nat) -> Bool {
	return new (true)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_REFERENCE/return_ref_from_non_reference_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_REFERENCE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_REFERENCE/return_ref_from_non_reference_function_call_func.st")
    func test_examples_bad_ERROR_UNEXPECTED_REFERENCE_return_ref_from_non_reference_function_call_func_st_c8f0d4b5() throws {
        let source = #"""
language core;
extend with #references;

fn foo(n : Nat) -> Nat { return 0 }

fn main(n : Nat) -> Nat {
	return new (foo(0))
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_REFERENCE/return_ref_from_non_reference_function_call_func.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_REFERENCE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_REFERENCE/return_ref_from_non_reference_function_complex.st")
    func test_examples_bad_ERROR_UNEXPECTED_REFERENCE_return_ref_from_non_reference_function_complex_st_cb1c3152() throws {
        let source = #"""
language core;
extend with #references;

fn main(n : Nat) -> Nat {
	return new (succ(0))
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_REFERENCE/return_ref_from_non_reference_function_complex.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_REFERENCE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_SUBTYPE/bot.st")
    func test_examples_bad_ERROR_UNEXPECTED_SUBTYPE_bot_st_cb96cb9d() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_SUBTYPE/bot.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_SUBTYPE/error.st")
    func test_examples_bad_ERROR_UNEXPECTED_SUBTYPE_error_st_9ce49b0f() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_SUBTYPE/error.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_SUBTYPE/func.st")
    func test_examples_bad_ERROR_UNEXPECTED_SUBTYPE_func_st_b0ede283() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_SUBTYPE/func.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_SUBTYPE/func2.st")
    func test_examples_bad_ERROR_UNEXPECTED_SUBTYPE_func2_st_e3fae98d() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_SUBTYPE/func2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_SUBTYPE/list.st")
    func test_examples_bad_ERROR_UNEXPECTED_SUBTYPE_list_st_7787b0c9() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_SUBTYPE/list.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_SUBTYPE/record.st")
    func test_examples_bad_ERROR_UNEXPECTED_SUBTYPE_record_st_326921ec() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_SUBTYPE/record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_SUBTYPE/ref.st")
    func test_examples_bad_ERROR_UNEXPECTED_SUBTYPE_ref_st_47f0487b() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_SUBTYPE/ref.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_SUBTYPE/ref2.st")
    func test_examples_bad_ERROR_UNEXPECTED_SUBTYPE_ref2_st_bc022ce3() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_SUBTYPE/ref2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_SUBTYPE/sum.st")
    func test_examples_bad_ERROR_UNEXPECTED_SUBTYPE_sum_st_846687cc() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_SUBTYPE/sum.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_SUBTYPE/tuple.st")
    func test_examples_bad_ERROR_UNEXPECTED_SUBTYPE_tuple_st_394257fe() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_SUBTYPE/tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_SUBTYPE/tuple2.st")
    func test_examples_bad_ERROR_UNEXPECTED_SUBTYPE_tuple2_st_6656b6a6() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_SUBTYPE/tuple2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_SUBTYPE/variant.st")
    func test_examples_bad_ERROR_UNEXPECTED_SUBTYPE_variant_st_bab7693f() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_SUBTYPE/variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TUPLE/application_record.st")
    func test_examples_bad_ERROR_UNEXPECTED_TUPLE_application_record_st_3f4fbb9e() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TUPLE/application_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TUPLE/return_tuple_from_function.st")
    func test_examples_bad_ERROR_UNEXPECTED_TUPLE_return_tuple_from_function_st_493c2b3c() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> Nat {
  return {n, succ(n), true}
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TUPLE/return_tuple_from_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TUPLE/succ_record.st")
    func test_examples_bad_ERROR_UNEXPECTED_TUPLE_succ_record_st_f9129653() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> Nat {
  return succ({0, false })
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TUPLE/succ_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TUPLE_LENGTH/functional_type.st")
    func test_examples_bad_ERROR_UNEXPECTED_TUPLE_LENGTH_functional_type_st_203a1b9d() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TUPLE_LENGTH/functional_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE_LENGTH")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TUPLE_LENGTH/return_tuple_literal.st")
    func test_examples_bad_ERROR_UNEXPECTED_TUPLE_LENGTH_return_tuple_literal_st_27ae810d() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> {Nat, Nat} {
  return {n, succ(n), true}
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TUPLE_LENGTH/return_tuple_literal.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE_LENGTH")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TUPLE_LENGTH/subtyping_tuple.st")
    func test_examples_bad_ERROR_UNEXPECTED_TUPLE_LENGTH_subtyping_tuple_st_02889a7b() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TUPLE_LENGTH/subtyping_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE_LENGTH")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TUPLE_LENGTH/subtyping_tuple2.st")
    func test_examples_bad_ERROR_UNEXPECTED_TUPLE_LENGTH_subtyping_tuple2_st_b7fc2e7a() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TUPLE_LENGTH/subtyping_tuple2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE_LENGTH")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/apply_pair_2_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_apply_pair_2_reconstruct_st_0da2938e() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #pairs;

fn main(f : Nat) -> { Nat, auto } {
  return { f, f(0) }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/apply_pair_2_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/apply_pair_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_apply_pair_reconstruct_st_ff60b8c1() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #pairs;

fn main(n : Nat) -> Nat {
  return {0, false}(0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/apply_pair_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/asc.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_asc_st_bf456758() throws {
        let source = #"""
language core;

extend with #type-ascriptions;

fn main(n : Nat) -> Bool {
  return 0 as Nat
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/asc.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/asc_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_asc_reconstruct_st_1c14c7b6() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #type-ascriptions;

fn main(n : Nat) -> Bool {
  return 0 as Nat
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/asc_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/assignment_ref_ref_wrong_type.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_assignment_ref_ref_wrong_type_st_d9c59bd8() throws {
        let source = #"""
language core;
extend with #references, #sequencing;

fn main(n : &&Nat) -> Nat {
	return *n := true; succ(0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/assignment_ref_ref_wrong_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-let-6.stella")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_bad_let_6_stella_fa51dcca() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-let-6.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-pairs-16-reconstruction.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_bad_pairs_16_reconstruction_st_c7e05892() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #pairs;

fn main(x : Nat) -> Nat {
  return
    (fn(x : Nat) { return { { { x, x }, { x, x } }, { { x, Nat::iszero(x) }, { x, x } } } })(0).2.1
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-pairs-16-reconstruction.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-pairs-16.stella")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_bad_pairs_16_stella_c91d7fae() throws {
        let source = #"""
language core;

extend with #pairs;

fn main(x : Nat) -> Nat {
  return
    (fn(x : Nat) { return { { { x, x }, { x, x } }, { { x, Nat::iszero(x) }, { x, x } } } })(0).2.1
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-pairs-16.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-records-13.stella")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_bad_records_13_stella_075f1d00() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-records-13.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-records-6.stella")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_bad_records_6_stella_caccb14f() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-records-6.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-return-type-reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_bad_return_type_reconstruct_st_e86667fb() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-return-type-reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-return-type.stella")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_bad_return_type_stella_73bb0f87() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/bad-return-type.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/call_with_wrong_ref_type.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_call_with_wrong_ref_type_st_239cbbdb() throws {
        let source = #"""
language core;
extend with #references;

fn foo(n : &Nat) -> Nat { return *n }

fn main(n : Nat) -> Nat {
	return foo(new (true))
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/call_with_wrong_ref_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inl.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_check_inl_st_e67daa11() throws {
        let source = #"""
language core;

extend with #sum-types;


fn main(succeed : Bool) -> Nat+Bool {
  return inl(true)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inl.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inl_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_check_inl_reconstruct_st_08b8d6ff() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;


fn main(succeed : Bool) -> Nat+Bool {
  return inl(true)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inl_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inr.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_check_inr_st_e0b8975c() throws {
        let source = #"""
language core;

extend with #sum-types;


fn main(succeed : Bool) -> Nat+Bool {
  return inr(0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inr.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inr_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_check_inr_reconstruct_st_9d57b3f5() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;


fn main(succeed : Bool) -> Nat+Bool {
  return inr(0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/check_inr_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/cons_head.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_cons_head_st_3ed2cb72() throws {
        let source = #"""
language core;

extend with #lists;


fn main(n : Nat) -> [Nat] {
  return  cons(true, []);
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/cons_head.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/cons_head_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_cons_head_reconstruct_st_2a8f33e0() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;


fn main(n : Nat) -> [Nat] {
  return  cons(true, []);
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/cons_head_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/cons_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_cons_reconstruct_st_dae3771e() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;


fn main(n : Nat) -> Nat {
  return cons(0, []);
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/cons_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const2_no_forall.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_const2_no_forall_st_763d3490() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const2_no_forall.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_identity.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_const_identity_st_ff16c374() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_identity.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_succ.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_const_succ_st_4d1f2cc6() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_succ.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_tail.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_const_tail_st_f9599dc9() throws {
        let source = #"""
language core;

extend with #lists;


fn main(n : Nat) -> [Nat] {
  return  cons(0, [true]);
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_tail.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_tail_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_const_tail_reconstruct_st_03974e04() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;


fn main(n : Nat) -> auto {
  return  cons(0, [true]);
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/const_tail_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/deref_memory.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_deref_memory_st_fbf4a763() throws {
        let source = #"""
language core;
extend with #references, #type-ascriptions;

fn main(n : Nat) -> Nat {
	return *(<0x01> as &Bool)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/deref_memory.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/different_branches.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_different_branches_st_9921b95e() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Bool {
    return if true then false else 0
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/different_branches.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/different_branches_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_different_branches_reconstruct_st_9a90100d() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> auto {
    return if true then false else n
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/different_branches_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/false_return.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_false_return_st_3ecfc99a() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/false_return.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/false_return_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_false_return_reconstruct_st_46acc578() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/false_return_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fix_from_arg.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_fix_from_arg_st_ecea3e9d() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator;

fn main(f : fn(Nat) -> Bool) -> Nat {
  return fix(f);
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fix_from_arg.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fix_from_arg_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_fix_from_arg_reconstruct_st_c6f86798() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn main(f : fn(Nat) -> Bool) -> Nat {
  return fix(f);
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fix_from_arg_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fixpoint.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_fixpoint_st_e4cf93e6() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator;


fn main(n : Nat) -> Nat {
  return fix(fn(y : Nat) { return true });
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fixpoint.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fixpoint_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_fixpoint_reconstruct_st_6952c8aa() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;


fn main(n : Nat) -> auto {
  return fix(fn(y : Nat) { return true });
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/fixpoint_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/function_return.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_function_return_st_f1fb38f2() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/function_return.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/function_return_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_function_return_reconstruct_st_608ab8a1() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/function_return_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/head_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_head_reconstruct_st_4a779aa7() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(arg : Nat) -> auto {
  return (fn (a : auto) { return List::head(arg) })(0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/head_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/if_nat.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_if_nat_st_39d44126() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Bool {
    return if 0 then false else true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/if_nat.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/if_nat_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_if_nat_reconstruct_st_eac8f5c3() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> Bool {
    return if 0 then false else true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/if_nat_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_cons.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_infer_cons_st_0737213f() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_cons.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_cons_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_infer_cons_reconstruct_st_3eda7986() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_cons_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_fix.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_infer_fix_st_d6a2b0e5() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_fix.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_fix_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_infer_fix_reconstruct_st_9c8a0c7b() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_fix_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_match.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_infer_match_st_3560741b() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_match.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_match_list_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_infer_match_list_reconstruct_st_ee91d5de() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_match_list_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_match_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_infer_match_reconstruct_st_abcec6a9() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/infer_match_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/int_literal.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_int_literal_st_cbd51648() throws {
        let source = #"""
language core;

extend with #natural-literals;


fn main(n : Nat) -> Bool {
  return 5;
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/int_literal.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/int_literal_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_int_literal_reconstruct_st_481f58e2() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #natural-literals;


fn main(n : Nat) -> Bool {
  return 5;
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/int_literal_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/is_empty_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_is_empty_reconstruct_st_348dc1f5() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(arg : Nat) -> auto {
  return List::isempty(arg)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/is_empty_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/is_zero_bool.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_is_zero_bool_st_8cef76c2() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Bool {
    return if Nat::iszero(true) then false else true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/is_zero_bool.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/is_zero_bool_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_is_zero_bool_reconstruct_st_d753a01c() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> Bool {
    return if Nat::iszero(true) then false else true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/is_zero_bool_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/lambda_wrong_argument_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_lambda_wrong_argument_reconstruct_st_82f00c7b() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> (fn(Bool) -> Nat) {
    return fn(i : auto) { return i }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/lambda_wrong_argument_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/lambda_wrong_second_argument_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_lambda_wrong_second_argument_reconstruct_st_b838058c() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/lambda_wrong_second_argument_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/lamda_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_lamda_reconstruct_st_ae638223() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> Bool {
    return (fn(i : auto) { return i })(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/lamda_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/let_list.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_let_list_st_70925898() throws {
        let source = #"""
language core;
extend with #let-bindings;
extend with #lists;


fn main(n : Nat) -> Nat {
  return let y = [0, true] in y
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/let_list.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/let_list_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_let_list_reconstruct_st_87d53365() throws {
        let source = #"""
language core;
extend with #type-reconstruction, #let-bindings;
extend with #lists;


fn main(n : Nat) -> auto {
  return let y = [0, true] in y
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/let_list_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/my-ill-test-2.stella")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_my_ill_test_2_stella_0a289b05() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/my-ill-test-2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/my-mismatch.stella")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_my_mismatch_stella_7865ece7() throws {
        let source = #"""
language core;

fn main(x : Bool) -> fn(Nat) -> Nat {
    return if x then succ(0) else 0
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/my-mismatch.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/nested_function_params_shadowing.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_nested_function_params_shadowing_st_3876c631() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/nested_function_params_shadowing.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/no_nat_rec.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_no_nat_rec_st_bebd5729() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/no_nat_rec.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/no_nat_rec_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_no_nat_rec_reconstruct_st_d7d767a3() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/no_nat_rec_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/not_a_f_fix_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_not_a_f_fix_reconstruct_st_57600d90() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn main(n : Nat) -> Nat {
  return fix(true);
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/not_a_f_fix_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/panic_in_one_branch_bool_in_another.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_panic_in_one_branch_bool_in_another_st_903fd820() throws {
        let source = #"""
language core;
extend with #panic, #sequencing;

fn main(n : Nat) -> Nat {
  return if false then panic! else true; 0
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/panic_in_one_branch_bool_in_another.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/record_dot.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_record_dot_st_6900fb9e() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> Bool {
  return {x = 0, y = 0}.x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/record_dot.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/record_fields_order.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_record_fields_order_st_048fcfba() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/record_fields_order.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/recurstion_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_recurstion_reconstruct_st_83cdc220() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/recurstion_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/return_deref_wrong_ref.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_return_deref_wrong_ref_st_cba4825a() throws {
        let source = #"""
language core;
extend with #references;

fn foo(n : Nat) -> Nat { return 0 }

fn main(n : Nat) -> Bool {
	return *(new (foo(0)))
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/return_deref_wrong_ref.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/return_lambda_with_wrong_return.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_return_lambda_with_wrong_return_st_88d9b856() throws {
        let source = #"""
language core;

fn main(n : Nat) -> (fn(Nat) -> Bool) {
    return fn(i : Nat) { return i }
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/return_lambda_with_wrong_return.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/return_panic_from_lambda_as_bot.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_return_panic_from_lambda_as_bot_st_a75314e3() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/return_panic_from_lambda_as_bot.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/sequencing_non_unit_type1.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_sequencing_non_unit_type1_st_fcb2e5c6() throws {
        let source = #"""
language core;
extend with #sequencing;

fn main(n : Nat) -> Nat {
	return (fn(a : Nat) { return 0 }) (0); 0
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/sequencing_non_unit_type1.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/sequencing_non_unit_type2.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_sequencing_non_unit_type2_st_77e7ea03() throws {
        let source = #"""
language core;
extend with #sequencing, #unit-type;

fn main(n : Nat) -> Nat {
	return (fn(a : Nat) { return unit }) (0); (fn(a : Nat) { return a }) (0); 0
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/sequencing_non_unit_type2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/sequencing_wrong_return_type.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_sequencing_wrong_return_type_st_d5703a0f() throws {
        let source = #"""
language core;
extend with #sequencing, #unit-type;

fn main(n : Nat) -> Bool {
	return (fn(a : Nat) { return unit }) (0); (fn(a : Nat) { return a }) (0); 0
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/sequencing_wrong_return_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_simple_ascription_st_cd916aa6() throws {
        let source = #"""
language core;
extend with #type-ascriptions;


fn main(n : Nat) -> Bool {
  return 0 as Bool
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription2.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_simple_ascription2_st_36701962() throws {
        let source = #"""
language core;
extend with #type-ascriptions;

fn main(n : Nat) -> Nat {
  return 0 as Bool
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription2_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_simple_ascription2_reconstruct_st_d1c13462() throws {
        let source = #"""
language core;
extend with #type-reconstruction, #type-ascriptions;

fn main(n : Nat) -> Nat {
  return 0 as Bool
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription2_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_simple_ascription_reconstruct_st_7d6dbbf2() throws {
        let source = #"""
language core;
extend with #type-reconstruction, #type-ascriptions;


fn main(n : Nat) -> Bool {
  return 0 as Bool
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_ascription_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_let.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_simple_let_st_f9a44c82() throws {
        let source = #"""
language core;
extend with #let-bindings;

fn main(n : Nat) -> Nat {
  return let t = true in t
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_let.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_let_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_simple_let_reconstruct_st_4ffc9433() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #let-bindings;

fn main(n : Nat) -> Nat {
  return let t = true in t
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_let_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_list_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_simple_list_reconstruct_st_e1cd2c9a() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(arg : auto) -> Nat {
  return [arg, 0]
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/simple_list_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/square_bad_add_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_square_bad_add_reconstruct_st_63b2b08b() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/square_bad_add_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/square_bad_square_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_square_bad_square_reconstruct_st_011cd73e() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/square_bad_square_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/succ_true.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_succ_true_st_5404e364() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Bool {
    return succ(succ(true))
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/succ_true.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/succ_true_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_succ_true_reconstruct_st_dfe18024() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> Bool {
    return succ(succ(true))
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/succ_true_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/tail_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_tail_reconstruct_st_49936a1a() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(arg : Nat) -> auto {
  return (fn (a : auto) { return List::tail(arg) })(0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/tail_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/test-1.stella")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_test_1_stella_c4ed7275() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/test-1.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/test-1_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_test_1_reconstruct_st_5c53deaf() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/test-1_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/throw_invalid_type.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_throw_invalid_type_st_74b73f5d() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals, #exception-type-declaration;

exception type = Nat

fn main(n : Nat) -> Nat {
  return throw(true)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/throw_invalid_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/try_cast_as_expr.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_try_cast_as_expr_st_aa26a2ac() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/try_cast_as_expr.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/try_cast_as_fallback.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_try_cast_as_fallback_st_63d364b8() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/try_cast_as_fallback.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/tuple_dot.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_tuple_dot_st_8600c4d2() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> Bool {
  return {0, 0}.1
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/tuple_dot.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected-type-for-expression-1.stella")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_type_for_expression_1_stella_c46ba625() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected-type-for-expression-1.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_application.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_application_st_712b67e2() throws {
        let source = #"""
language core;

fn main(f : fn(Bool) -> Bool) -> Bool {
    return f(0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_application.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_application_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_application_reconstruct_st_fca1f42d() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(f : fn(Bool) -> auto) -> auto {
    return f(0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_application_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_inl_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_inl_reconstruct_st_6356dc5e() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;

fn main(input : Bool) -> Nat {
  return inl(0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_inl_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_inr_reconstruct.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_inr_reconstruct_st_ef6988d3() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;

fn main(input : Bool) -> Nat {
  return inr(0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_inr_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_isempty.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_isempty_st_401aaa31() throws {
        let source = #"""
language core;

extend with #lists;
extend with #type-ascriptions;

fn main(n : Nat) -> Nat {
    return List::isempty([0] as [Nat])
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_isempty.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_iszero.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_iszero_st_20d91e41() throws {
        let source = #"""
language core;


fn main(n : Nat) -> Nat {
    return Nat::iszero(0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_iszero.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_label_type.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_label_type_st_ee05b853() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_label_type.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_multiparam.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_multiparam_st_d3d3a169() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_multiparam.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_s_rec.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_s_rec_st_26d32007() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_s_rec.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_tail.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_tail_st_2d49ede2() throws {
        let source = #"""
language core;

extend with #lists;
extend with #type-ascriptions;

fn main(n : Nat) -> Bool {
    return List::tail([0] as [Nat])
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_tail.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_unit.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_unit_st_ecefc166() throws {
        let source = #"""
language core;
extend with #unit-type;

fn main(_ : Nat) -> Nat {
    return unit
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_unit.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_zero_param.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unexpected_zero_param_st_de5f1311() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unexpected_zero_param.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unref_bool.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_unref_bool_st_8426d944() throws {
        let source = #"""
language core;
extend with #references;

fn main(n : Nat) -> Nat {
	return *(true)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/unref_bool.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/variant_fields_order.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION_variant_fields_order_st_c4bad0d7() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION/variant_fields_order.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_PARAMETER/recursion.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_PARAMETER_recursion_st_dcb05a62() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_PARAMETER/recursion.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_PARAMETER")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_PARAMETER/return_lambda_with_wrong_argument.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_PARAMETER_return_lambda_with_wrong_argument_st_6ebdc139() throws {
        let source = #"""
language core;

fn main(n : Nat) -> (fn(Bool) -> Nat) {
    return fn(i : Nat) { return i }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_PARAMETER/return_lambda_with_wrong_argument.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_PARAMETER")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_TYPE_FOR_PARAMETER/return_lambda_with_wrong_second_argument.st")
    func test_examples_bad_ERROR_UNEXPECTED_TYPE_FOR_PARAMETER_return_lambda_with_wrong_second_argument_st_0929c39d() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_TYPE_FOR_PARAMETER/return_lambda_with_wrong_second_argument.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_PARAMETER")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_VARIANT/simple_unexpected_variant.st")
    func test_examples_bad_ERROR_UNEXPECTED_VARIANT_simple_unexpected_variant_st_23e2bf1b() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_VARIANT/simple_unexpected_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_VARIANT")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_VARIANT/unexpected-variant-3.stella")
    func test_examples_bad_ERROR_UNEXPECTED_VARIANT_unexpected_variant_3_stella_756de309() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_VARIANT/unexpected-variant-3.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_VARIANT")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_VARIANT_LABEL/simple_unexpected_label.st")
    func test_examples_bad_ERROR_UNEXPECTED_VARIANT_LABEL_simple_unexpected_label_st_5c4f7e54() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_VARIANT_LABEL/simple_unexpected_label.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_VARIANT_LABEL")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_VARIANT_LABEL/subtyping_variant.st")
    func test_examples_bad_ERROR_UNEXPECTED_VARIANT_LABEL_subtyping_variant_st_430574cd() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_VARIANT_LABEL/subtyping_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_VARIANT_LABEL")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_VARIANT_LABEL/unexpected_nullary_label.st")
    func test_examples_bad_ERROR_UNEXPECTED_VARIANT_LABEL_unexpected_nullary_label_st_defa48a7() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #variants, #nullary-variant-labels;

fn main(n : Nat) -> <| a : Nat, b, c |> {
  return <| e |>
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/bad/ERROR_UNEXPECTED_VARIANT_LABEL/unexpected_nullary_label.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_VARIANT_LABEL")
        }
    }

    @Test("examples/bad/ERROR_UNEXPECTED_VARIANT_LABEL/variant_asc.st")
    func test_examples_bad_ERROR_UNEXPECTED_VARIANT_LABEL_variant_asc_st_94fe113d() throws {
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
            sourceName: "examples/bad/ERROR_UNEXPECTED_VARIANT_LABEL/variant_asc.st",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_VARIANT_LABEL")
        }
    }

    @Test("examples/bot_tests/1.txt")
    func test_examples_bot_tests_1_txt_5dccc9a6() throws {
        let source = #"""
language core;

extend with #nullary-functions;
extend with #multiparameter-functions;
extend with #structural-patterns;
extend with #pattern-ascriptions;
extend with #nested-function-declarations;
extend with #unit-type;
extend with #structural-subtyping;
extend with #top-type;
extend with #bottom-type;

extend with #references;
extend with #lists;
extend with #sum-types;
extend with #panic;
extend with #exceptions;
extend with #exception-type-declaration;

extend with #ambiguous-type-as-bottom;

exception type = Nat

fn ambiguity-panic() -> Unit {
  return match panic! { _ as Bot => unit }
}

fn ambiguity-throw() -> Unit {
  return match throw(0) { _ as Bot => unit }
}

fn ambiguity-inl() -> Unit {
  return match inl(0) { _ as Nat + Bot => unit }
}

fn ambiguity-inr() -> Unit {
  return match inr(0) { _ as Bot + Nat => unit }
}

fn ambiguity-empty-list() -> Unit {
  return match [] { _ as [Bot] => unit }
}

fn main(x : Nat) -> Nat {
  return x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bot_tests/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/bot_tests/13.txt")
    func test_examples_bot_tests_13_txt_b0dc5796() throws {
        let source = #"""
language core;

extend with #nullary-functions;
extend with #multiparameter-functions;
extend with #structural-patterns;
extend with #pattern-ascriptions;
extend with #nested-function-declarations;
extend with #unit-type;

extend with #exceptions;
extend with #exception-type-declaration;

exception type = Nat

fn throw-arg-must-be-nat() -> Unit {
  fn fails-otherwise(x : Bool) -> Unit {
    return throw(x)
  }

  fn passes-when-nat(x : Nat) -> Unit {
    return throw(x)
  }

  return unit
}

fn main(x : Nat) -> Nat {
  return x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bot_tests/13.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/bot_tests/2.txt")
    func test_examples_bot_tests_2_txt_16734b72() throws {
        let source = #"""
language core;
extend with #ambiguous-type-as-bottom, #sum-types, #bottom-type;

fn main(n : Nat) -> Bot + Nat {
  return (fn (x : Nat) {
    return inr(x)
  })(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/bot_tests/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/core_basics/application.txt")
    func test_examples_core_basics_application_txt_3405340b() throws {
        let source = #"""
language core;

fn increment_twice(n : Nat) -> Nat {
  return succ(succ(0))
}

fn main(r : Nat) -> Nat {
  return increment_twice(r)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/core_basics/application.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/core_basics/application_2args.txt")
    func test_examples_core_basics_application_2args_txt_021bc851() throws {
        let source = #"""
language core;
extend with #sequencing;

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
            sourceName: "examples/core_basics/application_2args.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/core_basics/arith_basic.txt")
    func test_examples_core_basics_arith_basic_txt_cef3e0a1() throws {
        let source = #"""
language core;
fn main (n : Nat) -> Nat
{
  return succ (succ (5))
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/core_basics/arith_basic.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/core_basics/let_basic.txt")
    func test_examples_core_basics_let_basic_txt_e072e7d7() throws {
        let source = #"""
language core;
extend with #let-bindings;

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
    return
        let x = b in twice(Bool::not)(x)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/core_basics/let_basic.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/core_basics/pred_cover_if.txt")
    func test_examples_core_basics_pred_cover_if_txt_d7c82eb1() throws {
        let source = #"""
language core;
extend with #natural-literals,#predecessor;

fn main(n : Nat) -> Nat
{
    return Nat::pred(if Nat::iszero(0) then 0 else succ(0))
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/core_basics/pred_cover_if.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/core_basics/record_basic.txt")
    func test_examples_core_basics_record_basic_txt_60c22cf4() throws {
        let source = #"""
language core;
extend with #records;

fn Bool::not(b : Bool) -> Bool {
    return
        if b then false else true
}

fn twice(f : fn(Bool) -> Bool) -> (fn(Bool) -> Bool) {
    return fn(x : Bool) {
        return f(f(x))
    }
}

fn main(b : Nat) -> Nat {
    return
        {a = true, c = b}.c
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/core_basics/record_basic.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/core_basics/tuple_basic.txt")
    func test_examples_core_basics_tuple_basic_txt_b311d142() throws {
        let source = #"""
language core;
extend with #tuples;

fn Bool::not(b : Bool) -> Bool {
    return
        if b then false else true
}

fn twice(f : fn(Bool) -> Bool) -> (fn(Bool) -> Bool) {
    return fn(x : Bool) {
        return f(f(x))
    }
}

fn main(b : Nat) -> Bool {
    return
        {true, b}.1
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/core_basics/tuple_basic.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/core_error/check_nat_for_bool.txt")
    func test_examples_core_error_check_nat_for_bool_txt_b2c61dd5() throws {
        let source = #"""
language core;
extend with #type-ascriptions;

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
    return 0 as Bool
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/core_error/check_nat_for_bool.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/core_error/nat_in_if_cond.txt")
    func test_examples_core_error_nat_in_if_cond_txt_36644abd() throws {
        let source = #"""
language core;
extend with #natural-literals;

fn main(n : Nat) -> Nat
{
    return if n then succ(0) else 0
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/core_error/nat_in_if_cond.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_err/1.txt")
    func test_examples_error_err_1_txt_94013e8a() throws {
        let source = #"""
language core;
extend with #natural-literals,#exceptions,#arithmetic-operators,#exception-type-declaration,#comparison-operators,#multiparameter-functions;

exception type = Nat

fn main( x : Nat) -> Bool {
    return throw(true)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_err/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_err/11.txt")
    func test_examples_error_err_11_txt_a3941f72() throws {
        let source = #"""
language core;

extend with #exception-type-declaration;
extend with #exceptions;
extend with #open-variant-exceptions;
extend with #multiparameter-functions;
extend with #comparison-operators;
extend with #variants;
extend with #natural-literals;

exception variant a : Bool
exception variant b : Bool

exception type = Nat

fn div(x : Nat, y : Nat) -> Bool {
  return if y == 0 then
    throw(<| a = true |>)
  else
    x == 0
}

fn main(n : Nat) -> Bool {
  return try { div(n, 0) } catch {
    <| b = v |> => true
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_err/11.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_err/12.txt")
    func test_examples_error_err_12_txt_b5ebf6fd() throws {
        let source = #"""
language core;

extend with #exceptions;
extend with #open-variant-exceptions;
extend with #multiparameter-functions;
extend with #comparison-operators;
extend with #variants;
extend with #natural-literals;

exception variant a : Bool
exception variant b : Bool

fn div(x : Nat, y : Nat) -> Bool {
  return if y == 0 then
    throw(<| a = true |>)
  else
    x == 0
}

fn main(n : Nat) -> Bool {
  return try { div(n, 0) } catch {
    <| b = v |> => v
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_err/12.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_err/2.txt")
    func test_examples_error_err_2_txt_2a70da90() throws {
        let source = #"""
language core;
extend with #natural-literals,#exceptions,#arithmetic-operators,#exception-type-declaration,#comparison-operators,#multiparameter-functions;

exception type = Nat

fn main(x : Nat) -> Nat {
    return try { throw(0) } catch { e => true }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_err/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_err/3.txt")
    func test_examples_error_err_3_txt_c3c838f5() throws {
        let source = #"""
language core;
extend with #natural-literals,#exceptions,#arithmetic-operators,#exception-type-declaration,#comparison-operators,#multiparameter-functions;

exception type = Bool

fn main(x : Nat) -> Bool {
    return try { 42 } catch { e => e }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_err/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_err/4.txt")
    func test_examples_error_err_4_txt_38f60891() throws {
        let source = #"""
language core;
extend with #natural-literals,#exceptions,#arithmetic-operators,#exception-type-declaration,#comparison-operators,#multiparameter-functions;

exception type = Nat

fn main(x : Nat) -> Nat {
    return try { throw(0) } catch { x => y }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_err/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_err/5.txt")
    func test_examples_error_err_5_txt_0b627143() throws {
        let source = #"""
language core;
extend with #natural-literals,#exceptions,#arithmetic-operators,#exception-type-declaration,#comparison-operators,#multiparameter-functions;

exception type = Nat

fn main(x : Bool) -> Nat {
    return if x then
        throw(0)
    else
        throw(true)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_err/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_err/6.txt")
    func test_examples_error_err_6_txt_62c0b435() throws {
        let source = #"""
language core;

extend with #nullary-functions;
extend with #multiparameter-functions;
extend with #structural-patterns;
extend with #pattern-ascriptions;
extend with #nested-function-declarations;
extend with #unit-type;

extend with #exceptions;
extend with #exception-type-declaration;

fn throw-requires-decl(x : Unit) -> Unit {
  return throw(x)
}

fn try-catch-requires-decl(x : Unit) -> Unit {
  return try {
    x
  } catch {
    y => y
  }
}

fn try-with-does-not-require-decl(x : Unit) -> Unit {
  return try { x } with { x }
}

fn main(x : Nat) -> Nat {
  return x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_err/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_err/8.txt")
    func test_examples_error_err_8_txt_f0accec9() throws {
        let source = #"""
language core;

extend with #nullary-functions;
extend with #multiparameter-functions;
extend with #structural-patterns;
extend with #pattern-ascriptions;
extend with #nested-function-declarations;
extend with #unit-type;

extend with #exceptions;

fn throw-requires-decl(x : Unit) -> Unit {

  return throw(x)
}

fn try-catch-requires-decl(x : Unit) -> Unit {
  return try {
    x
  } catch {

    y => y
  }
}

fn try-with-does-not-require-decl(x : Unit) -> Unit {

  return try { x } with { x }
}

fn main(x : Nat) -> Nat {
  return x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_err/8.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_err/9.txt")
    func test_examples_error_err_9_txt_aa66bbe0() throws {
        let source = #"""
language core;

extend with #nullary-functions;
extend with #multiparameter-functions;
extend with #structural-patterns;
extend with #pattern-ascriptions;
extend with #nested-function-declarations;
extend with #unit-type;

extend with #exceptions;
extend with #open-variant-exceptions;

fn throw-requires-decl(x : Unit) -> Unit {

  return throw(x)
}

fn try-catch-requires-decl(x : Unit) -> Unit {
  return try {
    x
  } catch {

    y => y
  }
}

fn try-with-does-not-require-decl(x : Unit) -> Unit {

  return try { x } with { x }
}

fn main(x : Nat) -> Nat {
  return x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_err/9.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_succ/1.txt")
    func test_examples_error_succ_1_txt_74158664() throws {
        let source = #"""
language core;

extend with #panic, #pairs, #fixpoint-combinator;


fn dec( n : Nat ) -> Nat{ return Nat::rec(n, {0, 0},
    fn(k : Nat) {
      return fn(p : {Nat, Nat}) {
        return { succ(p.1), p.1 }
      }
}).2 }


fn sub(n : Nat) -> fn(Nat) -> Nat {
  return fn(m : Nat) {
     return Nat::rec(m, n, fn(k : Nat) { return dec })
} }


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
            sourceName: "examples/error_succ/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_succ/2.txt")
    func test_examples_error_succ_2_txt_84b00f81() throws {
        let source = #"""
language core;

extend with #panic, #pairs, #fixpoint-combinator,#sum-types,#comparison-operators,#variants,#unit-type;


fn dec( n : Nat ) -> Nat{ return Nat::rec(n, {0, 0},
    fn(k : Nat) {
      return fn(p : {Nat, Nat}) {
        return { succ(p.1), p.1 }
      }
}).2 }


fn sub(n : Nat) -> fn(Nat) -> Nat {
  return fn(m : Nat) {
     return Nat::rec(m, n, fn(k : Nat) { return dec })
} }


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

fn main(n : Nat) -> Nat + Unit {
   return if (n  == 0) then inl(div(n)(n)) else inr(panic!)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_succ/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_succ/3.txt")
    func test_examples_error_succ_3_txt_671da075() throws {
        let source = #"""
language core;
extend with #natural-literals,#exceptions,#arithmetic-operators,#exception-type-declaration,#comparison-operators,#multiparameter-functions;

exception type = Nat

fn div(x : Nat, y : Nat) -> Nat {
  return if y == 0 then
    throw(0)
  else
     x
}

fn main(n : Nat) -> Nat {
  return try { div(n, 0) } catch { e => e }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_succ/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_succ/4.txt")
    func test_examples_error_succ_4_txt_e295ab2c() throws {
        let source = #"""
language core;
extend with #exception-type-declaration,#natural-literals,#exceptions,#arithmetic-operators,#comparison-operators,#multiparameter-functions;

fn div(x : Nat, y : Nat) -> Nat {
  return if y == 0 then
    throw(0)

  else
     x
}

fn main(n : Nat) -> Nat {
  return div(n, 0)
}

exception type = Nat


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_succ/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_succ/5.txt")
    func test_examples_error_succ_5_txt_59c67f76() throws {
        let source = #"""
language core;
extend with #exception-type-declaration,#natural-literals,#exceptions,#arithmetic-operators,#comparison-operators,#multiparameter-functions;

exception type = Nat

fn div(x : Nat, y : Nat) -> Nat {
  return if y == 0 then
    throw(0)

  else
     x
}

fn main(n : Nat) -> Nat {
  return div(n, 0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_succ/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_succ/6.txt")
    func test_examples_error_succ_6_txt_0906035d() throws {
        let source = #"""
language core;

extend with #nullary-functions;
extend with #multiparameter-functions;
extend with #structural-patterns;
extend with #pattern-ascriptions;
extend with #nested-function-declarations;
extend with #unit-type;

extend with #exceptions;
extend with #exception-type-declaration;

exception type = Nat
exception type = Bool

fn main(x : Nat) -> Nat {
  return x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_succ/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_succ/7.txt")
    func test_examples_error_succ_7_txt_dcc55a2c() throws {
        let source = #"""
language core;

extend with #exceptions;
extend with #open-variant-exceptions;
extend with #multiparameter-functions;
extend with #comparison-operators;
extend with #variants;
extend with #natural-literals;

exception variant a : Bool
exception variant b : Bool

fn div(x : Nat, y : Nat) -> Bool {
  return if y == 0 then
    throw(<| a = true |>)
  else
    x == 0
}

fn main(n : Nat) -> Bool {
  return try { div(n, 0) } catch {
    <| b = v |> => v
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_succ/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_succ/8.txt")
    func test_examples_error_succ_8_txt_564c42fe() throws {
        let source = #"""
language core;

extend with #exceptions;
extend with #exception-type-declaration;


extend with #open-variant-exceptions;

fn main(x : Nat) -> Nat {
  return x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_succ/8.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/error_succ/9.txt")
    func test_examples_error_succ_9_txt_a78d9a2a() throws {
        let source = #"""
language core;

extend with #nullary-functions;
extend with #multiparameter-functions;
extend with #structural-patterns;
extend with #pattern-ascriptions;
extend with #nested-function-declarations;
extend with #unit-type;

extend with #exceptions;
extend with #exception-type-declaration;

exception type = Nat

fn catch-arm-pat-may-be-non-exhaustive() -> Unit {
  return try { unit } catch { 0 => unit }
}

fn main(x : Nat) -> Nat {
  return x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/error_succ/9.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/fix_err/1.txt")
    func test_examples_fix_err_1_txt_9a0d1890() throws {
        let source = #"""
language core;
extend with #variants, #lists,#unit-type,#natural-literals,#structural-patterns,#fixpoint-combinator;


fn main(_ : Nat) -> Nat {
  return fix (0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/fix_err/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/fix_err/2.txt")
    func test_examples_fix_err_2_txt_d7b2290b() throws {
        let source = #"""
language core;
extend with #variants, #lists,#unit-type,#natural-literals,#structural-patterns,#fixpoint-combinator;


fn main(_ : Nat) -> Nat {
  return fix (true)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/fix_err/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/fix_err/3.txt")
    func test_examples_fix_err_3_txt_d82c8ad2() throws {
        let source = #"""
language core;
extend with #variants,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> Nat {
  return fix (fn (x : Nat, y : Nat) { return x + y })
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/fix_err/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/fix_err/4.txt")
    func test_examples_fix_err_4_txt_0154d793() throws {
        let source = #"""
language core;
extend with #variants,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> Nat {
  return fix (fn (x : Bool, y : Bool) { return x })
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/fix_err/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/fix_err/5.txt")
    func test_examples_fix_err_5_txt_ba0a7c71() throws {
        let source = #"""
language core;
extend with #variants,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> Bool {
  return fix (fn (x : Nat) { return true })
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/fix_err/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/fix_err/6.txt")
    func test_examples_fix_err_6_txt_4ca44d53() throws {
        let source = #"""
language core;
extend with #variants,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> Nat {
  return fix (fn (b : Bool) { return 0 })
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/fix_err/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/fix_err/7.txt")
    func test_examples_fix_err_7_txt_0cb088b3() throws {
        let source = #"""
language core;
extend with #variants,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> Nat {
  return fix (fix (fn (x : Nat) { return x }))
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/fix_err/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/fix_succ/1.txt")
    func test_examples_fix_succ_1_txt_75be5de7() throws {
        let source = #"""
language core;
extend with #variants, #lists,#unit-type,#natural-literals,#structural-patterns,#fixpoint-combinator;

fn idnat(n : Nat) -> Nat { return n }

fn main(_ : Nat) -> Nat {
  return fix (idnat)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/fix_succ/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/fix_succ/2.txt")
    func test_examples_fix_succ_2_txt_f92c37a9() throws {
        let source = #"""
language core;
extend with #variants, #lists,#unit-type,#natural-literals,#structural-patterns,#fixpoint-combinator;

fn main(_ : Nat) -> Nat {
  return fix (fn (n : Nat) { return succ(n) })
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/fix_succ/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/fix_succ/3.txt")
    func test_examples_fix_succ_3_txt_2a092430() throws {
        let source = #"""
language core;
extend with #variants, #lists,#unit-type,#natural-literals,#structural-patterns,#fixpoint-combinator;


fn main(_ : Nat) -> [Nat] {
  return fix (fn (xs : [Nat]) { return xs })
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/fix_succ/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/guide/try_catch_variant.st")
    func test_examples_guide_try_catch_variant_st_e0f87a3d() throws {
        let source = #"""
language core;
extend with #exceptions, #open-variant-exceptions, #variants, #structural-patterns, #open-variant-exceptions;

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
            sourceName: "examples/guide/try_catch_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/let_succ/1.txt")
    func test_examples_let_succ_1_txt_22f164b9() throws {
        let source = #"""
language core;

extend with
  #unit-type,
  #references,
  #arithmetic-operators,
  #sequencing,
  #natural-literals;

extend with #let-bindings;


fn square(n : Nat) -> Nat {
  return Nat::rec(n, 0, fn(i : Nat) {
      return fn(r : Nat) {

        return let double = succ(i) in succ(double)
      }
  })
}

fn main(n : Nat) -> Nat {
  return square(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/let_succ/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/let_succ/2.txt")
    func test_examples_let_succ_2_txt_6ef84c6e() throws {
        let source = #"""
language core;

extend with
  #unit-type,
  #references,
  #arithmetic-operators,
  #sequencing,
  #natural-literals;

extend with #let-bindings;

fn Nat::average(n : Nat) -> fn(Nat) -> Nat {
  return fn(m : Nat) {
    return let sum = succ(m) in
           let two = succ(succ(sum)) in

           succ(two)
  }
}


fn main(n : Nat) -> Nat {
  return Nat::average(n)(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/let_succ/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/let_succ/3.txt")
    func test_examples_let_succ_3_txt_be959f95() throws {
        let source = #"""
language core;

extend with #let-bindings;
extend with #comparison-operators;

fn square(n : Nat) -> Nat {
  return Nat::rec(n, 0, fn(i : Nat) {
      return fn(r : Nat) {

        return let double = succ(i) in succ(double)
      }
  })
}

fn isRightTriangle(a : Nat) -> fn(Nat) -> fn(Nat) -> Bool {
  return let a2 = square(a) in fn(b : Nat) {
    return let b2 = square(b) in
    fn (c : Nat) {
        return let c2 = square(c) in
               let sum = succ(b2) in
                 sum == c2
    }
  }
}

fn main(_ : Nat) -> Bool {
  return let one = succ(0) in
         let two = succ(one) in
           isRightTriangle(one)(one)(two)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/let_succ/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/letrec_succ/1.txt")
    func test_examples_letrec_succ_1_txt_af372051() throws {
        let source = #"""
language core;
extend with #natural-literals,#pattern-ascriptions,#let-patterns,#letrec-bindings,#structural-patterns,#fixpoint-combinator;

fn main(_ : Nat) -> Nat {
  return letrec fact as fn(Nat) -> Nat = fn (n : Nat) {
      return match n {
        0 => 1
      | succ(m) => fact(m)
      }
    }
  in
    fact(5)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/letrec_succ/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/letrec_succ/2.txt")
    func test_examples_letrec_succ_2_txt_9b386b3e() throws {
        let source = #"""
language core;
extend with #natural-literals,#pattern-ascriptions,#let-patterns,#letrec-bindings,#structural-patterns,#fixpoint-combinator;

fn main(_ : Nat) -> Nat {
  return letrec fact = fn (n : Nat) {
      return match n {
        0 => 1
      | succ(m) => fact(m)
      }
    }
  in
    fact(5)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/letrec_succ/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/list_err/1.txt")
    func test_examples_list_err_1_txt_bcd48e92() throws {
        let source = #"""
language core;
extend with #variants,#type-ascriptions,#let-bindings,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> [Nat] {
  return let xs = [] in xs
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/list_err/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/list_err/2.txt")
    func test_examples_list_err_2_txt_b3b40044() throws {
        let source = #"""
language core;
extend with #variants,#type-ascriptions,#let-bindings,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> [Nat] {
  return let xs = cons(true, [0, 1]) in
  xs
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/list_err/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/list_err/3.txt")
    func test_examples_list_err_3_txt_9bd6a189() throws {
        let source = #"""
language core;
extend with #variants,#type-ascriptions,#let-bindings,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> [Nat] {
  return let xs = cons(0, 1) in
  xs
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/list_err/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/list_err/4.txt")
    func test_examples_list_err_4_txt_d28cfc14() throws {
        let source = #"""
language core;
extend with #variants,#type-ascriptions,#let-bindings,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> [Nat] {
  return let xs = [] in
  xs
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/list_err/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/list_err/5.txt")
    func test_examples_list_err_5_txt_ee3947f4() throws {
        let source = #"""
language core;
extend with #variants,#type-ascriptions,#let-bindings,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> [Nat] {
  return let xs = [[0], [true]] in
  xs
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/list_err/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/list_succ/1.txt")
    func test_examples_list_succ_1_txt_5febfcf1() throws {
        let source = #"""
language core;
extend with #variants,#type-ascriptions,#let-bindings,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> [Nat] {
  return let xs = [] as [Nat] in xs
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/list_succ/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/list_succ/2.txt")
    func test_examples_list_succ_2_txt_98c28a16() throws {
        let source = #"""
language core;
extend with #variants,#type-ascriptions,#let-bindings,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> [Nat] {
  return let xs = [0, 1, succ(1)] in
  xs
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/list_succ/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/list_succ/3.txt")
    func test_examples_list_succ_3_txt_45fd42ae() throws {
        let source = #"""
language core;
extend with #variants,#type-ascriptions,#let-bindings,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> [Nat] {
  return let xs = cons(0, [1, 2, 3]) in
  xs

}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/list_succ/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/list_succ/4.txt")
    func test_examples_list_succ_4_txt_9b71c43a() throws {
        let source = #"""
language core;
extend with #variants,#type-ascriptions,#let-bindings,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> [Bool] {
  return let ys = cons(true, []) as [Bool] in
  ys
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/list_succ/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/list_succ/5.txt")
    func test_examples_list_succ_5_txt_3a7c68f0() throws {
        let source = #"""
language core;
extend with #variants,#type-ascriptions,#let-bindings,#arithmetic-operators,#lists,#unit-type,#natural-literals,#structural-patterns,#multiparameter-functions,#fixpoint-combinator;


fn main(_ : Nat) -> [[Nat]] {
  return let zs = [[0], [1, 2], [2]] in
  zs
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/list_succ/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/match_top_bot_ref_var/1.txt")
    func test_examples_match_top_bot_ref_var_1_txt_365c73ac() throws {
        let source = #"""
language core;

extend with #top-type, #structural-patterns, #natural-literals;

fn main( x : Top ) -> Nat {
  return match x {
    true => 1
  }
}







"""#
        let program = try Program.parser.run(
            sourceName: "examples/match_top_bot_ref_var/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/match_top_bot_ref_var/2.txt")
    func test_examples_match_top_bot_ref_var_2_txt_e3422fc7() throws {
        let source = #"""
language core;

extend with #top-type, #structural-patterns, #natural-literals;

fn main( x : Top ) -> Nat {
  return match x {
    x => 1
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/match_top_bot_ref_var/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/match_top_bot_ref_var/3.txt")
    func test_examples_match_top_bot_ref_var_3_txt_0503e03b() throws {
        let source = #"""
language core;

extend with #bottom-type, #top-type, #structural-patterns, #natural-literals;

fn main(x : Bot) -> Nat {
  return match x {
    unit => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/match_top_bot_ref_var/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/match_top_bot_ref_var/4.txt")
    func test_examples_match_top_bot_ref_var_4_txt_32102272() throws {
        let source = #"""
language core;

extend with #references, #top-type, #structural-patterns, #natural-literals;

fn main(x : &Nat) -> Nat {
  return match x {
    unit => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/match_top_bot_ref_var/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/match_top_bot_ref_var/5.txt")
    func test_examples_match_top_bot_ref_var_5_txt_fc793e1f() throws {
        let source = #"""
language core;

extend with #bottom-type, #top-type, #structural-patterns, #natural-literals;

fn main(x : Bot) -> Nat {
  return match x {
    x => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/match_top_bot_ref_var/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/match_top_bot_ref_var/6.txt")
    func test_examples_match_top_bot_ref_var_6_txt_8683b045() throws {
        let source = #"""
language core;

extend with #references, #top-type, #structural-patterns, #natural-literals;

fn main(x : &Nat) -> Nat {
  return match x {
    x => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/match_top_bot_ref_var/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/match_top_bot_ref_var/7.txt")
    func test_examples_match_top_bot_ref_var_7_txt_bde375d1() throws {
        let source = #"""
language core;

extend with #references, #top-type, #structural-patterns, #natural-literals;

fn main(x : Nat) -> Nat {
  return match x {
    _ => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/match_top_bot_ref_var/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/match_top_bot_ref_var/8.txt")
    func test_examples_match_top_bot_ref_var_8_txt_4dfb4081() throws {
        let source = #"""
language core;

extend with #references, #top-type, #structural-patterns, #natural-literals;

fn main(x : Nat) -> Nat {
  return match x {
    unit => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/match_top_bot_ref_var/8.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/ambiguous_type_as_bottom_from_task.st")
    func test_examples_ok_ambiguous_type_as_bottom_from_task_st_9b056e8a() throws {
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
            sourceName: "examples/ok/ambiguous_type_as_bottom_from_task.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/assignment_ref_ref.st")
    func test_examples_ok_assignment_ref_ref_st_48b56c27() throws {
        let source = #"""
language core;
extend with #references, #sequencing;

fn main(n : &&Nat) -> Nat {
	return *n := 0; succ(0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/assignment_ref_ref.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/assignment_to_parameter.st")
    func test_examples_ok_assignment_to_parameter_st_8965864d() throws {
        let source = #"""
language core;
extend with #references, #sequencing;

fn main(n : &Nat) -> Nat {
	return n := 0; succ(0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/assignment_to_parameter.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/cast_as.st")
    func test_examples_ok_cast_as_st_094cbcc4() throws {
        let source = #"""
language core;

extend with #natural-literals, #type-cast, #pairs, #top-type, #structural-subtyping;

fn main(n : Nat) -> Nat {
	return (1 cast as {Nat, Nat}).1
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/cast_as.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/cons.st")
    func test_examples_ok_cons_st_026b92a4() throws {
        let source = #"""
language core;

extend with #lists;


fn main(n : Nat) -> [Nat] {
  return  cons(0, []);
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/cons.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/cons_reconstruct.st")
    func test_examples_ok_cons_reconstruct_st_acf486ed() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;


fn main(n : Nat) -> [Nat] {
  return  cons(0, []);
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/cons_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/const.st")
    func test_examples_ok_const_st_7e5b57a6() throws {
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
            sourceName: "examples/ok/const.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/const2.st")
    func test_examples_ok_const2_st_3ef70715() throws {
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
            sourceName: "examples/ok/const2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/const_identity.st")
    func test_examples_ok_const_identity_st_1597e067() throws {
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
            sourceName: "examples/ok/const_identity.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/deref_deref_ref_ref.st")
    func test_examples_ok_deref_deref_ref_ref_st_88510d10() throws {
        let source = #"""
language core;
extend with #references, #sequencing;

fn main(n : &&Nat) -> Nat {
	return **n
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/deref_deref_ref_ref.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/deref_parameter.st")
    func test_examples_ok_deref_parameter_st_a19700cb() throws {
        let source = #"""
language core;
extend with #references;

fn foo(n : &Nat) -> Nat { return *n }

fn main(n : Nat) -> Nat {
	return foo(new (n))
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/deref_parameter.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/exhaustive_bool.st")
    func test_examples_ok_exhaustive_bool_st_b7f08ffe() throws {
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
            sourceName: "examples/ok/exhaustive_bool.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/exhaustive_fun.st")
    func test_examples_ok_exhaustive_fun_st_3047f761() throws {
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
            sourceName: "examples/ok/exhaustive_fun.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/exhaustive_list.st")
    func test_examples_ok_exhaustive_list_st_39b6f1f5() throws {
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
            sourceName: "examples/ok/exhaustive_list.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/exhaustive_nat_constructors.st")
    func test_examples_ok_exhaustive_nat_constructors_st_253be819() throws {
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
            sourceName: "examples/ok/exhaustive_nat_constructors.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/exhaustive_nested_tuple.st")
    func test_examples_ok_exhaustive_nested_tuple_st_af12bde2() throws {
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
            sourceName: "examples/ok/exhaustive_nested_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/exhaustive_record.st")
    func test_examples_ok_exhaustive_record_st_188d02dc() throws {
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
            sourceName: "examples/ok/exhaustive_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/exhaustive_sum.st")
    func test_examples_ok_exhaustive_sum_st_69a09935() throws {
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
            sourceName: "examples/ok/exhaustive_sum.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/exhaustive_sum_arg.st")
    func test_examples_ok_exhaustive_sum_arg_st_e5143541() throws {
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
            sourceName: "examples/ok/exhaustive_sum_arg.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/exhaustive_tuple.st")
    func test_examples_ok_exhaustive_tuple_st_8c74b9d4() throws {
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
            sourceName: "examples/ok/exhaustive_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/exhaustive_unit.st")
    func test_examples_ok_exhaustive_unit_st_07e5dec5() throws {
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
            sourceName: "examples/ok/exhaustive_unit.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/exhaustive_unit_var.st")
    func test_examples_ok_exhaustive_unit_var_st_9ffb4dd7() throws {
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
            sourceName: "examples/ok/exhaustive_unit_var.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/exhaustive_variant.st")
    func test_examples_ok_exhaustive_variant_st_8f05f059() throws {
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
            sourceName: "examples/ok/exhaustive_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/expections_from_task.st")
    func test_examples_ok_expections_from_task_st_5504a3d7() throws {
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
            sourceName: "examples/ok/expections_from_task.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/fix_from_arg.st")
    func test_examples_ok_fix_from_arg_st_16bf0587() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator;

fn main(f : fn(Nat) -> Nat) -> Nat {
  return fix(f);
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/fix_from_arg.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/fix_from_arg_reconstruct.st")
    func test_examples_ok_fix_from_arg_reconstruct_st_a3568af5() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn main(f : fn(auto) -> auto) -> auto {
  return fix(f);
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/fix_from_arg_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/fixpoint.st")
    func test_examples_ok_fixpoint_st_d349d7f0() throws {
        let source = #"""
language core;

extend with #fixpoint-combinator;

fn main(n : Nat) -> Nat {
  return fix(fn(y : Nat) { return n });
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/fixpoint.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/fixpoint_reconstruct.st")
    func test_examples_ok_fixpoint_reconstruct_st_2d3983da() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn main(n : auto) -> auto {
  return fix(fn(y : auto) { return n });
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/fixpoint_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/identity.st")
    func test_examples_ok_identity_st_7cfc9039() throws {
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
            sourceName: "examples/ok/identity.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/increment_twice.st")
    func test_examples_ok_increment_twice_st_7a20115c() throws {
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
            sourceName: "examples/ok/increment_twice.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/increment_twice_reconstruct.st")
    func test_examples_ok_increment_twice_reconstruct_st_2b27960e() throws {
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
            sourceName: "examples/ok/increment_twice_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/infer_cons.st")
    func test_examples_ok_infer_cons_st_f11c5ef0() throws {
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
            sourceName: "examples/ok/infer_cons.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/infer_cons_reconstruct.st")
    func test_examples_ok_infer_cons_reconstruct_st_4d34994e() throws {
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
            sourceName: "examples/ok/infer_cons_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/infer_fix.st")
    func test_examples_ok_infer_fix_st_4f0eeca5() throws {
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
            sourceName: "examples/ok/infer_fix.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/infer_fix_reconstruct.st")
    func test_examples_ok_infer_fix_reconstruct_st_158092ab() throws {
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
            sourceName: "examples/ok/infer_fix_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/infer_iszero.st")
    func test_examples_ok_infer_iszero_st_ac2248d8() throws {
        let source = #"""
language core;

fn main(a : Nat) -> Bool {
 	return (fn (a : Nat) { return Nat::iszero(0); } ) (a)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/infer_iszero.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/infer_match.st")
    func test_examples_ok_infer_match_st_3342fb05() throws {
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
            sourceName: "examples/ok/infer_match.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/infer_with_semicolon.st")
    func test_examples_ok_infer_with_semicolon_st_bc8108a3() throws {
        let source = #"""
language core;

fn main(a : Nat) -> Nat {
 return (fn (a : Nat) { return 0; } ) (a)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/infer_with_semicolon.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/int_literal.st")
    func test_examples_ok_int_literal_st_f1cdfd8b() throws {
        let source = #"""
language core;

extend with #natural-literals;


fn main(n : Nat) -> Nat {
  return 5;
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/int_literal.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/let_asc.st")
    func test_examples_ok_let_asc_st_0ec52dec() throws {
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
            sourceName: "examples/ok/let_asc.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/let_bool.st")
    func test_examples_ok_let_bool_st_54b964dd() throws {
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
            sourceName: "examples/ok/let_bool.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/let_fun.st")
    func test_examples_ok_let_fun_st_224dc39c() throws {
        let source = #"""
language core;
extend with #let-bindings;


fn main(n : Nat) -> Nat {
  return let zeroFun = (fn (a : Nat) {return a}) in zeroFun(0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/let_fun.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/let_fun_reconstruct.st")
    func test_examples_ok_let_fun_reconstruct_st_76f1a108() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #let-bindings;


fn main(n : auto) -> auto {
  return let zeroFun = (fn (a : auto) {return a}) in zeroFun(0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/let_fun_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/let_if.st")
    func test_examples_ok_let_if_st_9940d34e() throws {
        let source = #"""
language core;
extend with #let-bindings;


fn main(n : Nat) -> Nat {
  return let x = if false then 0 else succ(0) in x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/let_if.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/let_isempty.st")
    func test_examples_ok_let_isempty_st_44c1c826() throws {
        let source = #"""
language core;
extend with #let-bindings;
extend with #lists;


fn main(n : Nat) -> Bool {
 return let x = List::isempty([0, 0]) in x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/let_isempty.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/let_let.st")
    func test_examples_ok_let_let_st_fea43fb8() throws {
        let source = #"""
language core;
extend with #let-bindings;


fn main(n : Nat) -> Nat {
  return let y = let x = 0 in x in y
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/let_let.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/let_let_reconstruct.st")
    func test_examples_ok_let_let_reconstruct_st_b5b292a6() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #let-bindings;


fn main(n : auto) -> auto {
  return let y = let x = 0 in x in y
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/let_let_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/let_rec.st")
    func test_examples_ok_let_rec_st_71e21033() throws {
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
            sourceName: "examples/ok/let_rec.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/let_square.st")
    func test_examples_ok_let_square_st_c7e86293() throws {
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
            sourceName: "examples/ok/let_square.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/let_square_reconstruct.st")
    func test_examples_ok_let_square_reconstruct_st_dc6a1abc() throws {
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
            sourceName: "examples/ok/let_square_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/let_unit.st")
    func test_examples_ok_let_unit_st_598279e3() throws {
        let source = #"""
language core;
extend with #unit-type;
extend with #let-bindings;


fn main(n : Nat) -> Unit {
  return let x = unit in x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/let_unit.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/letrec.st")
    func test_examples_ok_letrec_st_4156f36c() throws {
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
            sourceName: "examples/ok/letrec.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/letrec_fn.st")
    func test_examples_ok_letrec_fn_st_79e9e6bd() throws {
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
            sourceName: "examples/ok/letrec_fn.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/list_ascription.st")
    func test_examples_ok_list_ascription_st_3f306a49() throws {
        let source = #"""
language core;
extend with #type-ascriptions;
extend with #lists;

fn main(n : Nat) -> [Bool] {
  return [] as [Bool]
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/list_ascription.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/list_ascription_reconstruct.st")
    func test_examples_ok_list_ascription_reconstruct_st_a13f1228() throws {
        let source = #"""
language core;
extend with #type-ascriptions;
extend with #type-reconstruction, #lists;

fn main(n : Nat) -> [Bool] {
  return [] as [Bool]
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/list_ascription_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/list_lenght_letrec.st")
    func test_examples_ok_list_lenght_letrec_st_0a245ff6() throws {
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
            sourceName: "examples/ok/list_lenght_letrec.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/list_operations.st")
    func test_examples_ok_list_operations_st_7db92269() throws {
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
            sourceName: "examples/ok/list_operations.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/list_operations_reconstruct.st")
    func test_examples_ok_list_operations_reconstruct_st_e1d6fc8d() throws {
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
            sourceName: "examples/ok/list_operations_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/memory_in_if.st")
    func test_examples_ok_memory_in_if_st_1b0b2877() throws {
        let source = #"""
language core;
extend with #references, #type-ascriptions;

fn foo(n : Nat) -> &Nat { return if Nat::iszero(n) then <0x01> else <0x02> }

fn main(n : Nat) -> Nat {
	return *foo(0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/memory_in_if.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/memory_in_if_2.st")
    func test_examples_ok_memory_in_if_2_st_aabdf447() throws {
        let source = #"""
language core;
extend with #references, #type-ascriptions;

fn main(n : Nat) -> Nat {
	return *(if Nat::iszero(n) then <0x01> else <0x02>)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/memory_in_if_2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/memory_pass_to_func.st")
    func test_examples_ok_memory_pass_to_func_st_a166234e() throws {
        let source = #"""
language core;
extend with #references, #type-ascriptions;

fn foo(n : &Nat) -> Nat { return *n }

fn main(n : Nat) -> Nat {
	return foo(<0x01>)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/memory_pass_to_func.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/memory_write_read.st")
    func test_examples_ok_memory_write_read_st_3d9777b2() throws {
        let source = #"""
language core;
extend with #references, #sequencing, #type-ascriptions;

fn main(n : Nat) -> Nat {
	return ((<0x01> as &Nat) := 0); *(<0x01> as &Nat)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/memory_write_read.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/memory_write_read_2.st")
    func test_examples_ok_memory_write_read_2_st_0ab0e0bf() throws {
        let source = #"""
language core;
extend with #references, #sequencing, #type-ascriptions;

fn main(n : Nat) -> Nat {
	return ((<0x01> as &Bool) := true); *(<0x01> as &Nat)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/memory_write_read_2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/memory_write_read_3.st")
    func test_examples_ok_memory_write_read_3_st_a317fcba() throws {
        let source = #"""
language core;
extend with #references, #type-ascriptions;

fn main(n : Nat) -> Nat {
	return *(<0x01> as &Nat)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/memory_write_read_3.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/multiparameter_fun.st")
    func test_examples_ok_multiparameter_fun_st_ce240602() throws {
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
            sourceName: "examples/ok/multiparameter_fun.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/nested_functions.st")
    func test_examples_ok_nested_functions_st_355e6d20() throws {
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
            sourceName: "examples/ok/nested_functions.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/nested_functions_params_shadowing.st")
    func test_examples_ok_nested_functions_params_shadowing_st_8a5c956d() throws {
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
            sourceName: "examples/ok/nested_functions_params_shadowing.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/nullary_function.st")
    func test_examples_ok_nullary_function_st_9d57f01e() throws {
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
            sourceName: "examples/ok/nullary_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/nullary_variant.st")
    func test_examples_ok_nullary_variant_st_3355b149() throws {
        let source = #"""
language core;

extend with #structural-patterns, #natural-literals, #variants, #nullary-variant-labels;

fn main(n : Nat) -> <| a : Nat, b, c |> {
  return <| c |>
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/nullary_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/nullary_variant_pattern.st")
    func test_examples_ok_nullary_variant_pattern_st_d1e736a0() throws {
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
            sourceName: "examples/ok/nullary_variant_pattern.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/panic.st")
    func test_examples_ok_panic_st_cd98e941() throws {
        let source = #"""
language core;

extend with #panic;

fn main(n : Nat) -> Nat {
  return panic!
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/panic.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/panic_from_task.st")
    func test_examples_ok_panic_from_task_st_9cdcf34d() throws {
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
            sourceName: "examples/ok/panic_from_task.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/panic_in_if.st")
    func test_examples_ok_panic_in_if_st_514fbaf8() throws {
        let source = #"""
language core;
extend with #panic, #pairs, #fixpoint-combinator, #sequencing;

fn main(n : Nat) -> Nat {
  return if false then panic! else panic!; 0
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/panic_in_if.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/panic_inside_lambda_as_bot.st")
    func test_examples_ok_panic_inside_lambda_as_bot_st_777a5428() throws {
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
            sourceName: "examples/ok/panic_inside_lambda_as_bot.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/panic_or_bool_as_parameter.st")
    func test_examples_ok_panic_or_bool_as_parameter_st_6a82c49a() throws {
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
            sourceName: "examples/ok/panic_or_bool_as_parameter.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/parenthesis.st")
    func test_examples_ok_parenthesis_st_2a03cc58() throws {
        let source = #"""
language core;
extend with #unit-type;
extend with #let-bindings;


fn main(n : Nat) -> Nat {
  return (let x = ((fn (a : Nat) { return ((succ(a))) } )) in ((x))((0)))
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/parenthesis.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/parenthesis_reconstruct.st")
    func test_examples_ok_parenthesis_reconstruct_st_534d4da5() throws {
        let source = #"""
language core;
extend with #type-reconstruction, #unit-type;
extend with #let-bindings;


fn main(n : auto) -> auto {
  return (let x = ((fn (a : auto) { return ((succ(a))) } )) in ((x))((0)))
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/parenthesis_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/record_apply_to_function.st")
    func test_examples_ok_record_apply_to_function_st_4de5cc31() throws {
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
            sourceName: "examples/ok/record_apply_to_function.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/record_diff_order.st")
    func test_examples_ok_record_diff_order_st_62fb59eb() throws {
        let source = #"""
language core;

extend with #records;


fn main(succeed : Nat) -> { b : Nat, a : Bool } {
  return { a = true, b = 0 }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/record_diff_order.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/record_in_abstraction.st")
    func test_examples_ok_record_in_abstraction_st_d25c354a() throws {
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
            sourceName: "examples/ok/record_in_abstraction.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/record_in_record.st")
    func test_examples_ok_record_in_record_st_2ba62f09() throws {
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
            sourceName: "examples/ok/record_in_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/reference_from_task.st")
    func test_examples_ok_reference_from_task_st_4d6e18b7() throws {
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
            sourceName: "examples/ok/reference_from_task.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/return_deref_ref.st")
    func test_examples_ok_return_deref_ref_st_d56b3fb2() throws {
        let source = #"""
language core;
extend with #references;

fn foo(n : Nat) -> Nat { return 0 }

fn main(n : Nat) -> Nat {
	return *(new (foo(0)))
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/return_deref_ref.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/self_app.st")
    func test_examples_ok_self_app_st_22bcee10() throws {
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
            sourceName: "examples/ok/self_app.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/semicolon.st")
    func test_examples_ok_semicolon_st_99df26d8() throws {
        let source = #"""
language core;

fn main(a : Nat) -> Nat {
return 0;
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/semicolon.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/sequencing_basic.st")
    func test_examples_ok_sequencing_basic_st_6d5ad32a() throws {
        let source = #"""
language core;
extend with #sequencing, #unit-type;

fn main(n : Nat) -> Nat {
	return (fn(a : Nat) { return unit }) (0); 0
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/sequencing_basic.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/simple_ascription.st")
    func test_examples_ok_simple_ascription_st_16169504() throws {
        let source = #"""
language core;
extend with #type-ascriptions;


fn main(n : Nat) -> Nat {
  return 0 as Nat
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/simple_ascription.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/simple_ascription_reconstruct.st")
    func test_examples_ok_simple_ascription_reconstruct_st_e2ec7241() throws {
        let source = #"""
language core;
extend with #type-reconstruction, #type-ascriptions;


fn main(n : Nat) -> Nat {
  return 0 as Nat
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/simple_ascription_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/simple_inl_reconstruct.st")
    func test_examples_ok_simple_inl_reconstruct_st_a7764332() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;

fn main(n : Nat) -> Nat + Nat {
  return (fn (a : Nat) { return inl(0) }) (0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/simple_inl_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/simple_inr_reconstruct.st")
    func test_examples_ok_simple_inr_reconstruct_st_8401c7c1() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;

fn main(n : Nat) -> Nat + Nat {
  return (fn (a : Nat) { return inr(0) }) (0)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/simple_inr_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/simple_letrec.st")
    func test_examples_ok_simple_letrec_st_49c30fcf() throws {
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
            sourceName: "examples/ok/simple_letrec.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/simple_pair.st")
    func test_examples_ok_simple_pair_st_9347a9b8() throws {
        let source = #"""
language core;
extend with #pairs;

fn main(n : Nat) -> {Nat, Nat} {
  return {succ(n), {succ(succ(n)), n}}.2
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/simple_pair.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/simple_records.st")
    func test_examples_ok_simple_records_st_8d5ab67b() throws {
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
            sourceName: "examples/ok/simple_records.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/simple_sum.st")
    func test_examples_ok_simple_sum_st_ade3c223() throws {
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
            sourceName: "examples/ok/simple_sum.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/simple_sum_reconstruct.st")
    func test_examples_ok_simple_sum_reconstruct_st_bf74d16e() throws {
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
            sourceName: "examples/ok/simple_sum_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/simple_tuple.st")
    func test_examples_ok_simple_tuple_st_798ee7b1() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> {Nat, Nat, Bool} {
  return {n, succ(n), true}
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/simple_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/simple_unit.st")
    func test_examples_ok_simple_unit_st_1a35bd77() throws {
        let source = #"""
language core;
extend with #unit-type;

fn main(_ : Nat) -> Unit {
    return unit
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/simple_unit.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/square_reconstruct.st")
    func test_examples_ok_square_reconstruct_st_46df62b1() throws {
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
            sourceName: "examples/ok/square_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_bool.st")
    func test_examples_ok_subtyping_bool_st_b29f85df() throws {
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
            sourceName: "examples/ok/subtyping_bool.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_error.st")
    func test_examples_ok_subtyping_error_st_70707325() throws {
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
            sourceName: "examples/ok/subtyping_error.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_func.st")
    func test_examples_ok_subtyping_func_st_35ec461b() throws {
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
            sourceName: "examples/ok/subtyping_func.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_func2.st")
    func test_examples_ok_subtyping_func2_st_6faa583d() throws {
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
            sourceName: "examples/ok/subtyping_func2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_func3.st")
    func test_examples_ok_subtyping_func3_st_9c7cd299() throws {
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
            sourceName: "examples/ok/subtyping_func3.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_list.st")
    func test_examples_ok_subtyping_list_st_c514307f() throws {
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
            sourceName: "examples/ok/subtyping_list.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_list2.st")
    func test_examples_ok_subtyping_list2_st_367730cf() throws {
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
            sourceName: "examples/ok/subtyping_list2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_nat.st")
    func test_examples_ok_subtyping_nat_st_9436a904() throws {
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
            sourceName: "examples/ok/subtyping_nat.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_record.st")
    func test_examples_ok_subtyping_record_st_d4d0f7c5() throws {
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
            sourceName: "examples/ok/subtyping_record.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_record2.st")
    func test_examples_ok_subtyping_record2_st_da6fd125() throws {
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
            sourceName: "examples/ok/subtyping_record2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_ref.st")
    func test_examples_ok_subtyping_ref_st_9fd63ea5() throws {
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
            sourceName: "examples/ok/subtyping_ref.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_ref2.st")
    func test_examples_ok_subtyping_ref2_st_3760ccfb() throws {
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
            sourceName: "examples/ok/subtyping_ref2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_ref3.st")
    func test_examples_ok_subtyping_ref3_st_c8ba30bb() throws {
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
            sourceName: "examples/ok/subtyping_ref3.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_sum.st")
    func test_examples_ok_subtyping_sum_st_3e0dcf4b() throws {
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
            sourceName: "examples/ok/subtyping_sum.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_sum2.st")
    func test_examples_ok_subtyping_sum2_st_afe2264c() throws {
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
            sourceName: "examples/ok/subtyping_sum2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_top.st")
    func test_examples_ok_subtyping_top_st_43d25f5b() throws {
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
            sourceName: "examples/ok/subtyping_top.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_top2.st")
    func test_examples_ok_subtyping_top2_st_09346d31() throws {
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
            sourceName: "examples/ok/subtyping_top2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_tuple.st")
    func test_examples_ok_subtyping_tuple_st_ca0df84e() throws {
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
            sourceName: "examples/ok/subtyping_tuple.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_tuple2.st")
    func test_examples_ok_subtyping_tuple2_st_c22831eb() throws {
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
            sourceName: "examples/ok/subtyping_tuple2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_unit.st")
    func test_examples_ok_subtyping_unit_st_0c4ec6ea() throws {
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
            sourceName: "examples/ok/subtyping_unit.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_variant2.st")
    func test_examples_ok_subtyping_variant2_st_9c01b825() throws {
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
            sourceName: "examples/ok/subtyping_variant2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_variant3.st")
    func test_examples_ok_subtyping_variant3_st_16e03e9b() throws {
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
            sourceName: "examples/ok/subtyping_variant3.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/subtyping_variants.st")
    func test_examples_ok_subtyping_variants_st_690bd05b() throws {
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
            sourceName: "examples/ok/subtyping_variants.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/sum_arg.st")
    func test_examples_ok_sum_arg_st_f48a6d25() throws {
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
            sourceName: "examples/ok/sum_arg.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/sum_arg_reconstruct.st")
    func test_examples_ok_sum_arg_reconstruct_st_879e40ec() throws {
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
            sourceName: "examples/ok/sum_arg_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/throw.st")
    func test_examples_ok_throw_st_24e89d87() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals, #exception-type-declaration;

exception type = Nat

fn main(n : Nat) -> Nat {
  return throw(1)
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/throw.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/try_cast_as.st")
    func test_examples_ok_try_cast_as_st_179c4fb1() throws {
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
            sourceName: "examples/ok/try_cast_as.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/try_catch.st")
    func test_examples_ok_try_catch_st_3f077be5() throws {
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
            sourceName: "examples/ok/try_catch.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/try_catch_no_error.st")
    func test_examples_ok_try_catch_no_error_st_0af646de() throws {
        let source = #"""
language core;
extend with #exceptions, #exception-type-declaration, #structural-patterns;
exception type = Nat

fn main(n : Nat) -> Bool {
	return try { true } catch { 0 => true }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/try_catch_no_error.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/try_catch_unepected_pattern_2.st")
    func test_examples_ok_try_catch_unepected_pattern_2_st_03787ed5() throws {
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
            sourceName: "examples/ok/try_catch_unepected_pattern_2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/try_catch_variant.st")
    func test_examples_ok_try_catch_variant_st_c735bc60() throws {
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
            sourceName: "examples/ok/try_catch_variant.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/try_catch_variant2.st")
    func test_examples_ok_try_catch_variant2_st_84df62a7() throws {
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
            sourceName: "examples/ok/try_catch_variant2.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/try_catch_with_structural_pattern.st")
    func test_examples_ok_try_catch_with_structural_pattern_st_56ade3ef() throws {
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
            sourceName: "examples/ok/try_catch_with_structural_pattern.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/try_with.st")
    func test_examples_ok_try_with_st_0870c2c6() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals, #exception-type-declaration;

exception type = Nat

fn main(n : Nat) -> Nat {
  return try { 1 } with { 1 }
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/try_with.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/try_with_try_and_with_throws.st")
    func test_examples_ok_try_with_try_and_with_throws_st_77b1f02c() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals, #exception-type-declaration;

exception type = Nat

fn main(n : Nat) -> Nat {
  return try { throw(1) } with { throw(0) }
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/try_with_try_and_with_throws.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/try_with_try_throws.st")
    func test_examples_ok_try_with_try_throws_st_79395b53() throws {
        let source = #"""
language core;

extend with #exceptions, #natural-literals, #exception-type-declaration;

exception type = Nat

fn main(n : Nat) -> Nat {
  return try { throw(1) } with { 1 }
}



"""#
        let program = try Program.parser.run(
            sourceName: "examples/ok/try_with_try_throws.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/twice_bool_not.st")
    func test_examples_ok_twice_bool_not_st_26d1bdb5() throws {
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
            sourceName: "examples/ok/twice_bool_not.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/twice_bool_not_reconstruct.st")
    func test_examples_ok_twice_bool_not_reconstruct_st_b1c38dd6() throws {
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
            sourceName: "examples/ok/twice_bool_not_reconstruct.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/type_cast_from_task.st")
    func test_examples_ok_type_cast_from_task_st_8d6fa16f() throws {
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
            sourceName: "examples/ok/type_cast_from_task.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/variant_asc.st")
    func test_examples_ok_variant_asc_st_88219ef0() throws {
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
            sourceName: "examples/ok/variant_asc.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ok/variant_attempt.st")
    func test_examples_ok_variant_attempt_st_7f9c5731() throws {
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
            sourceName: "examples/ok/variant_attempt.st",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/patterns_err/1.txt")
    func test_examples_patterns_err_1_txt_c7bbc5a7() throws {
        let source = #"""
language core;
extend with #arithmetic-operators,#variants,#tuples,#lists,#unit-type,#natural-literals,#structural-patterns,#fixpoint-combinator;


fn main(_ : Nat) -> Nat {
  return match {succ(0), 0} {
    {x} => succ(x + y)
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/patterns_err/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/patterns_err/2.txt")
    func test_examples_patterns_err_2_txt_b4fce0ab() throws {
        let source = #"""
language core;
extend with #variants,#arithmetic-operators,#records, #lists, #tuples, #unit-type, #natural-literals, #structural-patterns, #fixpoint-combinator;

fn main(_ : Nat) -> Nat {
  return match {x = {z = 4}, y = 6} {
    { x = 4, y = 3 } => 10
    | { x = 5, y = 6 } => 20
    | { x = a, y = b } => a + b
  };
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/patterns_err/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/patterns_succ/1.txt")
    func test_examples_patterns_succ_1_txt_3058d95f() throws {
        let source = #"""
language core;
extend with #arithmetic-operators,#variants,#tuples,#lists,#unit-type,#natural-literals,#structural-patterns,#fixpoint-combinator;


fn main(_ : Nat) -> Nat {
  return match {{succ(0)}, {0}} {
    {{x}, {y}} => succ(x + y)
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/patterns_succ/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/patterns_succ/2.txt")
    func test_examples_patterns_succ_2_txt_81acee4d() throws {
        let source = #"""
language core;
extend with #arithmetic-operators,#variants,#tuples,#lists,#unit-type,#natural-literals,#structural-patterns,#fixpoint-combinator;


fn main(_ : Nat) -> Nat {
  return match {succ(0), 0} {
    {x, y} => succ(x + y)
    | {x, z} => succ(x + z)
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/patterns_succ/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/patterns_succ/3.txt")
    func test_examples_patterns_succ_3_txt_5aa032d8() throws {
        let source = #"""
language core;
extend with #variants,#arithmetic-operators,#records, #lists, #tuples, #unit-type, #natural-literals, #structural-patterns, #fixpoint-combinator;

fn main(_ : Nat) -> Nat {
  return match {x = 5, y = 6} {
    { x = 5, y = 3 } => 10
    | { x = 5, y = 6 } => 20
    | { x = a, y = b } => a + b
  };
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/patterns_succ/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/patterns_succ/4.txt")
    func test_examples_patterns_succ_4_txt_479cc8f1() throws {
        let source = #"""
language core;
extend with #variants,#arithmetic-operators,#records, #lists, #tuples, #unit-type, #natural-literals, #structural-patterns, #fixpoint-combinator;

fn main(_ : Nat) -> Nat {
  return match {x = {z = 4}, y = 6} {
    { x = {z = succ(0)}, y = 3 } => 10
    | { x = {z = 5}, y = 6 } => 20
    | { x = {z = a}, y = b } => a + b
  };
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/patterns_succ/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/patterns_succ/5.txt")
    func test_examples_patterns_succ_5_txt_381df077() throws {
        let source = #"""
language core;
extend with #lists,#structural-patterns,#natural-literals;

fn length(xs : [Nat]) -> Nat {
  return match xs {
    [] => 0
  | cons(h, t) => succ(length(t))
  }
}

fn main(_ : Nat) -> Nat {
  return length([5])
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/patterns_succ/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/patterns_succ/6.txt")
    func test_examples_patterns_succ_6_txt_9ebbab17() throws {
        let source = #"""
language core;
extend with #lists,#structural-patterns,#natural-literals,#arithmetic-operators;

fn sum(xs : [Nat]) -> Nat {
  return match xs {
    [] => 0
  | cons(h, t) => h + sum(t)
  }
}

fn main(_ : Nat) -> Nat {
  return sum([1,2,3])
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/patterns_succ/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/patterns_succ/7.txt")
    func test_examples_patterns_succ_7_txt_f63dd690() throws {
        let source = #"""
language core;
extend with #lists,#structural-patterns,#natural-literals;

fn isSingleton(xs : [Nat]) -> Bool {
  return match xs {
    [] => false
  | cons(h, []) => true
  | cons(h, t) => false
  }
}

fn main(_ : Nat) -> Bool {
  return isSingleton([42])
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/patterns_succ/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/patterns_succ/8.txt")
    func test_examples_patterns_succ_8_txt_87b47f02() throws {
        let source = #"""
language core;
extend with #lists,#structural-patterns,#natural-literals;

fn mapSucc(xs : [Nat]) -> [Nat] {
  return match xs {
    [] => []
  | cons(h, t) => cons(succ(h), mapSucc(t))
  }
}

fn main(_ : Nat) -> [Nat] {
  return mapSucc([1,2,3])
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/patterns_succ/8.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/patterns_succ/9.txt")
    func test_examples_patterns_succ_9_txt_48fd3784() throws {
        let source = #"""
language core;
extend with #lists,#structural-patterns,#natural-literals;

fn filterNonZero(xs : [Nat]) -> [Nat] {
  return match xs {
    [] => []
  | cons(h, t) =>
      match h {
        0 => filterNonZero(t)
      | _ => cons(h, filterNonZero(t))
      }
  }
}

fn main(_ : Nat) -> [Nat] {
  return filterNonZero([0, 1, 0, 2, 3])

}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/patterns_succ/9.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/record_err/1.txt")
    func test_examples_record_err_1_txt_ea998969() throws {
        let source = #"""
language core;
extend with #records;

fn main(_ : Nat) -> Nat {
  return 0.current
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_err/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/record_err/10.txt")
    func test_examples_record_err_10_txt_b9b03423() throws {
        let source = #"""
language core;
extend with #records,#nullary-functions,#natural-literals;

fn make() -> {x : Nat, y : Nat, z : Nat} {
  return {x = 1}
}

fn main(a : Nat) -> Nat {
  return a
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_err/10.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/record_err/11.txt")
    func test_examples_record_err_11_txt_fd72d16f() throws {
        let source = #"""
language core;
extend with #records,#natural-literals,#let-bindings;

fn main(_ : Nat) -> Nat {
  return {x = 1, y = 2}
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_err/11.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/record_err/2.txt")
    func test_examples_record_err_2_txt_d7c01a86() throws {
        let source = #"""
language core;
extend with #records,#natural-literals,#let-bindings,#nullary-functions;

fn make(n : Nat) -> {x : Nat} {
  return {x = 42}
}

fn main(n : Nat) -> Nat {
  return make(n).y
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_err/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/record_err/3.txt")
    func test_examples_record_err_3_txt_f365581e() throws {
        let source = #"""
language core;
extend with #records,#natural-literals,#let-bindings,#nullary-functions,#type-ascriptions;

fn main(_ : Nat) -> Nat {
  return let r = {x = 1, y = 2}
  in r as Nat
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_err/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/record_err/4.txt")
    func test_examples_record_err_4_txt_6883f87b() throws {
        let source = #"""
language core;
extend with #records,#nullary-functions,#natural-literals;

fn make() -> {x : Nat, y : Nat} {
  return {x = 1}
}

fn main(a : Nat) -> Nat {
  return a
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_err/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/record_err/5.txt")
    func test_examples_record_err_5_txt_19436c57() throws {
        let source = #"""
language core;
extend with #records,#nullary-functions,#natural-literals;

fn make() -> {x : Nat} {
  return {x = 1, y = 2}
}

fn main(a : Nat) -> Nat {
  return a
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_err/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/record_err/6.txt")
    func test_examples_record_err_6_txt_8684ff82() throws {
        let source = #"""
language core;
extend with #records,#nullary-functions,#natural-literals;

fn make() -> {x : Nat} {
  return {x = 1, x = 2}
}

fn main(a : Nat) -> Nat {
  return a
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_err/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/record_err/7.txt")
    func test_examples_record_err_7_txt_8dea73b9() throws {
        let source = #"""
language core;
extend with #records,#nullary-functions,#natural-literals;

fn make() -> {x : Nat, x : Nat} {
  return {x = 1}
}

fn main(a : Nat) -> Nat {
  return a
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_err/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/record_err/8.txt")
    func test_examples_record_err_8_txt_d3b18761() throws {
        let source = #"""
language core;
extend with #records,#nullary-functions,#natural-literals;

fn f(_ : Nat) -> Nat { return 0 }

fn main(_ : Nat) -> Nat {
  return f.abc
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_err/8.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/record_err/9.txt")
    func test_examples_record_err_9_txt_52ce4ec8() throws {
        let source = #"""
language core;
extend with #records,#nullary-functions,#natural-literals;

fn make(p : Nat) -> {a : {b : Nat}} {
  return {a = {b = 1}}
}

fn main(p : Nat) -> Nat {
  return make(p).a.c
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_err/9.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/record_succ/1.txt")
    func test_examples_record_succ_1_txt_82377314() throws {
        let source = #"""
language core;
extend with #let-bindings,#records,#natural-literals;

fn main(_ : Nat) -> Nat {
  return let r = {x = 1, y = 2} in
  r.x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_succ/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/record_succ/10.txt")
    func test_examples_record_succ_10_txt_e8632679() throws {
        let source = #"""
language core;
extend with #records,#natural-literals,#let-bindings;

fn make(_ : Nat) -> {f : fn(Nat) -> Nat, base : Nat} {
  return {f = fn(x : Nat) { return succ(x) }, base = 100}
}

fn main(n : Nat) -> Nat {
  return let r = make(n) in
  r.f(r.base)
}





"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_succ/10.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/record_succ/2.txt")
    func test_examples_record_succ_2_txt_04cb76bf() throws {
        let source = #"""
language core;
extend with #let-bindings,#records,#natural-literals;

fn main(_ : Nat) -> Nat {
  return let r = {a = {b = 5, c = 6}, d = 7} in
  r.a.c
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_succ/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/record_succ/3.txt")
    func test_examples_record_succ_3_txt_235cf69a() throws {
        let source = #"""
language core;
extend with #records,#multiparameter-functions,#natural-literals;

fn makePoint(x : Nat, y : Nat) -> {x : Nat, y : Nat} {
  return {x = x, y = y}
}

fn main(_ : Nat) -> Nat {
  return makePoint(2, 3).y
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_succ/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/record_succ/4.txt")
    func test_examples_record_succ_4_txt_d80dd2fc() throws {
        let source = #"""
language core;
extend with #records,#arithmetic-operators,#natural-literals;

fn sum(p : {a : Nat, b : Nat}) -> Nat {
  return p.a + p.b
}

fn main(_ : Nat) -> Nat {
  return sum({a = 10, b = 32})
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_succ/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/record_succ/5.txt")
    func test_examples_record_succ_5_txt_8fc91058() throws {
        let source = #"""
language core;
extend with #records,#let-bindings,#natural-literals;

fn main(_ : Nat) -> Nat {
  return let r = {inc = fn(x : Nat) { return succ(x) }} in
  r.inc(41)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_succ/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/record_succ/6.txt")
    func test_examples_record_succ_6_txt_10dd0334() throws {
        let source = #"""
language core;
extend with #records,#let-bindings,#natural-literals;

fn main(_ : Nat) -> Nat {
  return let r = {outer = {inner = {z = 99}}, n = 1} in
  r.outer.inner.z
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_succ/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/record_succ/7.txt")
    func test_examples_record_succ_7_txt_e2bbb5ad() throws {
        let source = #"""
language core;
extend with #records,#natural-literals;

fn pair(n : Nat) -> {val : Nat, next : Nat} {
  return {val = n, next = succ(n)}
}

fn main(_ : Nat) -> Nat {
  return pair(10).next
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_succ/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/record_succ/8.txt")
    func test_examples_record_succ_8_txt_ed95645c() throws {
        let source = #"""
language core;
extend with #records,#let-bindings,#natural-literals;

fn main(_ : Nat) -> Nat {
  return let r = {a = {b = {c = {d = 123}}}} in
  r.a.b.c.d
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_succ/8.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/record_succ/9.txt")
    func test_examples_record_succ_9_txt_25ceb692() throws {
        let source = #"""
language core;
extend with #records,#natural-literals;

fn unwrap(r : {a : {b : Nat}}) -> Nat {
  return r.a.b
}

fn main(_ : Nat) -> Nat {
  return unwrap({a = {b = 42}})
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/record_succ/9.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ref_err/1.txt")
    func test_examples_ref_err_1_txt_5ba283da() throws {
        let source = #"""
language core;
extend with #references,#let-bindings;

fn main(n : Nat) -> Nat {
  return let raw = <0x1234> in *raw
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_err/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/ref_err/2.txt")
    func test_examples_ref_err_2_txt_85b0d949() throws {
        let source = #"""
language core;
extend with #references;

fn main(n : Nat) -> Nat {
  return *n
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_err/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/ref_err/3.txt")
    func test_examples_ref_err_3_txt_ca552622() throws {
        let source = #"""
language core;
extend with #references, #unit-type, #natural-literals;

fn main(n : Nat) -> Unit {
  return n := 42
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_err/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/ref_err/4.txt")
    func test_examples_ref_err_4_txt_40cbbdb9() throws {
        let source = #"""
language core;
extend with #references, #unit-type;

fn main(u : Unit) -> Unit {
  return *u
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_err/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/ref_err/5.txt")
    func test_examples_ref_err_5_txt_74620120() throws {
        let source = #"""
language core;
extend with #references,#arithmetic-operators,#natural-literals;

fn main(n : Nat) -> Nat {
  return <0x1234> + 1
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_err/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/ref_err/6.txt")
    func test_examples_ref_err_6_txt_de4804b5() throws {
        let source = #"""
language core;
extend with #references,#comparison-operators,#natural-literals;

fn main(n : Nat) -> Bool {
  return <0x1234> == 5
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_err/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/ref_err/7.txt")
    func test_examples_ref_err_7_txt_ef4fe315() throws {
        let source = #"""
language core;
extend with #references;

fn f(x : Nat) -> Nat { return x }

fn main(n : Nat) -> Nat {
  return f(<0x1234>)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_err/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/ref_succ/1.txt")
    func test_examples_ref_succ_1_txt_3177cf3e() throws {
        let source = #"""
language core;

extend with
  #unit-type,
  #references,
  #let-bindings,
  #sequencing;

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
            sourceName: "examples/ref_succ/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ref_succ/10.txt")
    func test_examples_ref_succ_10_txt_3b41e847() throws {
        let source = #"""
language core;
extend with #references, #let-bindings, #type-ascriptions;

fn main(n : Nat) -> &Nat {
  return let r = new(n) in
  let raw = <0xDEAD1234> as &Nat in
  if true then r else raw
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_succ/10.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ref_succ/11.txt")
    func test_examples_ref_succ_11_txt_34844d95() throws {
        let source = #"""
language core;
extend with #references, #lists;

fn main(n : Nat) -> [&Nat] {
  return [<0xABCD>, <0x1234>]
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_succ/11.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ref_succ/2.txt")
    func test_examples_ref_succ_2_txt_d315c629() throws {
        let source = #"""
language core;
extend with #natural-literals,#type-ascriptions, #references,#unit-type,#arithmetic-operators,#let-bindings;

fn main(_ : Nat) -> Unit {

  return let r = new(42) in


  let rawAddr = <0x0BEEF123> as &Nat in


  let x = *r in


  r := x + 1;
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_succ/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ref_succ/3.txt")
    func test_examples_ref_succ_3_txt_662d835c() throws {
        let source = #"""
language core;
extend with #references,#let-bindings;

fn main(n : Nat) -> Nat {
  return let r = new(n) in *r
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_succ/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ref_succ/4.txt")
    func test_examples_ref_succ_4_txt_5a3e4795() throws {
        let source = #"""
language core;
extend with #references,#unit-type,#let-bindings,#sequencing;

fn inc(ref : &Nat) -> Unit {
  return ref := succ(*ref)
}

fn main(n : Nat) -> Nat {
  return let r = new(n) in
    inc(r);
    *r
}

"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_succ/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ref_succ/5.txt")
    func test_examples_ref_succ_5_txt_c4392f0e() throws {
        let source = #"""
language core;
extend with #references, #let-bindings,#sequencing;

fn addOne(ref : &Nat) -> Nat {
  return ref := succ(*ref); *ref
}

fn main(n : Nat) -> Nat {
  return let r = new(n) in addOne(r)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_succ/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ref_succ/6.txt")
    func test_examples_ref_succ_6_txt_a4b27c26() throws {
        let source = #"""
language core;
extend with #references, #let-bindings, #type-ascriptions;

fn main(n : Nat) -> &Nat {
  return let addr = <0x0BEEF123> as &Nat in addr
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_succ/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ref_succ/7.txt")
    func test_examples_ref_succ_7_txt_dc95dc2c() throws {
        let source = #"""
language core;
extend with #references,#let-bindings;

fn main(n : Nat) -> Nat {
  return let r = new(n) in
  let rr = new(r) in
  **rr
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_succ/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ref_succ/8.txt")
    func test_examples_ref_succ_8_txt_e7d5e96d() throws {
        let source = #"""
language core;
extend with #references, #unit-type, #let-bindings, #sequencing;

fn setToZero(ref : &Nat) -> Nat {
  return let old = *ref in
  ref := 0;
  old
}

fn main(n : Nat) -> Nat {
  return let r = new(n) in setToZero(r)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_succ/8.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/ref_succ/9.txt")
    func test_examples_ref_succ_9_txt_27ff29dc() throws {
        let source = #"""
language core;
extend with #references, #unit-type, #let-bindings;

fn main(u : Unit) -> Unit {
  return let r = new(u) in *r
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/ref_succ/9.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sand_reconstr/1.stella")
    func test_examples_sand_reconstr_1_stella_544c3a81() throws {
        let source = #"""
language core;

extend with
  #type-reconstruction;

fn main(x : auto) -> auto {
  return if true then x else false
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sand_reconstr/1.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sand_reconstr/10.stella")
    func test_examples_sand_reconstr_10_stella_d5aa4148() throws {
        let source = #"""
language core;

extend with
  #type-reconstruction;

fn test10(z : auto) -> auto {
  return z
}

fn main(y : Nat) -> Bool {
  return true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sand_reconstr/10.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sand_reconstr/11.stella")
    func test_examples_sand_reconstr_11_stella_e4c9e485() throws {
        let source = #"""
language core;

extend with
  #multiparameter-functions,
  #type-reconstruction;


fn test(x : Bool, y : Bool) -> auto {
  return test
}

fn main(y : Nat) -> Bool {
  return true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sand_reconstr/11.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sand_reconstr/2.stella")
    func test_examples_sand_reconstr_2_stella_3d098e34() throws {
        let source = #"""
language core;

extend with
  #type-reconstruction;

fn main(y : auto) -> auto {
  return if y then true else false
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sand_reconstr/2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sand_reconstr/3.stella")
    func test_examples_sand_reconstr_3_stella_18785273() throws {
        let source = #"""
language core;

extend with
#multiparameter-functions,
  #type-reconstruction;

fn test3(a : auto, b : auto) -> auto {
  return if true then (if false then a else b) else true
}

fn main(y : Nat) -> Bool {
  return true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sand_reconstr/3.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sand_reconstr/4.stella")
    func test_examples_sand_reconstr_4_stella_1092afbd() throws {
        let source = #"""
language core;

extend with
  #multiparameter-functions,
  #type-reconstruction;

fn test4(x : auto, y : auto) -> auto {
  return if y then x else y
}

fn main(y : Nat) -> Bool {
  return true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sand_reconstr/4.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sand_reconstr/5.stella")
    func test_examples_sand_reconstr_5_stella_475ca01b() throws {
        let source = #"""
language core;

extend with
  #multiparameter-functions,
  #nullary-functions,
  #type-reconstruction;

fn test5() -> auto {
  return true
}

fn main(y : Nat) -> Bool {
  return true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sand_reconstr/5.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sand_reconstr/6.stella")
    func test_examples_sand_reconstr_6_stella_f4b28bdd() throws {
        let source = #"""
language core;

extend with
  #type-reconstruction;

fn test6(x : auto) -> auto {
  return if false then x else true
}

fn main(y : Nat) -> Bool {
  return true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sand_reconstr/6.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sand_reconstr/7.stella")
    func test_examples_sand_reconstr_7_stella_3776e561() throws {
        let source = #"""
language core;

extend with
#natural-literals,
  #type-reconstruction;

fn test7(n : auto) -> auto {
  return if true then (if n then 42 else 42) else n
}

fn main(y : Nat) -> Bool {
  return true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sand_reconstr/7.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sand_reconstr/8.stella")
    func test_examples_sand_reconstr_8_stella_bc701c3a() throws {
        let source = #"""
language core;

extend with
#multiparameter-functions,
  #type-reconstruction;

fn test8(a : auto, b : auto) -> auto {
  return if a then b else a
}

fn main(y : Nat) -> Bool {
  return true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sand_reconstr/8.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sand_reconstr/9.stella")
    func test_examples_sand_reconstr_9_stella_849d15d1() throws {
        let source = #"""
language core;

extend with
#multiparameter-functions,
  #type-reconstruction;

fn test9(x : auto, y : auto) -> auto {
  return if true then (if x then y else 0) else false
}

fn main(y : Nat) -> Bool {
  return true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sand_reconstr/9.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_abs_err/1.txt")
    func test_examples_stella_core_abs_err_1_txt_4db771c9() throws {
        let source = #"""
language core;

fn main(_ : Nat) -> Nat {
  return fn(x : Nat) { return succ(x) }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_err/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_abs_err/10.txt")
    func test_examples_stella_core_abs_err_10_txt_caaa3d39() throws {
        let source = #"""
language core;

extend with #unit-type;

fn boolTwice(f : Bool) -> Bool {
  return f
}

fn main(n : Nat) -> Bool {
    return boolTwice(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_err/10.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_abs_err/2.txt")
    func test_examples_stella_core_abs_err_2_txt_301016c4() throws {
        let source = #"""
language core;

fn main(_ : Bool) -> Bool {
  return fn(b : Bool) { return b }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_err/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_abs_err/3.txt")
    func test_examples_stella_core_abs_err_3_txt_635fe27b() throws {
        let source = #"""
language core;

extend with #unit-type;

fn main(_ : Unit) -> Unit {
  return fn(u : Unit) { return u }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_err/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_abs_err/4.txt")
    func test_examples_stella_core_abs_err_4_txt_d8212dfe() throws {
        let source = #"""
language core;

extend with #unit-type;

fn main(_ : Nat) -> Bool {
  return fn(x : Nat) { return succ(x) }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_err/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_abs_err/5.txt")
    func test_examples_stella_core_abs_err_5_txt_504bb441() throws {
        let source = #"""
language core;

extend with #unit-type;

fn main(_ : Nat) -> Nat {
  return fn(x : Nat) { return fn(y : Nat) { return succ(y) } }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_err/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_abs_err/6.txt")
    func test_examples_stella_core_abs_err_6_txt_4851c331() throws {
        let source = #"""
language core;

extend with #unit-type;

fn twice(f : fn(Nat) -> Nat) -> fn(Nat) -> Nat {
  return fn(x : Nat) { return f(f(x)) }
}

fn main(_ : Nat) -> fn(Nat) -> Nat {
  return fn(n : Nat) {
    return twice(fn(x : Bool) { return succ(0) })(n)
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_err/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_abs_err/7.txt")
    func test_examples_stella_core_abs_err_7_txt_7c2d2643() throws {
        let source = #"""
language core;

extend with #unit-type;

fn applyThreeTimes(f : fn(Bool) -> Bool) -> fn(Bool) -> Bool {
  return fn(b : Bool) { return f(f(f(b))) }
}

fn main(_ : Bool) -> fn(Bool) -> Bool {
  return fn(flag : Bool) {
    return applyThreeTimes(fn(x : Nat) { return true })(flag)
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_err/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_abs_err/8.txt")
    func test_examples_stella_core_abs_err_8_txt_5f3639f0() throws {
        let source = #"""
language core;

extend with #unit-type;

fn doubleApply(f : fn(Nat) -> Nat) -> fn(Nat) -> Nat {
  return fn(n : Nat) { return f(f(n)) }
}

fn main(_ : Nat) -> fn(Nat) -> Nat {
  return fn(y : Nat) {
    return doubleApply(fn(x : Bool) { return succ(0) })(y)
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_err/8.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_abs_err/9.txt")
    func test_examples_stella_core_abs_err_9_txt_3b9268dc() throws {
        let source = #"""
language core;

extend with #unit-type;

fn boolTwice(f : Bool) -> fn(Bool) -> Bool {
  return fn(b : Bool) { return f }
}

fn main(p : Bool) -> fn(Bool) -> Bool {
  return fn(b : Bool) {
    return boolTwice(fn(x : Nat) { return false })
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_err/9.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_abs_suc/1.txt")
    func test_examples_stella_core_abs_suc_1_txt_965f3e2f() throws {
        let source = #"""
language core;

fn twice(f : fn(Bool) -> Bool) -> (fn(Bool) -> Bool) {
  return fn (p : Bool) { return f(f(p)) }
}

fn main(_ : Nat) -> Nat {
  return 0
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_suc/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_abs_suc/10.txt")
    func test_examples_stella_core_abs_suc_10_txt_5c139bce() throws {
        let source = #"""
language core;

fn main(_ : Nat) -> fn(Nat) -> Nat {
  return fn(n : Nat) { return if Nat::iszero(n) then 0 else succ(n) }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_suc/10.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_abs_suc/2.txt")
    func test_examples_stella_core_abs_suc_2_txt_35f91df2() throws {
        let source = #"""
language core;

fn main(_ : Nat) -> fn(Bool) -> Bool {
  return fn(b : Bool) { return if b then false else true }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_suc/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_abs_suc/3.txt")
    func test_examples_stella_core_abs_suc_3_txt_4332855a() throws {
        let source = #"""
language core;

fn main(_ : Nat) -> fn(Nat) -> fn(Nat) -> Nat {
  return fn(x : Nat) { return fn(y : Nat) { return succ(x) } }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_suc/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_abs_suc/4.txt")
    func test_examples_stella_core_abs_suc_4_txt_76ee7f2d() throws {
        let source = #"""
language core;

fn twice(f : fn(Nat) -> Nat) -> fn(Nat) -> Nat {
  return fn(x : Nat) { return f(f(x)) }
}

fn main(_ : Nat) -> fn(Nat) -> Nat {
  return fn(n : Nat) { return twice(fn(x : Nat) { return succ(x) })(n) }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_suc/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_abs_suc/5.txt")
    func test_examples_stella_core_abs_suc_5_txt_6083efe8() throws {
        let source = #"""
language core;

fn main(_ : Nat) -> fn(Nat) -> Nat {
  return fn(x : Nat) { return Nat::pred(x) }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_suc/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_abs_suc/6.txt")
    func test_examples_stella_core_abs_suc_6_txt_1e82feb7() throws {
        let source = #"""
language core;

fn main(_ : Nat) -> fn(Nat) -> Bool {
  return fn(x : Nat) { return Nat::iszero(x) }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_suc/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_abs_suc/7.txt")
    func test_examples_stella_core_abs_suc_7_txt_9e4e3bc7() throws {
        let source = #"""
language core;

fn main(_ : Nat) -> fn(Nat) -> Bool {
  return fn(n : Nat) { return if Nat::iszero(n) then true else false }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_suc/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_abs_suc/8.txt")
    func test_examples_stella_core_abs_suc_8_txt_da4200b5() throws {
        let source = #"""
language core;

fn main(_ : Nat) -> fn(Nat) -> fn(Nat) -> Nat {
  return fn(a : Nat) { return fn(b : Nat) { return succ(a) } }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_suc/8.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_abs_suc/9.txt")
    func test_examples_stella_core_abs_suc_9_txt_a79f275a() throws {
        let source = #"""
language core;

fn apply(f : fn(Nat) -> Nat, n : Nat) -> Nat {
  return f(n)
}

fn main(n : Nat) -> Nat {
  return apply(fn(x : Nat) { return succ(x) }, n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_abs_suc/9.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_err/1.txt")
    func test_examples_stella_core_err_1_txt_3f7e355b() throws {
        let source = #"""
language core;

extend with #unit-type;

fn foo(n : Nat) -> Nat {
  return succ(n)
}


fn main(n : Nat) -> Bool {
    return foo(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_err/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_err/10.txt")
    func test_examples_stella_core_err_10_txt_77975813() throws {
        let source = #"""
language core;

extend with #unit-type,#fixpoint-combinator;

fn main(n : Nat) -> Nat {
  return fix(0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_err/10.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_err/11.txt")
    func test_examples_stella_core_err_11_txt_dbda61c2() throws {
        let source = #"""
language core;

extend with #unit-type,#fixpoint-combinator;

fn main(n : Nat) -> Nat {
  return 0(x)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_err/11.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_err/12.txt")
    func test_examples_stella_core_err_12_txt_e62e8dd1() throws {
        let source = #"""
language core;

extend with #unit-type,#fixpoint-combinator;

fn main(b : Bool) -> Nat {
  return true(0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_err/12.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_err/13.txt")
    func test_examples_stella_core_err_13_txt_4c1c4f5e() throws {
        let source = #"""
language core;

extend with #unit-type,#fixpoint-combinator;

fn main(b : Bool) -> Nat {
  return if b then x else 0
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_err/13.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_err/14.txt")
    func test_examples_stella_core_err_14_txt_b871653b() throws {
        let source = #"""
language core;

extend with #unit-type,#fixpoint-combinator;

fn main(b : Bool) -> Nat {
  return if b then x else true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_err/14.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_err/3.txt")
    func test_examples_stella_core_err_3_txt_1feeca23() throws {
        let source = #"""
language core;

extend with #unit-type;

fn mainX(n : Nat) -> Nat {
  return succ(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_err/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_err/4.txt")
    func test_examples_stella_core_err_4_txt_f0dba214() throws {
        let source = #"""
language core;

extend with #unit-type;

fn main(n : Nat) -> Nat {
  return x
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_err/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_err/5.txt")
    func test_examples_stella_core_err_5_txt_31b472f3() throws {
        let source = #"""
language core;

extend with #unit-type;

fn main(b : Bool) -> Bool {
  return if c then true else false
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_err/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_err/6.txt")
    func test_examples_stella_core_err_6_txt_07b7b66d() throws {
        let source = #"""
language core;

extend with #unit-type;

fn main(n : Nat) -> Nat {
  return true
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_err/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_err/7.txt")
    func test_examples_stella_core_err_7_txt_51b77c0e() throws {
        let source = #"""
language core;

extend with #unit-type;

fn main(b : Bool) -> Nat {
  return if b then 0 else false
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_err/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_err/8.txt")
    func test_examples_stella_core_err_8_txt_9b69341e() throws {
        let source = #"""
language core;

extend with #unit-type;

fn main(n : Nat) -> Nat {
  return 0(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_err/8.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_err/9.txt")
    func test_examples_stella_core_err_9_txt_6d9ded4c() throws {
        let source = #"""
language core;

extend with #unit-type;

fn main(b : Bool) -> Nat {
  return true(0)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_err/9.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/stella_core_succ/1.txt")
    func test_examples_stella_core_succ_1_txt_82a98133() throws {
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
            sourceName: "examples/stella_core_succ/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_succ/10.txt")
    func test_examples_stella_core_succ_10_txt_2e645a1c() throws {
        let source = #"""
language core;

fn dec_or_one(n : Nat) -> Nat {
  return if Nat::iszero(n) then succ(0) else Nat::pred(n)
}

fn main(n : Nat) -> Nat {
  return dec_or_one(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_succ/10.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_succ/2.txt")
    func test_examples_stella_core_succ_2_txt_d7e6d3bb() throws {
        let source = #"""
language core;

fn is_zero(n : Nat) -> Bool {
  return Nat::iszero(n)
}

fn main(n : Nat) -> Bool {
  return is_zero(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_succ/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_succ/3.txt")
    func test_examples_stella_core_succ_3_txt_7d01ed9c() throws {
        let source = #"""
language core;

fn previous(n : Nat) -> Nat {
  return Nat::pred(n)
}

fn main(n : Nat) -> Nat {
  return previous(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_succ/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_succ/4.txt")
    func test_examples_stella_core_succ_4_txt_b96e91d2() throws {
        let source = #"""
language core;

fn check_zero(n : Nat) -> Bool {
  return if Nat::iszero(n) then true else false
}

fn main(n : Nat) -> Bool {
  return check_zero(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_succ/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_succ/5.txt")
    func test_examples_stella_core_succ_5_txt_0b4727e5() throws {
        let source = #"""
language core;

fn inc_if_zero(n : Nat) -> Nat {
  return if Nat::iszero(n) then succ(0) else n
}

fn main(n : Nat) -> Nat {
  return inc_if_zero(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_succ/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_succ/6.txt")
    func test_examples_stella_core_succ_6_txt_a9bf4161() throws {
        let source = #"""
language core;

fn flip(b : Bool) -> Bool {
  return if b then false else true
}

fn main(b : Bool) -> Bool {
  return flip(b)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_succ/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_succ/7.txt")
    func test_examples_stella_core_succ_7_txt_7fc4f18d() throws {
        let source = #"""
language core;

fn normalize(n : Nat) -> Nat {
  return Nat::pred(succ(n))
}

fn main(n : Nat) -> Nat {
  return normalize(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_succ/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_succ/8.txt")
    func test_examples_stella_core_succ_8_txt_e9f52834() throws {
        let source = #"""
language core;

fn step_or_zero(n : Nat) -> Nat {
  return if Nat::iszero(n) then 0 else succ(n)
}

fn main(n : Nat) -> Nat {
  return step_or_zero(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_succ/8.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_succ/9.txt")
    func test_examples_stella_core_succ_9_txt_8857b646() throws {
        let source = #"""
language core;

fn was_one(n : Nat) -> Bool {
  return Nat::iszero(Nat::pred(n))
}

fn main(n : Nat) -> Bool {
  return was_one(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_succ/9.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/stella_core_succ/inner_func.txt")
    func test_examples_stella_core_succ_inner_func_txt_2f461b5b() throws {
        let source = #"""
language core;
extend with #nested-function-declarations,#lists,#let-bindings;

fn plus4(n : Nat) -> Nat {
  fn plus2(n : Nat) -> Nat {
    return succ(succ(n))
  }
  return plus2(plus2(n))
}

fn main(n : Nat) -> Nat {
  return plus4(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/stella_core_succ/inner_func.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sum_err/1.txt")
    func test_examples_sum_err_1_txt_3e1b888a() throws {
        let source = #"""
language core;
extend with #structural-subtyping, #sum-types;

fn main(n : Nat) -> Bool + Nat {
  return (fn (x : Nat) {
    return inr(x)
  })(n)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sum_err/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/sum_succ/1.txt")
    func test_examples_sum_succ_1_txt_2dbba9c6() throws {
        let source = #"""
language core;
extend with #sum-types, #unit-type;

fn main(b : Bool) -> Nat + Bool {
    return if b then inl(0) else inr(true)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sum_succ/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sum_succ/10.txt")
    func test_examples_sum_succ_10_txt_a84b966a() throws {
        let source = #"""
language core;
extend with #sum-types,#let-bindings,#type-ascriptions;

fn applyToZero(f : fn(Nat) -> Nat + Bool) -> Nat + Bool {
    return f(0)
}

fn main(m : Nat) -> Nat {
    return let fun = fn(x : Nat) { return inl(succ(x)) as (Nat + Bool) } in
    match applyToZero(fun) {
        inl(n) => n
      | inr(_) => 0
    }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sum_succ/10.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sum_succ/2.txt")
    func test_examples_sum_succ_2_txt_0191c09f() throws {
        let source = #"""
language core;
extend with #sum-types;

fn main(input : Nat + (Bool + (fn(Nat) -> Nat))) -> Nat {
    return match input {
        inl(n) => n
      | inr(inl(true)) => succ(0)
      | inr(inl(false)) => 0
      | inr(inr(f)) => f(0)
    }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sum_succ/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sum_succ/3.txt")
    func test_examples_sum_succ_3_txt_400f3b9d() throws {
        let source = #"""
language core;
extend with #sum-types, #unit-type;

fn toSum(x : Nat) -> Nat + Unit {
    return inl(x)
}

fn main(_ : Nat) -> Nat {
    return match toSum(succ(0)) {
        inl(n) => n
      | inr(_) => 0
    }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sum_succ/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sum_succ/4.txt")
    func test_examples_sum_succ_4_txt_a30f0b48() throws {
        let source = #"""
language core;
extend with #sum-types,#natural-literals;

fn choose(b : Bool) -> Nat + Bool {
    return if b then inl(1) else inr(false)
}

fn main(_ : Bool) -> Nat {
    return match choose(true) {
        inl(n) => n
      | inr(_) => 0
    }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sum_succ/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sum_succ/5.txt")
    func test_examples_sum_succ_5_txt_09cecb8b() throws {
        let source = #"""
language core;
extend with #sum-types,#let-bindings,#type-ascriptions;

fn main(n : Nat) -> Nat {
    return let val = inr(fn(x : Nat) { return succ(x) }) as (Nat + (fn(Nat) -> Nat)) in
    match val {
        inl(n) => n
      | inr(f) => f(0)
    }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sum_succ/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sum_succ/6.txt")
    func test_examples_sum_succ_6_txt_2f15f718() throws {
        let source = #"""
language core;
extend with #sum-types,#comparison-operators;

fn doubleOrZero(n : Nat) -> Nat + Nat {
    return if n == 0 then inl(0) else inr(n)
}

fn main(n : Nat) -> Nat {
    return match doubleOrZero(succ(0)) {
        inl(z) => z
      | inr(x) => succ(x)
    }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sum_succ/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sum_succ/7.txt")
    func test_examples_sum_succ_7_txt_6bf4eb92() throws {
        let source = #"""
language core;
extend with #sum-types;

fn main(n : Nat) -> Bool + (Bool + Bool) {
    return inr(inl(true))
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sum_succ/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sum_succ/8.txt")
    func test_examples_sum_succ_8_txt_d441cd5b() throws {
        let source = #"""
language core;
extend with #sum-types,#structural-patterns,#natural-literals;

fn eval(input : Nat + Bool) -> Nat {
    return match input {
        inl(n) => n
      | inr(true) => 1
      | inr(false) => 0
    }
}

fn main(n : Nat) -> Nat {
    return eval(inr(false))
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sum_succ/8.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/sum_succ/9.txt")
    func test_examples_sum_succ_9_txt_d1e924f6() throws {
        let source = #"""
language core;
extend with #sum-types, #unit-type;

fn main(n : Nat) -> Nat + (Unit + Nat) {
    return inr(inl(unit))
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/sum_succ/9.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/tuple_err/0.txt")
    func test_examples_tuple_err_0_txt_9b7831db() throws {
        let source = #"""
language core;
extend with #tuples;

fn noop(_ : {}) -> {} {
  return {}
}

fn third(tup : {Nat, Nat, Nat}) -> Nat {
  return tup.4
}

fn main(n : Nat) -> Nat {
  return third({n, succ(n), succ(succ(n))})
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/tuple_err/0.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/tuple_err/1.txt")
    func test_examples_tuple_err_1_txt_66782256() throws {
        let source = #"""
language core;
extend with #tuples;

fn noop(_ : {}) -> {} {
  return {}
}

fn third(tup : {Nat, Nat, Nat}) -> Nat {
  return tup.3
}

fn main(n : Nat) -> Nat {
  return third({n, succ(n), succ(succ(n))})
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/tuple_err/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/tuple_err/2.txt")
    func test_examples_tuple_err_2_txt_b3415811() throws {
        let source = #"""
language core;
extend with #tuples;

fn noop(_ : {}) -> {} {
  return {}
}

fn third(tup : {Nat, Nat, Nat}) -> Nat {
  return tup.0
}

fn main(n : Nat) -> Nat {
  return third({n, succ(n), succ(succ(n))})
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/tuple_err/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/tuple_err/3.txt")
    func test_examples_tuple_err_3_txt_6241f2fe() throws {
        let source = #"""
language core;
extend with #tuples,#unit-type;

fn noop(_ : {}) -> {} {
  return {}
}

fn third(tup : {Nat, Nat, Nat}) -> Nat {
  return unit.4
}

fn main(n : Nat) -> Nat {
  return third({n, succ(n), succ(succ(n))})
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/tuple_err/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/tuple_err/4.txt")
    func test_examples_tuple_err_4_txt_17725d1d() throws {
        let source = #"""
language core;
extend with #tuples;

fn noop(_ : {}) -> {} {
  return {}
}

fn third(tup : {Nat, Nat}) -> Nat {
  return tup.2
}

fn main(n : Nat) -> Nat {
  return third({n, succ(n), succ(succ(n))})
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/tuple_err/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/tuple_err/5.txt")
    func test_examples_tuple_err_5_txt_95d01b8b() throws {
        let source = #"""
language core;
extend with #tuples;

fn noop(_ : {}) -> {} {
  return {}
}

fn main(n : Nat) -> Nat {
  return {n, succ(n), succ(succ(n))} as Nat
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/tuple_err/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/unit_succ/1.txt")
    func test_examples_unit_succ_1_txt_99f32931() throws {
        let source = #"""
language core;
extend with #unit-type;

fn ignore(_ : Nat) -> Unit {
  return unit
}

fn main(_ : Nat) -> Unit {
  return unit
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/unit_succ/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/variant_err/1.txt")
    func test_examples_variant_err_1_txt_f3a753e0() throws {
        let source = #"""
language core;
extend with #variants,#unit-type,#type-ascriptions,#natural-literals,#nullary-variant-labels;

fn example(x : Bool) -> <| a : Nat, b |> {
  return if x then <| a = 5 |> else <| b = 4 |>
}

fn main(flag : Nat) -> Nat {
  return flag
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_err/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/variant_err/2.txt")
    func test_examples_variant_err_2_txt_80044af2() throws {
        let source = #"""
language core;
extend with #variants,#unit-type,#type-ascriptions,#natural-literals,#nullary-variant-labels;

fn main( n : Nat ) -> <| a : Nat |> {
  return <| a |> as <| a : Nat |>
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_err/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/variant_err/3.txt")
    func test_examples_variant_err_3_txt_0afa9206() throws {
        let source = #"""
language core;
extend with #variants,#unit-type,#type-ascriptions,#natural-literals,#nullary-variant-labels;

fn example(x : Bool) -> <| a : Nat, b |> {
  return if x then <| a = 5 |> else <| b = 4 |>
}

fn main(flag : Bool) -> Nat {
  return match example(flag) {
      <| a = n |> => succ(n)
    | <| b = n |> => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_err/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/variant_err/4.txt")
    func test_examples_variant_err_4_txt_c4d0c780() throws {
        let source = #"""
language core;
extend with #variants,#unit-type,#type-ascriptions,#natural-literals,#nullary-variant-labels;

fn example(x : Bool) -> <| a : Nat, b |> {
  return if x then <| a = 5 |> else <| b |>
}

fn main(flag : Bool) -> Nat {
  return match example(flag) {
      <| a = n |> => succ(n)
    | <| b = n |> => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_err/4.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/variant_err/5.txt")
    func test_examples_variant_err_5_txt_8a6054b6() throws {
        let source = #"""
language core;
extend with #variants,#unit-type,#type-ascriptions,#natural-literals,#nullary-variant-labels,#structural-patterns;

fn example(x : Bool) -> <| a : Nat, b |> {
  return if x then <| a = 5 |> else <| b |>
}

fn main(flag : Bool) -> Nat {
  return match example(flag) {
      <| a = n |> => succ(n)
    | <| b = unit |> => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_err/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/variant_err/6.txt")
    func test_examples_variant_err_6_txt_5464b5f7() throws {
        let source = #"""
language core;
extend with #variants,#unit-type,#type-ascriptions,#natural-literals,#nullary-variant-labels,#structural-patterns;

fn example(x : Bool) -> <| a : Nat, b : Nat |> {
  return if x then <| a = 5 |> else <| b = 4 |>
}

fn main(flag : Bool) -> Nat {
  return match example(flag) {
      <| a = n |> => succ(n)
    | <| b |> => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_err/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/variant_err/7.txt")
    func test_examples_variant_err_7_txt_14c49c53() throws {
        let source = #"""
language core;
extend with #variants,#unit-type,#type-ascriptions,#natural-literals,#nullary-variant-labels,#structural-patterns;

fn example(x : Bool) -> <| a : Nat, b : Nat |> {
  return if x then <| a = 5 |> else <| b = 4 |>
}

fn main(flag : Bool) -> Nat {
  return match example(flag) {
      <| a = n |> => succ(n)
    | <| c |> => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_err/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("examples/variant_succ/1.txt")
    func test_examples_variant_succ_1_txt_c5868271() throws {
        let source = #"""
language core;
extend with #variants, #unit-type,#structural-patterns;

fn attempt(get_one? : Bool) -> <| value : Nat, failure : Unit |> {
  return if get_one? then <| value = 0 |> else <| failure = unit |>
}

fn main(succeed : Bool) -> Nat {
  return match attempt(succeed) {
      <| value = n |> => succ(n)
    | <| failure = unit |> => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_succ/1.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/variant_succ/10.txt")
    func test_examples_variant_succ_10_txt_32bb12ee() throws {
        let source = #"""
language core;
extend with #variants, #lists,#unit-type,#natural-literals,#structural-patterns;

fn listVar(flag : Bool) -> <| lst : [Nat] |> {
  return if flag then <| lst = [1,2,3] |> else <| lst = [1,2] |>
}

fn main(flag : Bool) -> Nat {
  return match listVar(flag) {
      <| lst = xs |> => List::head(xs)
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_succ/10.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/variant_succ/2.txt")
    func test_examples_variant_succ_2_txt_44296d63() throws {
        let source = #"""
language core;
extend with #variants, #unit-type,#natural-literals,#structural-patterns;

fn nested(flag : Bool) -> <| ok : <| num : Nat |> , err : Unit |> {
  return if flag then <| ok = <| num = 1 |> |> else <| err = unit |>
}

fn main(f : Bool) -> Nat {
  return match nested(f) {
      <| ok = <| num = n |> |> => n
    | <| err = unit |> => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_succ/2.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/variant_succ/3.txt")
    func test_examples_variant_succ_3_txt_c002dc0b() throws {
        let source = #"""
language core;
extend with #variants, #unit-type,#natural-literals,#structural-patterns;

fn example(x : Bool) -> <| a : Nat, b : Unit |> {
  return if x then <| a = 5 |> else <| b = unit |>
}

fn main(flag : Bool) -> Nat {
  return match example(flag) {
      <| a = n |> => succ(n)
    | <| b = unit |> => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_succ/3.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/variant_succ/5.txt")
    func test_examples_variant_succ_5_txt_a2c8e119() throws {
        let source = #"""
language core;
extend with #variants, #unit-type,#natural-literals,#structural-patterns;

fn deep(x : Bool) -> <| outer : <| inner : Nat |> , fail : Unit |> {
  return if x then <| outer = <| inner = 42 |> |> else <| fail = unit |>
}

fn main(flag : Bool) -> Nat {
  return match deep(flag) {
      <| outer = <| inner = n |> |> => n
    | <| fail = unit |> => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_succ/5.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/variant_succ/6.txt")
    func test_examples_variant_succ_6_txt_ab5fc83f() throws {
        let source = #"""
language core;
extend with #variants,#unit-type,#structural-patterns,#natural-literals;

fn boolVar(x : Bool) -> <| yes : Bool, no : Unit |> {
  return if x then <| yes = true |> else <| no = unit |>
}

fn main(flag : Bool) -> Nat {
  return match boolVar(flag) {
      <| yes = true |> => 1
    | <| yes = false |> => 0
    | <| no = unit |> => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_succ/6.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/variant_succ/7.txt")
    func test_examples_variant_succ_7_txt_84696d27() throws {
        let source = #"""
language core;
extend with #variants,#unit-type,#natural-literals,#structural-patterns;

fn valOrZero(x : Bool) -> <| val : Nat, zero : Unit |> {
  return if x then <| val = 7 |> else <| zero = unit |>
}

fn main(flag : Bool) -> Nat {
  return match valOrZero(flag) {
      <| val = n |> => n
    | <| zero = unit |> => 0
  }
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_succ/7.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("examples/variant_succ/8.txt")
    func test_examples_variant_succ_8_txt_2409c3f7() throws {
        let source = #"""
language core;

extend with #unit-type,#variants,#nullary-variant-labels,#type-ascriptions;

fn main(_ : Unit) -> <| value, no : Unit |> {
  return (<|value|> as <| value, no : Unit |>)
}


"""#
        let program = try Program.parser.run(
            sourceName: "examples/variant_succ/8.txt",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }
}
