import Testing
@testable import StellaSemanticAnalyzer

@Suite
@MainActor
struct NestedFunctionDeclarationsTests {
    @Test
    func illTypedUndefinedVariableFactorial2() throws {
        let source = #"""
language core;

extend with #nested-function-declarations;


fn factorial(n : Nat) -> Nat {

  fn Nat::add(n : Nat) -> (fn(Nat) -> Nat) {

    fn Nat2Nat::const(f : fn(Nat) -> Nat) -> (fn(Nat) -> (fn(Nat) -> Nat)) {
      return fn(x : Nat) { return f }
    }

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
            sourceName: "extra/nested-function-declarations/ill-typed/undefined_variable/factorial 2.stella",
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
    func illTypedUndefinedVariableFactorial() throws {
        let source = #"""
language core;

extend with #nested-function-declarations;


fn factorial(n : Nat) -> Nat {

  fn Nat::add(n : Nat) -> (fn(Nat) -> Nat) {

    fn Nat2Nat::const(f : fn(Nat) -> Nat) -> (fn(Nat) -> (fn(Nat) -> Nat)) {
      return fn(x : Nat) { return f }
    }

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
            sourceName: "extra/nested-function-declarations/ill-typed/undefined_variable/factorial.stella",
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
    func illTypedUndefinedVariablePrimitive2() throws {
        let source = #"""
language core;
extend with #nested-function-declarations;
extend with #let-bindings;
extend with #let-patterns;


fn twice(f : fn(Bool) -> Bool) -> (fn(Bool) -> Bool) {
  fn result(x : Bool) -> Bool {
    return f(g(x));
  }
  return let g = f in result;
}

fn main(n : Nat) -> Bool {
  return false;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/nested-function-declarations/ill-typed/undefined_variable/primitive 2.stella",
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
    func illTypedUndefinedVariablePrimitive() throws {
        let source = #"""
language core;
extend with #nested-function-declarations;
extend with #let-bindings;
extend with #let-patterns;


fn twice(f : fn(Bool) -> Bool) -> (fn(Bool) -> Bool) {
  fn result(x : Bool) -> Bool {
    return f(g(x));
  }
  return let g = f in result;
}

fn main(n : Nat) -> Bool {
  return false;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/nested-function-declarations/ill-typed/undefined_variable/primitive.stella",
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
    func wellTypedFactorial() throws {
        let source = #"""
language core;

extend with #nested-function-declarations;


fn Nat2Nat::const(f : fn(Nat) -> Nat) -> (fn(Nat) -> (fn(Nat) -> Nat)) {
  return fn(x : Nat) { return f }
}


fn factorial(n : Nat) -> Nat {

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
            sourceName: "extra/nested-function-declarations/well-typed/factorial.stella",
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
extend with #nested-function-declarations;


fn twice(f : fn(Bool) -> Bool) -> (fn(Bool) -> Bool) {
  fn result(x : Bool) -> Bool {
    return f(f(x));
  }
  return result;
}

fn main(n : Nat) -> Bool {
  return false;
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/nested-function-declarations/well-typed/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }
}
