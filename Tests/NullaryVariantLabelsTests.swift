import Testing
@testable import StellaSemanticAnalyzer

@Suite
@MainActor
struct NullaryVariantLabelsTests {
    @Test
    func illTypedMissingDataForLabelPrimitive() throws {
        let source = #"""
language core;
extend with #variants;
extend with #nullary-variant-labels;

fn main(n : Nat) -> <| a : Nat |> {
  return <| a |>;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/nullary-variant-labels/ill-typed/missing_data_for_label/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_MISSING_DATA_FOR_LABEL")
        }
    }

    @Test
    func illTypedUnexpectedDataForNullaryLabelPrimitive() throws {
        let source = #"""
language core;
extend with #variants;
extend with #nullary-variant-labels;

fn main(n : Nat) -> <| a |> {
  return <| a = 0 |>;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/nullary-variant-labels/ill-typed/unexpected_data_for_nullary_label/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_DATA_FOR_NULLARY_LABEL")
        }
    }

    @Test
    func illTypedUnexpectedNonNullaryVariantPatternPrimitive() throws {
        let source = #"""
language core;
extend with #variants;
extend with #nullary-variant-labels;
extend with #structural-patterns;

fn main(n : <| a, b : Bool |>) -> Nat {
  return match n {
    <| a = a |> => 0
    | <| b = bool |> => succ(0);
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/nullary-variant-labels/ill-typed/unexpected_non_nullary_variant_pattern/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_NON_NULLARY_VARIANT_PATTERN")
        }
    }

    @Test
    func illTypedUnexpectedNullaryVariantPatternPrimitive() throws {
        let source = #"""
language core;
extend with #variants;
extend with #nullary-variant-labels;
extend with #structural-patterns;

fn main(n : <| a : Nat, b : Bool |>) -> Nat {
  return match n {
    <| a |> => 0
    | <| b = bool |> => succ(0);
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/nullary-variant-labels/ill-typed/unexpected_nullary_variant_pattern/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_UNEXPECTED_NULLARY_VARIANT_PATTERN")
        }
    }

    @Test
    func wellTypedMatch() throws {
        let source = #"""
language core;
extend with #variants;
extend with #nullary-variant-labels;
extend with #structural-patterns;

fn main(n : <| a, b : Bool |>) -> Nat {
  return match n {
    <| a |> => 0
    | <| b = bool |> => succ(0);
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/nullary-variant-labels/well-typed/match.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test
    func wellTypedPrimitive() throws {
        let source = #"""
language core;
extend with #variants;
extend with #nullary-variant-labels;

fn main(n : <| a |>) -> <| a |> {
  return <| a |>;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/nullary-variant-labels/well-typed/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }
}
