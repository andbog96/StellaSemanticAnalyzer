import Testing
@testable import StellaSemanticAnalyzer

@Suite
@MainActor
struct CoreTests {
    @Test
    func illTypedAmbiguousListPrimitive() throws {
        let source = #"""
language core;

extend with #lists;

fn main(n : Nat) -> Nat {
  return if List::isempty([]) then 0 else succ(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/ambiguous_list/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_LIST_TYPE")
        }
    }

    @Test
    func illTypedAmbiguousPanicTypePrimitive() throws {
        let source = #"""
language core;
extend with #let-bindings;
extend with #let-patterns;
extend with #panic;

fn main(n : Nat) -> Nat {
  return let a = panic! in 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/ambiguous_panic_type/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_PANIC_TYPE")
        }
    }

    @Test
    func illTypedAmbiguousReferenceTypePrimitive() throws {
        let source = #"""
language core;
extend with #references;
extend with #let-bindings;
extend with #let-patterns;

fn main(a : Nat) -> Nat {
  return let ref = <0x0> in 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/ambiguous_reference_type/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_REFERENCE_TYPE")
        }
    }

    @Test
    func illTypedAmbiguousSumTypePrimitive() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(n : Nat) -> Nat {
  return match (inl(0)) {
    inl(num) => num
    | inr(_) => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/ambiguous_sum_type/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_SUM_TYPE")
        }
    }

    @Test
    func illTypedAmbiguousVariantTypePrimitive() throws {
        let source = #"""
language core;

extend with #variants, #structural-patterns;

fn main(n : Nat) -> Nat {
  return match (<| a = 0 |>) {
    <| a = num |> => num
    | <| b = other |> => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/ambiguous_variant_type/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_AMBIGUOUS_VARIANT_TYPE")
        }
    }

    @Test
    func illTypedDuplicateFunctionDeclarationPrimitive() throws {
        let source = #"""
language core;

fn func(b : Nat) -> Bool {
  return false;
}

fn func(a : Bool) -> Nat {
  return 0;
}

fn main(n : Nat) -> Nat {
  return 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/duplicate_function_declaration/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_FUNCTION_DECLARATION")
        }
    }

    @Test
    func illTypedDuplicateRecordFieldsPrimitive() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : Nat) -> Nat {
  return if { num = 0, bool = false, num = true }.bool
    then succ(0)
    else 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/duplicate_record_fields/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_RECORD_FIELDS")
        }
    }

    @Test
    func illTypedDuplicateRecordTypeFieldsPrimitive() throws {
        let source = #"""
language core;

extend with #records;

fn main(n : { num : Nat, bool : Bool, num : Bool }) -> Nat {
  return 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/duplicate_record_type_fields/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_RECORD_TYPE_FIELDS")
        }
    }

    @Test
    func illTypedDuplicateVariantTypeFieldsPrimitive() throws {
        let source = #"""
language core;

extend with #variants;

fn main(n : <| num : Nat, bool : Bool, num : Bool |>) -> Nat {
  return 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/duplicate_variant_type_fields/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_VARIANT_TYPE_FIELDS")
        }
    }

    @Test
    func illTypedIllegalEmptyMatchingPrimitive() throws {
        let source = #"""
language core;

extend with #sum-types;

fn main(n : Nat + Bool) -> Nat {
  return match n {}
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/illegal_empty_matching/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_ILLEGAL_EMPTY_MATCHING")
        }
    }

    @Test
    func illTypedMissingMainPrimitive() throws {
        let source = #"""
language core;

fn not_main(n : Nat) -> Nat {
  return n
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/missing_main/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_MAIN")
        }
    }

    @Test
    func illTypedMissingRecordFieldsPrimitive() throws {
        let source = #"""
language core;
extend with #records;


fn main(n : Nat) -> { a : Bool, b : Bool } {
  return { a = false }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/missing_record_fields/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_RECORD_FIELDS")
        }
    }

    @Test
    func illTypedMissingRecordFieldsSubtyping() throws {
        let source = #"""
language core;
extend with #records;
extend with #let-bindings;
extend with #let-patterns;
extend with #structural-subtyping;

fn main(n : Nat) -> { a : Nat, b : Bool } {
  return let x = { a = 0 } in x
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/missing_record_fields/subtyping.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_RECORD_FIELDS")
        }
    }

