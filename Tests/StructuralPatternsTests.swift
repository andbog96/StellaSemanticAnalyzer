import Testing
@testable import StellaSemanticAnalyzer

@Suite
@MainActor
struct StructuralPatternsTests {
    @Test
    func illTypedDuplicateRecordPatternFieldsRecord() throws {
        let source = #"""
language core;
extend with #structural-patterns, #sum-types, #natural-literals, #tuples;
extend with #records, #lists, #unit-type, #variants;

fn main(input : { a : Nat, b : Bool }) -> Nat {
 return
   match input {
    { a = 0, b = false } => 0
    | { a = n, b = true } => succ(n)
    | { a = succ(0), a = false } => 0
    | r => r.a
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/structural-patterns/ill-typed/duplicate_record_pattern_fields/record.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_RECORD_PATTERN_FIELDS")
        }
    }

    @Test
    func illTypedNonexhaustiveMatchPatternsBool() throws {
        let source = #"""
language core;
extend with #structural-patterns, #sum-types, #natural-literals, #tuples;
extend with #records, #lists, #unit-type, #variants;

fn main(input : Bool) -> Nat {
 return
   match input {
    false => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/structural-patterns/ill-typed/nonexhaustive_match_patterns/bool.stella",
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
    func illTypedUnexpectedPatternForTypeBool() throws {
        let source = #"""
language core;
extend with #structural-patterns, #sum-types, #natural-literals, #tuples;
extend with #records, #lists, #unit-type, #variants;

fn main(input : Bool) -> Nat {
 return
   match input {
    false => 0
    | 0 => succ(0)
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/structural-patterns/ill-typed/unexpected_pattern_for_type/bool.stella",
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
    func illTypedUnexpectedPatternForTypeRecord() throws {
        let source = #"""
language core;
extend with #structural-patterns, #sum-types, #natural-literals, #tuples;
extend with #records, #lists, #unit-type, #variants;

fn main(input : { a : Nat, b : Bool }) -> Nat {
 return
   match input {
    { a = 0, b = false } => 0
    |{ a = 0 } => succ(0)
    |n => n.a
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/structural-patterns/ill-typed/unexpected_pattern_for_type/record.stella",
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
    func illTypedUnexpectedPatternForTypeUnit() throws {
        let source = #"""
language core;
extend with #structural-patterns, #sum-types, #natural-literals, #tuples;
extend with #records, #lists, #unit-type, #variants;

fn main(input : Unit) -> Nat {
 return
   match input {
    0 => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/structural-patterns/ill-typed/unexpected_pattern_for_type/unit.stella",
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
    func wellTypedBool() throws {
        let source = #"""
language core;
extend with #structural-patterns, #sum-types, #natural-literals, #tuples;
extend with #records, #lists, #unit-type, #variants;

fn main(input : Bool) -> Nat {
 return
   match input {
    false => 0
    | true => succ(0)
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/structural-patterns/well-typed/bool.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedHell() throws {
        let source = #"""
language core;
extend with #structural-patterns, #sum-types, #natural-literals, #tuples;
extend with #records, #lists, #unit-type, #variants;

fn main(input : { a : {Nat, Nat}, b : <| c : Bool + Bool, d : [Bool], e : Nat |> }) -> Nat {
 return
   match input {
    { a = { 0, succ(a) }, b = <| c = inl(false) |> } => 0
    |{ a = { succ(a), 0 }, b = <| d = cons(_1, _2) |> } => succ(0)
    |{ a = { 0, 0 }, b = <| c = inl(false) |> } => succ(0)
    |{ a = a, b = <| e = _ |> } => a.1
    |{ a = {a1, a2}, b = <| d = [d1, true, false, d4] |> } => if d4 then a1 else a2
    | _ => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/structural-patterns/well-typed/hell.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedList() throws {
        let source = #"""
language core;
extend with #structural-patterns, #sum-types, #natural-literals, #tuples;
extend with #records, #lists, #unit-type, #variants;

fn main(input : [Nat]) -> Nat {
 return
   match input {
    [] => 0
    | [a, 0] => succ(0)
    | cons(a, []) => a
    | cons(_1, cons(_2, cons(a, rest))) => a
    | cons(a, cons(succ(n), rest)) => n
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/structural-patterns/well-typed/list.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedNat() throws {
        let source = #"""
language core;
extend with #structural-patterns, #sum-types, #natural-literals, #tuples;
extend with #records, #lists, #unit-type, #variants;

fn main(input : Nat) -> Nat {
 return
   match input {
     0 => 0
     | succ(succ(succ(succ(succ(succ(n)))))) => 0
     | 4 => 0
     | 2 => 0
     | 5 => 0
     | 7 => 0
     | 6 => 0
     | succ(succ(succ(0))) => 0
     | succ(0) => 0
     | 9 => 0
     | 8 => 0
     | 10 => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/structural-patterns/well-typed/nat.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedNat2() throws {
        let source = #"""
language core;
extend with #structural-patterns;

fn main(n : Nat) -> Nat {
  return match n {
    succ(succ(succ(0))) => 0
    | 7 => 0
    | succ(succ(succ(n))) => n
    | 0 => 0
    | 1 => succ(0)
    | 2 => succ(succ(0))
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/structural-patterns/well-typed/nat2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedRecord() throws {
        let source = #"""
language core;
extend with #structural-patterns, #sum-types, #natural-literals, #tuples;
extend with #records, #lists, #unit-type, #variants;

fn main(input : { a : Nat, b : Bool }) -> Nat {
 return
   match input {
    { a = 0, b = false } => 0
    | { a = n, b = true } => succ(n)
    | { a = succ(0), b = false } => 0
    | r => r.a
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/structural-patterns/well-typed/record.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedTuple() throws {
        let source = #"""
language core;
extend with #structural-patterns, #sum-types, #natural-literals, #tuples;
extend with #records, #lists, #unit-type, #variants;

fn main(input : { Nat, Bool }) -> Nat {
 return
   match input {
    { 0, false } => 0
    |{ succ(n), bool } => n
    |{ 0, bool } => succ(0)
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/structural-patterns/well-typed/tuple.stella",
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
extend with #structural-patterns, #sum-types, #natural-literals, #tuples;
extend with #records, #lists, #unit-type, #variants;

fn main(input : Unit) -> Nat {
 return
   match input {
    unit => 0
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/structural-patterns/well-typed/unit.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }
}
