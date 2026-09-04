import Testing
@testable import StellaSemanticAnalyzer

@Suite
@MainActor
struct TypeCastPatternsTests {
    @Test
    func illTypedUnexpectedSubtypePrimitive2() throws {
        let source = #"""
language core;
extend with #type-cast-patterns;
extend with #top-type;
extend with #structural-patterns;
extend with #structural-subtyping;


fn main(t : Nat) -> Bool {
  return match t {
    succ(n) cast as Nat => Nat::iszero(n)
    | b cast as Bool => b
    | t => false
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/type-cast-patterns/ill-typed/unexpected_subtype/primitive 2.stella",
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
extend with #type-cast-patterns;
extend with #top-type;
extend with #structural-patterns;
extend with #structural-subtyping;


fn main(t : Nat) -> Bool {
  return match t {
    succ(n) cast as Nat => Nat::iszero(n)
    | b cast as Bool => b
    | t => false
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/type-cast-patterns/ill-typed/unexpected_subtype/primitive.stella",
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
    func wellTypedPrimitive() throws {
        let source = #"""
language core;
extend with #type-cast-patterns;
extend with #top-type;
extend with #structural-patterns;
extend with #structural-subtyping;


fn main(t : Top) -> Bool {
  return match t {
    succ(n) cast as Nat => Nat::iszero(n)
    | b cast as Bool => b
    | t => false
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/type-cast-patterns/well-typed/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }
}
