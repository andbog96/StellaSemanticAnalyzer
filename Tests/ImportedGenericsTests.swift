import Testing
@testable import StellaSemanticAnalyzer

@Suite("Imported generic-language tests")
@MainActor
struct ImportedGenericsTests {
    @Test("generics/fails/main-1.stella")
    func test_generics_fails_main_1_stella_ebed8d08() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #pairs;

fn main(f : Nat) -> { Nat, auto } {
  return { f,  f(0) }
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-1.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-10.stella")
    func test_generics_fails_main_10_stella_23bbfd98() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;


fn main(succeed : Bool) -> Nat+Bool {
  return inl(true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-10.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-108.stella")
    func test_generics_fails_main_108_stella_5b37f571() throws {
        let source = #"""
language core;

extend with #records, #type-reconstruction;

fn main(x : auto) -> auto {
  return
    (
      fn (x : auto) {
        return fn (y : Nat) {
          return { x = y, y = if x(0) then 0 else succ(x(0)) }
        }
      }
    )
    (fn (x : auto) { return x})
    (if true then succ(0) else 0).y
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-108.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-110.stella")
    func test_generics_fails_main_110_stella_5fabc681() throws {
        let source = #"""
language core;

extend with #records, #type-reconstruction;

fn rotate3(p : {x : auto, y : auto, z : auto}) -> {x : auto, y : auto, z : auto} {
  return  {a = p.z, b = p.y, c = p.x}
}

fn main(x : auto) -> {a : auto, b : auto, c : auto} {
  return rotate3({x = x, y = succ(x), z = succ(succ(x))})
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-110.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-112.stella")
    func test_generics_fails_main_112_stella_364bda0a() throws {
        let source = #"""
language core;

extend with #records, #type-reconstruction;

fn mk(k : fn(Bool) -> Nat) -> { x : auto, y : auto } {
  return
    { x = { x = fn(x : auto) {
                  return if k(succ(0))
                    then if x then 0 else succ(0)
                    else succ(succ(0))
                }
          , y = succ(0) }
    , y = { c = 0 } }.x
}

fn main(x : auto) -> auto {
  return mk(fn(x : auto) { return Nat::iszero(x)}).x(false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-112.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-12.stella")
    func test_generics_fails_main_12_stella_269500db() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;


fn main(succeed : Bool) -> Nat+Bool {
  return inr(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-12.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-13.stella")
    func test_generics_fails_main_13_stella_d5926e6e() throws {
        let source = #"""
language core;
extend with #universal-types;

generic fn id[X](a : X) -> forall X. fn(X) -> X {
  return  generic[X] fn(b : X) {
    return a
  }
}

fn main(a : Nat) -> Nat {
  return a
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-13.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-135.stella")
    func test_generics_fails_main_135_stella_9cab89d2() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;

fn main(n : Nat) -> Nat + Nat {
  return (fn (a : Nat) { return inl(0) }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-135.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-136.stella")
    func test_generics_fails_main_136_stella_17f2b542() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;

fn main(n : Nat) -> Nat + Nat {
  return (fn (a : Nat) { return inr(0) }) (0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-136.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-139.stella")
    func test_generics_fails_main_139_stella_e2658cd6() throws {
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
            sourceName: "generics/fails/main-139.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-145.stella")
    func test_generics_fails_main_145_stella_431d1975() throws {
        let source = #"""
language core;

extend with #sum-types, #type-reconstruction;

fn g(x : auto) -> auto {
  return match x {
      inl(n) => succ(n)
    | inr(bf) => match bf {
          inl(b) => if b then succ(0) else 0
        | inr(f) => f(f(succ(0)))
      }
  }
}

fn main(x : auto) -> auto {
  return g(inr(inr(fn(n : auto) { return g(n) })))
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-145.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-146.stella")
    func test_generics_fails_main_146_stella_e99bb830() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) { return x }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-146.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-147.stella")
    func test_generics_fails_main_147_stella_fe337dc9() throws {
        let source = #"""
language core;

extend with #sum-types, #type-reconstruction;

fn g(x : auto) -> auto {
  return match x {
      inl(n) => succ(n)
    | inr(bf) => match bf {
          inl(b) => if b then succ(0) else 0
        | inr(f)  => match bf {
              inl(b) => if b then succ(0) else 0
            | inr(f) => f(f(succ(0)))
        }
      }
  }
}

fn main(x : auto) -> auto {
  return g(inr(inr(inr(fn(n : auto) { return g(inl(n)) }))))
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-147.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-148.stella")
    func test_generics_fails_main_148_stella_bf42a34f() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) { return x }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-148.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-149.stella")
    func test_generics_fails_main_149_stella_863fd40b() throws {
        let source = #"""
language core;

extend with #sum-types, #type-reconstruction;

fn g(x : auto) -> Nat {
  return match x {
      inl(n) => succ(n)
    | inr(bf) => match bf {
          inl(b) => if b then succ(0) else 0
        | inr(f)  => match bf {
              inl(b) => if b then succ(0) else 0
            | inr(f) => f(f(succ(0)))
        }
      }
  }
}

fn main(x : auto) -> auto {
  return g(inr(inr(inr(fn(n : auto) { return g(inr(inr(n))) }))))
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-149.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-150.stella")
    func test_generics_fails_main_150_stella_8b495a93() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) { return x }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-150.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-151.stella")
    func test_generics_fails_main_151_stella_1ad50708() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(arg : Nat) -> auto {
  return (fn (a : auto) { return List::tail( arg) })(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-151.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-156.stella")
    func test_generics_fails_main_156_stella_8fe1769e() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;

fn main(input : Bool) -> Nat {
  return inl(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-156.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-157.stella")
    func test_generics_fails_main_157_stella_083a65c5() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;

fn main(input : Bool) -> Nat {
  return inr(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-157.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-158.stella")
    func test_generics_fails_main_158_stella_31e1e53c() throws {
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
            sourceName: "generics/fails/main-158.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-159.stella")
    func test_generics_fails_main_159_stella_6b8cefe9() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) { return x }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-159.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-160.stella")
    func test_generics_fails_main_160_stella_48ee6699() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) { return x }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-160.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-162.stella")
    func test_generics_fails_main_162_stella_6dc9f61e() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #sum-types;

fn main(x : auto) -> Nat {
  return match x {
    inl(n) => n
    | inr(n) => n
  }
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-162.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-163.stella")
    func test_generics_fails_main_163_stella_7d94043a() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) { return x }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-163.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-172.stella")
    func test_generics_fails_main_172_stella_48db93c7() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) {
    return x
  }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-172.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-173.stella")
    func test_generics_fails_main_173_stella_17828f7a() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) {
    return x
  }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-173.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-174.stella")
    func test_generics_fails_main_174_stella_5a292357() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) {
    return x
  }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-174.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-175.stella")
    func test_generics_fails_main_175_stella_5a43a681() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) {
    return x
  }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-175.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-177.stella")
    func test_generics_fails_main_177_stella_aac88f20() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) {
    return x
  }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-177.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-178.stella")
    func test_generics_fails_main_178_stella_c7e62318() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) {
    return x
  }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-178.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-179.stella")
    func test_generics_fails_main_179_stella_e0f76cc1() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) {
    return x
  }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-179.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-180.stella")
    func test_generics_fails_main_180_stella_33da081b() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) { return x }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-180.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-181.stella")
    func test_generics_fails_main_181_stella_8827014e() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) { return x }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-181.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-184.stella")
    func test_generics_fails_main_184_stella_1b3ddd84() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) {
    return x
  }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-184.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-186.stella")
    func test_generics_fails_main_186_stella_4fda4862() throws {
        let source = #"""
language core;

extend with #universal-types, #unit-type;

generic fn mkConst[X](x : X) -> forall Y. fn(Y) -> X {
  return generic [Y] fn(y : Y) {
    return x
  }
}

fn main(n : Nat) -> Nat {
  return mkConst[forall A. fn(A) -> forall B. fn(B) -> A](
    generic [A] fn(a : A) {
      return generic [B] fn(b : B) {
        return a
      }
    }
  )[Bool](true)[Nat](n)[Unit](unit)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-186.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-2.stella")
    func test_generics_fails_main_2_stella_f0da4074() throws {
        let source = #"""
language core;

extend with
  #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) {
    return x
  }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-205.stella")
    func test_generics_fails_main_205_stella_f0ec4ba3() throws {
        let source = #"""
language core;

extend with #universal-types, #records, #tuples;

generic fn mkConst[X](x : X) -> forall Y. fn(Y) -> X {
  return generic [Y] fn(y : Y) { return x }
}

fn main(n : Nat) -> Nat {
  return  { p = mkConst[forall Z. fn(Z) -> Z](generic [Z] fn(z : Z) { return z })[Nat](n) }.p.1
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-205.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-21.stella")
    func test_generics_fails_main_21_stella_248684ba() throws {
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
            sourceName: "generics/fails/main-21.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-212.stella")
    func test_generics_fails_main_212_stella_4ba3b6b5() throws {
        let source = #"""
language core;

extend with #universal-types, #type-ascriptions, #tuples;

generic fn mkConst[X](x : X) -> forall Y. fn(Y) -> X {
  return generic [Y] fn(y : Y) { return x }
}

fn main(n : Nat) -> Nat {
  return ( { n, mkConst[forall Z. fn(Z) -> Z](generic [Z] fn(z : Z) { return z })[Nat](n) } as { Nat, Nat }).2
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-212.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-26.stella")
    func test_generics_fails_main_26_stella_cf375614() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> forall X. fn(X) ->  Y {
  return generic [X] fn(x : X) {
    return x
  }
}

fn main(x : Nat) -> Nat {
  return identity(x)[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-26.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-3.stella")
    func test_generics_fails_main_3_stella_9046041c() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #pairs;

fn main(n : Nat) -> Nat {
  return  {0, false}(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-3.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-40.stella")
    func test_generics_fails_main_40_stella_1f54427c() throws {
        let source = #"""
language core;

extend with
  #universal-types;

generic fn test[Y](y : Y) ->
  fn(forall X. fn(X) -> (forall Y. fn(Y) -> X)) -> Y {
  return fn(f : forall X. fn(X) -> (forall Y. fn(Y) -> X)) {
    return f[Y](y)[Bool](true)
  }
}

fn main(x : Nat) -> Nat {
  return test[Nat](x)(generic [X] fn(x : X) {
    return generic [Y] fn(y : Y) { return x }
  })
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-40.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-52.stella")
    func test_generics_fails_main_52_stella_b480a80e() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(f : Nat) -> auto {
  return  f(f)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-52.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-55.stella")
    func test_generics_fails_main_55_stella_65cf7d02() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(arg : Nat) -> auto {
  return (fn (a : auto) { return List::head( arg) })(0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-55.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-60.stella")
    func test_generics_fails_main_60_stella_8a81aacf() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn foo(a : Nat) -> Nat {
  return 0
}

fn main(n : Nat) -> Nat {
  return (fn (a : Nat) { return fix(0); } ) ( 0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-60.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/fails/main-72.stella")
    func test_generics_fails_main_72_stella_32cc7009() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(arg : Nat) -> auto {
  return List::isempty( arg)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/fails/main-72.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ambiguous-list-bad.stella")
    func test_generics_type_reconstruction_ambiguous_list_bad_stella_ac162ab8() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(n : auto) -> auto {
  return [n]
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ambiguous-list-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ambiguous-tuple-bad.stella")
    func test_generics_type_reconstruction_ambiguous_tuple_bad_stella_0aacae30() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #tuples;

fn main(n : auto) -> auto {
  return {n, true}
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ambiguous-tuple-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/abstraction-bad.stella")
    func test_generics_type_reconstruction_ast_tests_abstraction_bad_stella_089a5532() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : Nat) -> auto {
  return fn(x : auto) { return if x then succ(x) else 0 }
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/abstraction-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/abstraction-good.stella")
    func test_generics_type_reconstruction_ast_tests_abstraction_good_stella_f1cd119c() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #multiparameter-functions;

fn apply(f : auto, x : auto) -> auto {
  return f(x)
}

fn main(n : Nat) -> auto {
  return apply(fn(x : auto) { return succ(x) }, n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/abstraction-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/ambigous-type-bad.stella")
    func test_generics_type_reconstruction_ast_tests_ambigous_type_bad_stella_91cdb5fc() throws {
        let source = #"""
language core;

extend with #type-reconstruction;


fn main(n : auto) -> auto {
  return n
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/ambigous-type-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/application-bad.stella")
    func test_generics_type_reconstruction_ast_tests_application_bad_stella_a7cadd68() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #multiparameter-functions;

fn app(f : auto, x : auto) -> auto {
  return f(x)
}


fn funInt(b : Nat) -> Nat {
  return b
}

fn main(n : Nat) -> auto {
  return app(funInt, funInt)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/application-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/application-good.stella")
    func test_generics_type_reconstruction_ast_tests_application_good_stella_9b5eb642() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #multiparameter-functions;

fn app(f : auto, x : auto) -> auto {
  return f(x)
}


fn funInt(b : Nat) -> Nat {
  return b
}

fn main(n : Nat) -> auto {
  return app(funInt, n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/application-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/fix-bad.stella")
    func test_generics_type_reconstruction_ast_tests_fix_bad_stella_d6f58ee2() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn main(n : Nat) -> Bool {
  return fix(fn(f : auto) {
    return fn(x : auto) { return succ(x) }
  })(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/fix-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/fix-good.stella")
    func test_generics_type_reconstruction_ast_tests_fix_good_stella_dc820f53() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #fixpoint-combinator;

fn main(n : Nat) -> auto {
  return fix(fn(f : auto) {
    return fn(x : auto) { return x }
  })(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/fix-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/func-1-good.stella")
    func test_generics_type_reconstruction_ast_tests_func_1_good_stella_0734f773() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : auto) -> Nat {
  return n
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/func-1-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/func-2-bad.stella")
    func test_generics_type_reconstruction_ast_tests_func_2_bad_stella_79928747() throws {
        let source = #"""
language core;

extend with #type-reconstruction;


fn main(n : Nat) -> Bool {
  return n
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/func-2-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/func-2-good.stella")
    func test_generics_type_reconstruction_ast_tests_func_2_good_stella_2b2c4781() throws {
        let source = #"""
language core;

extend with #type-reconstruction;


fn main(n : Nat) -> Bool {
  return n
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/func-2-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/if-bad.stella")
    func test_generics_type_reconstruction_ast_tests_if_bad_stella_9c05f616() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #multiparameter-functions;


fn funInt(x : auto, y : auto) -> auto {
  return if true then x else y
}

fn main(n : Nat) -> auto {
  return funInt(true, 0)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/if-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/if-good.stella")
    func test_generics_type_reconstruction_ast_tests_if_good_stella_c9dc087e() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #multiparameter-functions;


fn funInt(x : auto, y : auto) -> auto {
  return if true then x else y
}

fn main(n : Nat) -> auto {
  return funInt(true, true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/if-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/iszero-bad.stella")
    func test_generics_type_reconstruction_ast_tests_iszero_bad_stella_df47e41d() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : auto) -> Nat {
  return Nat::iszero(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/iszero-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/iszero-good.stella")
    func test_generics_type_reconstruction_ast_tests_iszero_good_stella_0efd891b() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : auto) -> auto {
  return Nat::iszero(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/iszero-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/let-binding-bad.stella")
    func test_generics_type_reconstruction_ast_tests_let_binding_bad_stella_47d10f95() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #let-bindings;

fn main(n : auto) -> Bool {
  return let x = n in succ(x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/let-binding-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/let-binding-good.stella")
    func test_generics_type_reconstruction_ast_tests_let_binding_good_stella_093f0729() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #let-bindings;

fn main(n : auto) -> Nat {
  return let x = n in succ(x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/let-binding-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/list-cons-bad.stella")
    func test_generics_type_reconstruction_ast_tests_list_cons_bad_stella_93370a74() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(n : Nat) -> auto {
  return cons(true, [n])
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/list-cons-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/list-cons-good.stella")
    func test_generics_type_reconstruction_ast_tests_list_cons_good_stella_f15284f7() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn prepend(x : auto, xs : auto) -> auto {
  return cons(x, xs)
}

fn main(n : Nat) -> auto {
  return prepend(n, [succ(n)])
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/list-cons-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/list-head-bad.stella")
    func test_generics_type_reconstruction_ast_tests_list_head_bad_stella_3fd76be9() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(n : Nat) -> Bool {
  return List::head([n])
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/list-head-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/list-head-good.stella")
    func test_generics_type_reconstruction_ast_tests_list_head_good_stella_8639a620() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn first(xs : auto) -> auto {
  return List::head(xs)
}

fn main(n : Nat) -> auto {
  return first([n])
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/list-head-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/list-isempty-bad.stella")
    func test_generics_type_reconstruction_ast_tests_list_isempty_bad_stella_1c7995d8() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(n : [Nat]) -> auto {
  return List::isempty(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/list-isempty-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/list-isempty-good.stella")
    func test_generics_type_reconstruction_ast_tests_list_isempty_good_stella_09e7c8d6() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn empty(xs : auto) -> auto {
  return List::isempty(xs)
}

fn main(n : Nat) -> auto {
  return empty([n])
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/list-isempty-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/list-literal-bad.stella")
    func test_generics_type_reconstruction_ast_tests_list_literal_bad_stella_bfb5f5d4() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(n : Nat) -> auto {
  return [n, true]
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/list-literal-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/list-literal-good.stella")
    func test_generics_type_reconstruction_ast_tests_list_literal_good_stella_259d5341() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn wrap(x : auto) -> auto {
  return [x, x]
}

fn main(n : Nat) -> auto {
  return wrap(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/list-literal-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/list-tail-bad.stella")
    func test_generics_type_reconstruction_ast_tests_list_tail_bad_stella_385450e9() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(n : Nat) -> Bool {
  return List::tail([n])
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/list-tail-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/list-tail-good.stella")
    func test_generics_type_reconstruction_ast_tests_list_tail_good_stella_9d545ed7() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn rest(xs : auto) -> auto {
  return List::tail(xs)
}

fn main(n : Nat) -> auto {
  return rest([n])
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/list-tail-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/natrec-bad.stella")
    func test_generics_type_reconstruction_ast_tests_natrec_bad_stella_84e9ac48() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn step(i : auto) -> auto {
  return fn(acc : auto) { return succ(acc) }
}

fn main(n : Nat) -> auto {
  return Nat::rec(n, true, step)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/natrec-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/natrec-good.stella")
    func test_generics_type_reconstruction_ast_tests_natrec_good_stella_1b567577() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn step(i : auto) -> auto {
  return fn(acc : auto) { return succ(acc) }
}

fn main(n : Nat) -> auto {
  return Nat::rec(n, 0, step)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/natrec-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/pair-dot-bad.stella")
    func test_generics_type_reconstruction_ast_tests_pair_dot_bad_stella_545680f1() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #pairs;

fn main(n : Nat) -> Bool {
  return {n, true}.1
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/pair-dot-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/pair-dot-good.stella")
    func test_generics_type_reconstruction_ast_tests_pair_dot_good_stella_2b5007ae() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #pairs;

fn fst(p : auto) -> auto {
  return p.1
}

fn main(n : Nat) -> auto {
  return fst({n, true})
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/pair-dot-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/pair-literal-bad.stella")
    func test_generics_type_reconstruction_ast_tests_pair_literal_bad_stella_920aed3d() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #pairs;

fn main(n : Nat) -> {Nat, Nat} {
  return {n, true}
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/pair-literal-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/pair-literal-good.stella")
    func test_generics_type_reconstruction_ast_tests_pair_literal_good_stella_5be26a9c() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #pairs, #multiparameter-functions;

fn pair(x : auto, y : auto) -> auto {
  return {x, y}
}

fn main(n : Nat) -> auto {
  return pair(n, true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/pair-literal-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/record-dot-bad.stella")
    func test_generics_type_reconstruction_ast_tests_record_dot_bad_stella_331f9d7f() throws {
        let source = #"""
language core;


extend with #type-reconstruction, #records;

fn main(n : { a : auto, b : Bool }) ->  Nat {
  return n.a
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/record-dot-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/record-literal-bad.stella")
    func test_generics_type_reconstruction_ast_tests_record_literal_bad_stella_ebbfc7e5() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #records;

fn main(n : Nat) -> { a : Nat, b : Bool } {
  return { a = n, b = n }
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/record-literal-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/record-literal-good.stella")
    func test_generics_type_reconstruction_ast_tests_record_literal_good_stella_ea9c997e() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #records, #multiparameter-functions;

fn mkRec(x : auto, y : auto) -> auto {
  return { a = x, b = y }
}

fn main(n : Nat) -> auto {
  return mkRec(n, true)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/record-literal-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/succ-bad.stella")
    func test_generics_type_reconstruction_ast_tests_succ_bad_stella_893b68b3() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : auto) -> Bool {
  return succ(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/succ-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/succ-good.stella")
    func test_generics_type_reconstruction_ast_tests_succ_good_stella_a6da8f3c() throws {
        let source = #"""
language core;

extend with #type-reconstruction;

fn main(n : auto) -> auto {
  return succ(n)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/succ-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/true-literal-bad.stella")
    func test_generics_type_reconstruction_ast_tests_true_literal_bad_stella_866c73e1() throws {
        let source = #"""
language core;

extend with #type-reconstruction;


fn main(n : auto) -> auto {
  return true
}

fn checkType(b : auto) -> Nat {
  return main(b)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/true-literal-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/true-literal-good.stella")
    func test_generics_type_reconstruction_ast_tests_true_literal_good_stella_4d280c36() throws {
        let source = #"""
language core;

extend with #type-reconstruction;


fn main(n : auto) -> auto {
  return true
}

fn checkType(b : Bool) -> Bool {
  return main(b)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/true-literal-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/ast-tests/type-ascription-bad.stella")
    func test_generics_type_reconstruction_ast_tests_type_ascription_bad_stella_94ea11f1() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #type-ascriptions;

fn main(n : auto) -> Bool {
  return n as Nat
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/type-ascription-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/type-reconstruction/ast-tests/type-ascription-good.stella")
    func test_generics_type_reconstruction_ast_tests_type_ascription_good_stella_d7ea72ca() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #type-ascriptions;

fn main(n : auto) -> Nat {
  return n as Nat
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/ast-tests/type-ascription-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/type-reconstruction/list-empty-good.stella")
    func test_generics_type_reconstruction_list_empty_good_stella_87e37f26() throws {
        let source = #"""
language core;

extend with #type-reconstruction, #lists;

fn main(n : Nat) -> [Nat] {
  return []
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/type-reconstruction/list-empty-good.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/universal-types/duplicate-type-params-1.stella")
    func test_generics_universal_types_duplicate_type_params_1_stella_383689ac() throws {
        let source = #"""
language core;

extend with #universal-types;

 generic fn identity[T, T](x : T) -> T {
  return x
}

fn main(x : Nat) -> Nat {
  return identity[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/universal-types/duplicate-type-params-1.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/universal-types/duplicate-type-params-2.stella")
    func test_generics_universal_types_duplicate_type_params_2_stella_68feb1f4() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn const[X](x : X) -> forall Y. fn(Y) -> X {
  return  generic [Y, Y] fn(y : Y) { return x }
}

fn main(x : Nat) -> Nat {
  return const[Nat](x)[Bool](false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/universal-types/duplicate-type-params-2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/universal-types/forall-param-free-vars.stella")
    func test_generics_universal_types_forall_param_free_vars_stella_4e94ce77() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn apply[T](f : forall U. fn(U) -> T, x : Bool) -> T {
  return f[Bool](x)
}

fn main(x : Nat) -> Nat {
  return apply[Nat](generic [U] fn(u : U) { return succ(0) }, false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/universal-types/forall-param-free-vars.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/universal-types/generic-typevar-in-body.stella")
    func test_generics_universal_types_generic_typevar_in_body_stella_a329281c() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn identity[T](x : T) -> T {
  return x
}

generic fn apply[T](x : T) -> T {
  return identity[T](x)
}

fn main(x : Nat) -> Nat {
  return apply[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/universal-types/generic-typevar-in-body.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/universal-types/infinite-type.stella")
    func test_generics_universal_types_infinite_type_stella_d96bbc8b() throws {
        let source = #"""
language core;

extend with
  #type-reconstruction, #lists;
extend with #multiparameter-functions;

fn equal_types(l : auto, r : auto) -> auto {
  return if true then l else r
}

fn main(n : auto) -> [auto] {
  return equal_types(n, [n])
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/universal-types/infinite-type.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/universal-types/local-generic-function.stella")
    func test_generics_universal_types_local_generic_function_stella_be36c27b() throws {
        let source = #"""
language core;

extend with #universal-types;

fn main(x : Nat) -> Nat {
  generic fn localId[T](x : T) -> T {
    return x
  }
  return localId[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/universal-types/local-generic-function.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/universal-types/misapplication-argcount.stella")
    func test_generics_universal_types_misapplication_argcount_stella_80e65a14() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn identity[T](x : T) -> T {
  return x
}

fn main(x : Nat) -> Nat {
  return identity  [Nat, Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/universal-types/misapplication-argcount.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/universal-types/misapplication-typevar.stella")
    func test_generics_universal_types_misapplication_typevar_stella_22a03c01() throws {
        let source = #"""
language core;

extend with #universal-types;

fn identity(x : Nat) -> Nat {
  return x
}

fn main(x : Nat) -> Nat {
  return  identity[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/universal-types/misapplication-typevar.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/universal-types/renaming.stella")
    func test_generics_universal_types_renaming_stella_74b5ac19() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn const[X](x : X) -> forall Y. fn(Y) -> X {
  return generic [YFresh] fn(y : YFresh) { return x }
}

fn main(x : Nat) -> Nat {
  return const[Nat](x)[Bool](false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/universal-types/renaming.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/universal-types/syntax-1-bad-2.stella")
    func test_generics_universal_types_syntax_1_bad_2_stella_ab7d2f16() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn identity[T](x :  S) -> T {
  return x
}

fn main(x : Nat) -> Nat {
  return identity[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/universal-types/syntax-1-bad-2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/universal-types/syntax-1-bad-3.stella")
    func test_generics_universal_types_syntax_1_bad_3_stella_cb479ef4() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn identity[T](x : T) -> T {
  return x
}

fn main(x : Nat) -> Bool{
  return identity[   Y](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/universal-types/syntax-1-bad-3.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/universal-types/syntax-1-bad.stella")
    func test_generics_universal_types_syntax_1_bad_stella_42908c3e() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn identity[T](x : T) -> T {
  return x
}

fn main(x : Nat) -> Bool{
  return  identity[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/universal-types/syntax-1-bad.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }

    @Test("generics/universal-types/syntax-1.stella")
    func test_generics_universal_types_syntax_1_stella_bb79fd97() throws {
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
            sourceName: "generics/universal-types/syntax-1.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/universal-types/syntax-2.stella")
    func test_generics_universal_types_syntax_2_stella_dd445ad3() throws {
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
            sourceName: "generics/universal-types/syntax-2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/universal-types/syntax-3.stella")
    func test_generics_universal_types_syntax_3_stella_ef53c0a3() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn const[X, Y](x : X) -> fn(Y) -> X {
  return fn(y : Y) { return x }
}

fn main(x : Nat) -> Nat {
  return const[Nat, Bool](x)(false)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/universal-types/syntax-3.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }

    @Test("generics/universal-types/undefined-return-typevar.stella")
    func test_generics_universal_types_undefined_return_typevar_stella_28711b14() throws {
        let source = #"""
language core;

extend with #universal-types;

generic fn bad[T](x : T) ->  S {
  return x
}

fn main(x : Nat) -> Nat {
  return bad[Nat](x)
}
"""#
        let program = try Program.parser.run(
            sourceName: "generics/universal-types/undefined-return-typevar.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected the program to be rejected")
        } catch {
        }
    }
}