    @Test
    func illTypedNonexhaustiveMatchPatternsPrimitive() throws {
        let source = #"""
language core;
extend with #sum-types;


fn main(n : Nat + Bool) -> Nat {
  return match n {
    inl(num) => num
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/nonexhaustive_match_patterns/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS")
        }
    }

    @Test
    func illTypedNotAFunctionFix() throws {
        let source = #"""
language core;

extend with #let-patterns;
extend with #let-bindings;
extend with #fixpoint-combinator;
extend with #multiparameter-functions;

fn main(n : fn(Nat) -> Nat) -> Nat {
  return let a = fix(0) in a
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/not_a_function/fix.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test
    func illTypedNotAFunctionIfFuncs() throws {
        let source = #"""
language core;

fn f(x : Nat) -> Nat {
  return succ(x)
}

fn g(k : fn(Nat) -> Nat) -> fn(Nat) -> Nat {
  return fn(x : Nat) {
    return k(k(x))
  }
}

fn main(n : Nat) -> Nat {
  return
   (if Nat::iszero(n)
      then f(n)
      else g(f)(n))(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/not_a_function/if-funcs.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test
    func illTypedNotAFunctionPrimitive() throws {
        let source = #"""
language core;


fn main(n : Nat) -> Nat {
  return if n(true) then succ(0) else 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/not_a_function/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test
    func illTypedNotAFunctionTriple() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return (fn(x : Bool) { return fn(y : Nat) { return succ(y) } })(false)(0)(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/not_a_function/triple.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_FUNCTION")
        }
    }

    @Test
    func illTypedNotAListPrimitive() throws {
        let source = #"""
language core;
extend with #lists;

fn main(n : Nat) -> Nat {
  return if List::isempty(n) then succ(0) else 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/not_a_list/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_LIST")
        }
    }

    @Test
    func illTypedNotARecordPrimitive() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> Nat {
  return if n.status then succ(0) else 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/not_a_record/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_RECORD")
        }
    }

    @Test
    func illTypedNotAReferencePrimitive() throws {
        let source = #"""
language core;

extend with #unit-type;
extend with #references;


fn main(n : Nat) -> Unit {
  return 0 := false
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/not_a_reference/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_REFERENCE")
        }
    }

    @Test
    func illTypedNotATuplePrimitive() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> Nat {
  return if n.2 then succ(0) else 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/not_a_tuple/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_NOT_A_TUPLE")
        }
    }

    @Test
    func illTypedTupleIndexOutOfBoundsPrimitive() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : {Nat, Bool, Nat}) -> Nat {
  return if n.4 then succ(0) else 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/tuple_index_out_of_bounds/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_TUPLE_INDEX_OUT_OF_BOUNDS")
        }
    }

    @Test
    func illTypedUndefinedVariablePrimitive() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return a;
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/undefined_variable/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNDEFINED_VARIABLE")
        }
    }

    @Test
    func illTypedUnexpectedFieldAccessPrimitive() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : { num : Nat, bool : Bool }) -> Nat {
  return n.status;
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_field_access/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_FIELD_ACCESS")
        }
    }

    @Test
    func illTypedUnexpectedInjectionPrimitive() throws {
        let source = #"""
language core;
extend with #sum-types;

fn main(n : Nat) -> Nat {
  return inl(n);
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_injection/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_INJECTION")
        }
    }

    @Test
    func illTypedUnexpectedLambdaPrimitive() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return fn(a : Bool) {
    return if a then 0 else succ(0);
  };
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_lambda/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_LAMBDA")
        }
    }

    @Test
    func illTypedUnexpectedListPrimitive() throws {
        let source = #"""
language core;
extend with #lists;

fn main(n : Nat) -> Nat {
  return [0, succ(0)];
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_list/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_LIST")
        }
    }

    @Test
    func illTypedUnexpectedMemoryAddressPrimitive() throws {
        let source = #"""
language core;
extend with #references;
extend with #let-bindings;
extend with #let-patterns;

fn main(a : Nat) -> Nat {
  return <0x0>
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_memory_address/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_MEMORY_ADDRESS")
        }
    }

    @Test
    func illTypedUnexpectedPatternForTypePrimitive() throws {
        let source = #"""
language core;
extend with #sum-types, #variants;

fn main(n : Nat + Bool) -> Nat {
  return match n {
    inl(num) => num
    | inr(_) => 0
    | <| value = _ |> => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_pattern_for_type/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_PATTERN_FOR_TYPE")
        }
    }

    @Test
    func illTypedUnexpectedRecordPrimitive() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> Nat {
  return { a = 0, b = false }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_record/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_RECORD")
        }
    }

    @Test
    func illTypedUnexpectedRecordFieldsPrimitive() throws {
        let source = #"""
language core;
extend with #records;

fn main(n : Nat) -> { a : Nat, b : Bool } {
  return { a = 0, b = false, c = succ(0) }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_record_fields/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_RECORD_FIELDS")
        }
    }

    @Test
    func illTypedUnexpectedReferencePrimitive() throws {
        let source = #"""
language core;

extend with #unit-type;
extend with #references;


fn main(n : Nat) -> Unit {
  return new(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_reference/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_REFERENCE")
        }
    }

    @Test
    func illTypedUnexpectedSubtypeInvariantRefWithBot() throws {
        let source = #"""
language core;

extend with #structural-subtyping;
extend with #references;
extend with #top-type;
extend with #bottom-type;
extend with #let-bindings;
extend with #let-patterns;
extend with #records;

fn use(rec : &{ a : Nat, b : Bool }) -> Nat {
  return (*rec).a
}

fn main(n : Bot) -> Nat {
  return let x = new(n) in use(x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_subtype/invariant-ref-with-bot.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test
    func illTypedUnexpectedSubtypeInvariantRefWithTopInCtx() throws {
        let source = #"""
language core;

extend with #structural-subtyping;
extend with #references;
extend with #top-type;
extend with #bottom-type;
extend with #let-bindings;
extend with #let-patterns;
extend with #records;

fn use(rec : &{ a : Nat, b : Bool }) -> Nat {
  return (*rec).a
}

fn main(n : Top) -> Nat {
  return use(new(n))
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_subtype/invariant-ref-with-top-in-ctx.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test
    func illTypedUnexpectedSubtypeInvariantRefWithTop() throws {
        let source = #"""
language core;

extend with #structural-subtyping;
extend with #references;
extend with #top-type;
extend with #bottom-type;
extend with #let-bindings;
extend with #let-patterns;
extend with #records;

fn use(rec : &{ a : Nat, b : Bool }) -> Nat {
  return (*rec).a
}

fn main(n : Top) -> Nat {
  return let x = new(n) in use(x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_subtype/invariant-ref-with-top.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test
    func illTypedUnexpectedSubtypePrimitive() throws {
        let source = #"""
language core;

extend with #structural-subtyping;

fn main(n : Nat) -> Bool {
  return 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_subtype/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test
    func illTypedUnexpectedSubtypeRefChain() throws {
        let source = #"""
language core;

extend with #structural-subtyping;
extend with #references;
extend with #top-type;
extend with #bottom-type;
extend with #let-bindings;
extend with #let-patterns;
extend with #records;
extend with #unit-type;
extend with #lists;
extend with #sequencing;


fn consume(a : &Nat) -> Nat {
  return *a
}

fn supply(a : Nat) -> &Top {
  return new(a)
}

fn main(n : Nat) -> Nat {
  return consume(supply(n))
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_subtype/ref-chain.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_SUBTYPE")
        }
    }

    @Test
    func illTypedUnexpectedTuplePrimitive() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> Nat {
  return {0, false}
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_tuple/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE")
        }
    }

    @Test
    func illTypedUnexpectedTupleLengthPrimitive() throws {
        let source = #"""
language core;
extend with #tuples;

fn main(n : Nat) -> {Nat, Bool} {
  return {0, false, succ(0)}
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_tuple_length/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TUPLE_LENGTH")
        }
    }

    @Test
    func illTypedUnexpectedTypeForExpressionPrimitive() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return false;
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_type_for_expression/primitive.stella",
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
    func illTypedUnexpectedTypeForExpressionSubFnStack() throws {
        let source = #"""
language core;

extend with
  #sequencing;
extend with #records;
extend with #bottom-type;
extend with #panic;

fn test(n : Nat) -> fn({a : Nat}) -> Bot {
  return fn(rec : {a : Nat}) {
    return panic!
  }
}

fn main(n : Nat) -> fn({a : Nat, b : Bool}) -> Bool {
  return test(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_type_for_expression/sub-fn-stack.stella",
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
    func illTypedUnexpectedTypeForExpressionSubListStack() throws {
        let source = #"""
language core;

extend with #records;
extend with #sum-types;
extend with #tuples;
extend with #lists;

fn test(n : Nat) -> [{a : Nat, b : Bool}] {
  return []
}

fn main(n : Nat) -> [{a : Nat}] {
  return test(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_type_for_expression/sub-list-stack.stella",
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
    func illTypedUnexpectedTypeForExpressionSubRecStack() throws {
        let source = #"""
language core;

extend with #records;

fn test(n : Nat) -> {a : {a : Nat, b : Bool}, b : Bool} {
  return { a = { a = 0, b = false }, b = false }
}

fn main(n : Nat) -> {a : {a : Nat}} {
  return test(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_type_for_expression/sub-rec-stack.stella",
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
    func illTypedUnexpectedTypeForExpressionSubStack() throws {
        let source = #"""
language core;

extend with
  #unit-type,
  #references,
  #arithmetic-operators,
  #sequencing,
  #natural-literals;
extend with #records;
extend with #bottom-type;
extend with #panic;
extend with #variants;

fn test(n : Nat) -> {a : <| c : Nat |>, b : Bool} {
  return { a = <| c = 0 |>, b = false }
}

fn main(n : Nat) -> {a : <| c : Nat, d : Bool |>} {
  return test(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_type_for_expression/sub-stack.stella",
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
    func illTypedUnexpectedTypeForExpressionSubSumStack() throws {
        let source = #"""
language core;

extend with #records;
extend with #sum-types;

fn test(n : Nat) -> {a : Nat, b : Bool} + Nat {
  return inl({ a = 0, b = false })
}

fn main(n : Nat) -> {a : Nat} + Nat {
  return test(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_type_for_expression/sub-sum-stack.stella",
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
    func illTypedUnexpectedTypeForExpressionSubTupleStack() throws {
        let source = #"""
language core;

extend with #records;
extend with #sum-types;
extend with #tuples;

fn test(n : Nat) -> {{a : Nat, b : Bool}, Nat} {
  return {{ a = 0, b = false }, 0}
}

fn main(n : Nat) -> {{a : Nat}, Nat} {
  return test(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_type_for_expression/sub-tuple-stack.stella",
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
    func illTypedUnexpectedTypeForExpressionSubVarStack() throws {
        let source = #"""
language core;

extend with
  #unit-type,
  #references,
  #arithmetic-operators,
  #sequencing,
  #natural-literals;
extend with #records;
extend with #bottom-type;
extend with #panic;
extend with #variants;

fn test(n : Nat) -> <| c : <| c : Nat |> |> {
  return <| c = <| c = 0 |> |>
}

fn main(n : Nat) -> <| c : <| c : Nat, d : Bool |>, d : Bool |> {
  return test(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_type_for_expression/sub-var-stack.stella",
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
    func illTypedUnexpectedTypeForParameterPrimitive() throws {
        let source = #"""
language core;


fn main(n : Nat) -> (fn (Nat) -> Bool) {
  return fn (a : Bool) {
    return a;
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_type_for_parameter/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_TYPE_FOR_PARAMETER")
        }
    }

    @Test
    func illTypedUnexpectedVariantPrimitive() throws {
        let source = #"""
language core;
extend with #variants;

fn main(n : Nat) -> Nat {
  return <| a = succ(0) |>;
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_variant/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_VARIANT")
        }
    }

    @Test
    func illTypedUnexpectedVariantLabelPrimitive() throws {
        let source = #"""
language core;
extend with #variants;

fn main(n : Nat) -> <| a : Bool, b : Nat |> {
  return <| c = succ(0) |>;
}
"""#
        let program = try Program.parser.run(
            sourceName: "ill-typed/unexpected_variant_label/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_VARIANT_LABEL")
        }
    }

    @Test
    func wellTypedAbstraction() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return (fn(x : Bool) { return fn(y : Nat) { return succ(y) } })(false)(0);
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/abstraction.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedAscription() throws {
        let source = #"""
language core;

extend with #sum-types;
extend with #type-ascriptions;

fn main(n : Nat) -> Nat + Bool {
  return (fn (b : Bool) { return inl(n) as (Nat + Bool) })(true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/ascription.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedDeref() throws {
        let source = #"""
language core;

extend with #structural-subtyping;
extend with #references;
extend with #top-type;
extend with #bottom-type;
extend with #let-bindings;
extend with #let-patterns;
extend with #records;
extend with #unit-type;
extend with #lists;
extend with #sequencing;

fn main(n : &{ a : Nat, b : Bool }) -> { a : Nat } {
  return *n
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/deref.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedFactorial() throws {
        let source = #"""
language core;


fn Nat2Nat::const(f : fn(Nat) -> Nat) -> (fn(Nat) -> (fn(Nat) -> Nat)) {
  return fn(x : Nat) { return f }
}


fn Nat::add(n : Nat) -> (fn(Nat) -> Nat) {
  return fn(m : Nat) {
    return Nat::rec(n, m, fn(i : Nat) {
      return fn(r : Nat) { return succ(r) } })
  }
}


fn Nat::mul(n : Nat) -> (fn(Nat) -> Nat) {
  return fn(m : Nat) {
    return Nat::rec(n, 0, Nat2Nat::const(Nat::add(m)))
  }
}


fn factorial(n : Nat) -> Nat {
  return Nat::rec(n, succ(0), fn(i : Nat) {
    return fn(r : Nat) {
    return Nat::mul(r)(succ(i))
  } })
}

fn main(n : Nat) -> Nat {
  return factorial(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/factorial.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedFixPrimitive() throws {
        let source = #"""
language core;

extend with #let-patterns;
extend with #let-bindings;
extend with #fixpoint-combinator;
extend with #multiparameter-functions;

fn main(n : fn(Nat) -> Nat) -> Nat {
  return let a = fix(n) in a
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/fix-primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedFuncChain() throws {
        let source = #"""
language core;

fn function_chooser(flag : Bool) -> (fn(fn(Nat) -> Nat) -> (fn(fn(Nat) -> Nat) -> (fn(Nat) -> Nat))){
    return fn(first : (fn(Nat) -> Nat) ) {
        return fn(second : (fn(Nat) -> Nat) ) {
            return if flag then first else second
        }
    }
}

fn add_once(a : Nat) -> Nat {
    return succ(a)
}

fn add_twice(a : Nat) -> Nat {
    return succ(add_once(a))
}

fn main(n : Nat) -> Nat {
    return function_chooser(false)(add_once)(add_twice)(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/func-chain.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedFuncChain2() throws {
        let source = #"""
language core;

fn main(n : Nat) -> Nat {
  return (fn(x : Bool) { return fn(y : Nat) { return fn(i : Nat) { return succ(y) } } })(false)(0)(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/func-chain2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedIfFuncs() throws {
        let source = #"""
language core;

fn f(x : Nat) -> Nat {
  return succ(x)
}

fn g(k : fn(Nat) -> Nat) -> fn(Nat) -> Nat {
  return fn(x : Nat) {
    return k(k(x))
  }
}

fn main(n : Nat) -> Nat {
  return
   (if Nat::iszero(n)
      then f
      else g(f))(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/if-funcs.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedInferredMem() throws {
        let source = #"""
language core;
extend with #references;

fn main(a : Nat) -> Nat {
  return *<0x0>
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/inferred-mem.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedInvariantRefWithBotInCtx() throws {
        let source = #"""
language core;

extend with #structural-subtyping;
extend with #references;
extend with #top-type;
extend with #bottom-type;
extend with #let-bindings;
extend with #let-patterns;
extend with #records;

fn use(rec : &{ a : Nat, b : Bool }) -> Nat {
  return (*rec).a
}

fn main(n : Bot) -> Nat {
  return use(new(n))
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/invariant-ref-with-bot-in-ctx.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedInvariantRef() throws {
        let source = #"""
language core;

extend with #structural-subtyping;
extend with #references;
extend with #top-type;
extend with #bottom-type;
extend with #let-bindings;
extend with #let-patterns;
extend with #records;

fn use(rec : &{ a : Nat, b : Bool }) -> Nat {
  return (*rec).a
}

fn main(n : Nat) -> Nat {
  return let x = new({ b = false, a = 0 }) in use(x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/invariant-ref.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedLists() throws {
        let source = #"""
language core;
extend with #lists;

fn nonempty(list : [Nat]) -> Bool {
  return if List::isempty(list) then true else false
}

fn first_or_default(list : [Nat]) -> Nat {
  return if nonempty(list) then List::head(list) else 0
}

fn main(default : Nat) -> Nat {
  return first_or_default([])
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/lists.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedLogic() throws {
        let source = #"""
language core;


fn Bool::not(b : Bool) -> Bool {
  return if b then false else true
}


fn Bool::or(a : Bool) -> (fn(Bool) -> Bool) {
  return fn(b : Bool) {
    return if a then true else b
  }
}


fn Bool::and(a : Bool) -> (fn(Bool)->Bool) {
  return fn(b : Bool) {
    return if a then b else false
  }
}


fn Bool::xor(a : Bool) -> (fn(Bool)->Bool) {
  return fn(b : Bool) {
    return
        Bool::or(Bool::and(a)(Bool::not(b)))(Bool::and(Bool::not(a))(b))
  }
}


fn main(n : Bool) -> Bool {
  return Bool::xor
    (Bool::and
      (n)
      (Bool::not(n)))
    (Bool::or
      (Bool::not(n))
      (n))
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/logic.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedMath() throws {
        let source = #"""
language core;


fn Nat2Nat::const(f : fn(Nat) -> Nat) -> (fn(Nat) -> (fn(Nat) -> Nat)) {
  return fn(x : Nat) { return f }
}


fn Nat::add(n : Nat) -> fn(Nat) -> Nat {
  return fn(m : Nat) {
    return Nat::rec(n, m, fn(i : Nat) {
      return fn(r : Nat) {
        return succ( r )
      }
    })
  }
}


fn square(n : Nat) -> Nat {
  return Nat::rec(n, 0, fn(i : Nat) {
      return fn(r : Nat) {

        return Nat::add(i)( Nat::add(i)( succ(r) ))
      }
  })
}


fn Nat::mul(n : Nat) -> (fn(Nat) -> Nat) {
  return fn(m : Nat) {
    return Nat::rec(n, 0, Nat2Nat::const(Nat::add(m)))
  }
}

fn cube(n : Nat) -> Nat {
  return Nat::rec(n, 0, fn(i : Nat) {
      return fn(r : Nat) {

        return Nat::add(i)( Nat::add(Nat::mul(square(i))(succ(succ(succ(0))))) ( Nat::add(i) ( Nat::add(i) ( succ(r) ) ) ))
      }
  })
}

fn main(n : Nat) -> Nat {
  return cube(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/math.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedPairs() throws {
        let source = #"""
language core;
extend with #pairs;

fn add(t : {Nat, Nat}) -> Nat {
  return t.1;
}

fn main(n : Nat) -> Nat {
  return {succ(n), {succ(succ(n)), n}}.2.1
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/pairs.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedRecords() throws {
        let source = #"""
language core;

extend with #records;

fn iterate(n : Nat) -> { current : Nat, next : Nat} {
  return { current = n, next = succ(n) }
}

fn main(n : Nat) -> Nat {
  return iterate(0).next
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/records.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedRefAssign() throws {
        let source = #"""
language core;

extend with #structural-subtyping;
extend with #references;
extend with #top-type;
extend with #bottom-type;
extend with #let-bindings;
extend with #let-patterns;
extend with #records;
extend with #unit-type;
extend with #lists;
extend with #sequencing;


fn main(n : Bot) -> Nat {
  return let x = new(0) in x := n; *x
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/ref-assign.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedRefs() throws {
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
            sourceName: "well-typed/refs.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedSample() throws {
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
            sourceName: "well-typed/sample.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedShadowing() throws {
        let source = #"""
language core;

fn f(a : Bool) -> (fn(Nat)-> Nat){
  return fn(a : Nat) {
    return succ(a);
  }
}

fn main(n : Nat) -> Nat {
  return f(false)(n);
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/shadowing.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedSquare() throws {
        let source = #"""
language core;


fn Nat::add(n : Nat) -> fn(Nat) -> Nat {
  return fn(m : Nat) {
    return Nat::rec(n, m, fn(i : Nat) {
      return fn(r : Nat) {
        return succ( r )
      }
    })
  }
}


fn square(n : Nat) -> Nat {
  return Nat::rec(n, 0, fn(i : Nat) {
      return fn(r : Nat) {

        return Nat::add(i)( Nat::add(i)( succ( r )))
      }
  })
}

fn main(n : Nat) -> Nat {
  return square(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/square.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedSubFnStack() throws {
        let source = #"""
language core;

extend with
  #sequencing,
  #structural-subtyping;
extend with #records;
extend with #bottom-type;
extend with #panic;

fn test(n : Nat) -> fn({a : Nat}) -> Bot {
  return fn(rec : {a : Nat}) {
    return panic!
  }
}

fn main(n : Nat) -> fn({a : Nat, b : Bool}) -> Bool {
  return test(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/sub-fn-stack.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedSubListStack() throws {
        let source = #"""
language core;

extend with #structural-subtyping;
extend with #records;
extend with #sum-types;
extend with #tuples;
extend with #lists;

fn test(n : Nat) -> [{a : Nat, b : Bool}] {
  return []
}

fn main(n : Nat) -> [{a : Nat}] {
  return test(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/sub-list-stack.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedSubRecStack() throws {
        let source = #"""
language core;

extend with #structural-subtyping;
extend with #records;

fn test(n : Nat) -> {a : {a : Nat, b : Bool}, b : Bool} {
  return { a = { a = 0, b = false }, b = false }
}

fn main(n : Nat) -> {a : {a : Nat}} {
  return test(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/sub-rec-stack.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedSubStack() throws {
        let source = #"""
language core;

extend with
  #unit-type,
  #references,
  #arithmetic-operators,
  #sequencing,
  #natural-literals,
  #structural-subtyping;
extend with #records;
extend with #bottom-type;
extend with #panic;
extend with #variants;

fn test(n : Nat) -> {a : <| c : Nat |>, b : Bool} {
  return { a = <| c = 0 |>, b = false }
}

fn main(n : Nat) -> {a : <| c : Nat, d : Bool |>} {
  return test(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/sub-stack.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedSubSumStack() throws {
        let source = #"""
language core;

extend with #structural-subtyping;
extend with #records;
extend with #sum-types;

fn test(n : Nat) -> {a : Nat, b : Bool} + Nat {
  return inl({ a = 0, b = false })
}

fn main(n : Nat) -> {a : Nat} + Nat {
  return test(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/sub-sum-stack.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedSubTupleStack() throws {
        let source = #"""
language core;

extend with #structural-subtyping;
extend with #records;
extend with #sum-types;
extend with #tuples;

fn test(n : Nat) -> {{a : Nat, b : Bool}, Nat} {
  return {{ a = 0, b = false }, 0}
}

fn main(n : Nat) -> {{a : Nat}, Nat} {
  return test(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/sub-tuple-stack.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedSubVarStack() throws {
        let source = #"""
language core;

extend with
  #unit-type,
  #references,
  #arithmetic-operators,
  #sequencing,
  #natural-literals,
  #structural-subtyping;
extend with #records;
extend with #bottom-type;
extend with #panic;
extend with #variants;

fn test(n : Nat) -> <| c : <| c : Nat |> |> {
  return <| c = <| c = 0 |> |>
}

fn main(n : Nat) -> <| c : <| c : Nat, d : Bool |>, d : Bool |> {
  return test(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/sub-var-stack.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedSumTypes() throws {
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
            sourceName: "well-typed/sum-types.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedTuples() throws {
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
            sourceName: "well-typed/tuples.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedUnit() throws {
        let source = #"""
language core;
extend with #unit-type;

fn main(_ : Nat) -> Unit {
  return unit
}
"""#
        let program = try Program.parser.run(
            sourceName: "well-typed/unit.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }
}
