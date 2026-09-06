import Testing
@testable import StellaSemanticAnalyzer

@Suite
@MainActor
struct NaturalLiteralsTests {
    @Test
    func illTypedUnexpectedTypeForExpressionPrimitive() throws {
        let source = #"""
language core;
extend with #natural-literals;


fn main(n : Nat) -> Bool {
  return 25;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/natural-literals/ill-typed/unexpected_type_for_expression/primitive.stella",
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
    func wellTypedPrimitive() throws {
        let source = #"""
language core;
extend with #natural-literals;


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
  return Nat::add(15)(square(10))
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/natural-literals/well-typed/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }
}
