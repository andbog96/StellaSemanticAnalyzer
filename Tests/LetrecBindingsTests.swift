import Testing
@testable import StellaSemanticAnalyzer

@Suite
@MainActor
struct LetrecBindingsTests {
    @Test
    func illTypedUnexpectedTypeForExpressionTupleOfFuncs2() throws {
        let source = #"""
language core;

extend with #letrec-bindings;
extend with #let-patterns;
extend with #pattern-ascriptions;
extend with #tuples;
extend with #structural-patterns;
extend with #lists;

fn main(n : Nat) -> Nat {
  return letrec {length as fn([Nat]) -> Bool, len as fn([Nat]) -> Nat}
  ={
   fn (xs : [Nat]) {
    return if List::isempty(xs) then 0 else succ(len(List::tail(xs)))
  },
   fn (xs : [Nat]) {
    return if List::isempty(xs) then 0 else succ(length(List::tail(xs)))
  }
  } in n;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/letrec-bindings/ill-typed/unexpected_type_for_expression/tuple-of-funcs 2.stella",
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
    func illTypedUnexpectedTypeForExpressionTupleOfFuncs() throws {
        let source = #"""
language core;

extend with #letrec-bindings;
extend with #let-patterns;
extend with #pattern-ascriptions;
extend with #tuples;
extend with #structural-patterns;
extend with #lists;

fn main(n : Nat) -> Nat {
  return letrec {length as fn([Nat]) -> Bool, len as fn([Nat]) -> Nat}
  ={
   fn (xs : [Nat]) {
    return if List::isempty(xs) then 0 else succ(len(List::tail(xs)))
  },
   fn (xs : [Nat]) {
    return if List::isempty(xs) then 0 else succ(length(List::tail(xs)))
  }
  } in n;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/letrec-bindings/ill-typed/unexpected_type_for_expression/tuple-of-funcs.stella",
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
    func wellTypedTupleOfFuncs() throws {
        let source = #"""
language core;

extend with #letrec-bindings;
extend with #let-patterns;
extend with #pattern-ascriptions;
extend with #tuples;
extend with #structural-patterns;
extend with #lists;

fn main(n : Nat) -> Nat {
  return letrec {length, len} as {fn([Nat]) -> Nat, fn([Nat]) -> Nat}
  ={
   fn (xs : [Nat]) {
    return if List::isempty(xs) then 0 else succ(len(List::tail(xs)))
  },
   fn (xs : [Nat]) {
    return if List::isempty(xs) then 0 else succ(length(List::tail(xs)))
  }
  } in n;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/letrec-bindings/well-typed/tuple-of-funcs.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedTupleOfFuncs2() throws {
        let source = #"""
language core;

extend with #letrec-bindings;
extend with #let-patterns;
extend with #pattern-ascriptions;
extend with #tuples;
extend with #structural-patterns;
extend with #lists;

fn main(n : Nat) -> Nat {
  return letrec {length as fn([Nat]) -> Nat, len as fn([Nat]) -> Nat}
  ={
   fn (xs : [Nat]) {
    return if List::isempty(xs) then 0 else succ(len(List::tail(xs)))
  },
   fn (xs : [Nat]) {
    return if List::isempty(xs) then 0 else succ(length(List::tail(xs)))
  }
  } in n;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/letrec-bindings/well-typed/tuple-of-funcs2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }
}
