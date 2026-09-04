import Testing
@testable import StellaSemanticAnalyzer

@Suite
@MainActor
struct OpenVariantExceptionsTests {
    @Test
    func illTypedConflictingExceptionDeclarationsPrimitive2() throws {
        let source = #"""
language core;

extend with #exception-type-declaration;
extend with #variants;
extend with #nested-function-declarations;
extend with #open-variant-exceptions;

exception variant error_code : Nat

fn main(n : Nat) -> Nat {
  return 0
}

exception type = <| good : Bool |>
"""#
        let program = try Program.parser.run(
            sourceName: "extra/open-variant-exceptions/ill-typed/conflicting_exception_declarations/primitive 2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_CONFLICTING_EXCEPTION_DECLARATIONS")
        }
    }

    @Test
    func illTypedConflictingExceptionDeclarationsPrimitive() throws {
        let source = #"""
language core;

extend with #exception-type-declaration;
extend with #variants;
extend with #nested-function-declarations;
extend with #open-variant-exceptions;

exception variant error_code : Nat

fn main(n : Nat) -> Nat {
  return 0
}

exception type = <| good : Bool |>
"""#
        let program = try Program.parser.run(
            sourceName: "extra/open-variant-exceptions/ill-typed/conflicting_exception_declarations/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_CONFLICTING_EXCEPTION_DECLARATIONS")
        }
    }

    @Test
    func illTypedDuplicateExceptionTypePrimitive2() throws {
        let source = #"""
language core;

extend with #exception-type-declaration;
extend with #variants;

exception type = <| error_code : Nat, good : Bool |>


fn main(n : Nat) -> Nat {
  return 0
}

exception type = <| good : Bool |>
"""#
        let program = try Program.parser.run(
            sourceName: "extra/open-variant-exceptions/ill-typed/duplicate_exception_type/primitive 2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_EXCEPTION_TYPE")
        }
    }

    @Test
    func illTypedDuplicateExceptionTypePrimitive() throws {
        let source = #"""
language core;

extend with #exception-type-declaration;
extend with #variants;

exception type = <| error_code : Nat, good : Bool |>


fn main(n : Nat) -> Nat {
  return 0
}

exception type = <| good : Bool |>
"""#
        let program = try Program.parser.run(
            sourceName: "extra/open-variant-exceptions/ill-typed/duplicate_exception_type/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_EXCEPTION_TYPE")
        }
    }

    @Test
    func illTypedDuplicateExceptionVariantPrimitive2() throws {
        let source = #"""
language core;

extend with #variants;
extend with #exception-type-declaration;
extend with #open-variant-exceptions;


exception variant error_code : Nat

fn main(n : Nat) -> Nat {
  return 0
}

exception variant good : Bool

exception variant error_code : Nat
"""#
        let program = try Program.parser.run(
            sourceName: "extra/open-variant-exceptions/ill-typed/duplicate_exception_variant/primitive 2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_EXCEPTION_VARIANT")
        }
    }

    @Test
    func illTypedDuplicateExceptionVariantPrimitive() throws {
        let source = #"""
language core;

extend with #variants;
extend with #exception-type-declaration;
extend with #open-variant-exceptions;


exception variant error_code : Nat

fn main(n : Nat) -> Nat {
  return 0
}

exception variant good : Bool

exception variant error_code : Nat
"""#
        let program = try Program.parser.run(
            sourceName: "extra/open-variant-exceptions/ill-typed/duplicate_exception_variant/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_DUPLICATE_EXCEPTION_VARIANT")
        }
    }

    @Test
    func illTypedIllegalLocalExceptionTypePrimitive2() throws {
        let source = #"""
language core;

extend with #exception-type-declaration;
extend with #variants;
extend with #nested-function-declarations;

fn main(n : Nat) -> Nat {
  exception type = <| good : Bool |>

  return 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/open-variant-exceptions/ill-typed/illegal_local_exception_type/primitive 2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_ILLEGAL_LOCAL_EXCEPTION_TYPE")
        }
    }

    @Test
    func illTypedIllegalLocalExceptionTypePrimitive() throws {
        let source = #"""
language core;

extend with #exception-type-declaration;
extend with #variants;
extend with #nested-function-declarations;

fn main(n : Nat) -> Nat {
  exception type = <| good : Bool |>

  return 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/open-variant-exceptions/ill-typed/illegal_local_exception_type/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_ILLEGAL_LOCAL_EXCEPTION_TYPE")
        }
    }

    @Test
    func illTypedIllegalLocalOpenVariantExceptionPrimitive2() throws {
        let source = #"""
language core;

extend with #exception-type-declaration;
extend with #variants;
extend with #nested-function-declarations;
extend with #open-variant-exceptions;

exception variant error_code : Nat

fn main(n : Nat) -> Nat {
  exception variant good : Bool
  return 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/open-variant-exceptions/ill-typed/illegal_local_open_variant_exception/primitive 2.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_ILLEGAL_LOCAL_OPEN_VARIANT_EXCEPTION")
        }
    }

    @Test
    func illTypedIllegalLocalOpenVariantExceptionPrimitive() throws {
        let source = #"""
language core;

extend with #exception-type-declaration;
extend with #variants;
extend with #nested-function-declarations;
extend with #open-variant-exceptions;

exception variant error_code : Nat

fn main(n : Nat) -> Nat {
  exception variant good : Bool
  return 0
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/open-variant-exceptions/ill-typed/illegal_local_open_variant_exception/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
            Issue.record("Expected error")
        } catch let error {
            #expect(error.code == "ERROR_ILLEGAL_LOCAL_OPEN_VARIANT_EXCEPTION")
        }
    }

    @Test
    func wellTypedPrimitive() throws {
        let source = #"""
language core;

extend with #exceptions, #open-variant-exceptions;
extend with #exception-type-declaration;
extend with #variants;

exception variant error_code : Nat
exception variant good : Bool

fn main(n : Nat) -> Bool {
    return throw(<| good = true |>)
}
"""#
        let program = try Program.parser.run(
            sourceName: "extra/open-variant-exceptions/well-typed/primitive.stella",
            input: source
        )

        do {
            _ = try Context(from: program)
        } catch {
            Issue.record("Expected a well-typed program, got: \(error)")
        }
    }
}
