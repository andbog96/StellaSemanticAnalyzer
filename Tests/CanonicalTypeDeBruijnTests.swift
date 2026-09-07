import Testing
@testable import StellaSemanticAnalyzer

@Suite
@MainActor
struct CanonicalTypeDeBruijnTests {
    @Test
    func alphaEquivalentForallTypesAreEqual() throws {
        let x = TypeName(description: "X")
        let y = TypeName(description: "Y")
        let freshY = TypeName(description: "YFresh")

        let lhs = RawType.forall(
            variables: [y],
            rawType: .function(from: [.variable(y)], to: .variable(x))
        )
        let rhs = RawType.forall(
            variables: [freshY],
            rawType: .function(from: [.variable(freshY)], to: .variable(x))
        )

        #expect(try CanonicalType(from: lhs) == CanonicalType(from: rhs))
    }

    @Test
    func multipleBindersUseNearestFirstIndices() throws {
        let a = TypeName(description: "A")
        let b = TypeName(description: "B")
        let rawType = RawType.forall(
            variables: [a, b],
            rawType: .function(
                from: [.variable(a), .variable(b)],
                to: .variable(a)
            )
        )

        #expect(
            try CanonicalType(from: rawType) == .forall(
                variableCount: 2,
                body: .function(
                    from: [.boundVariable(1), .boundVariable(0)],
                    to: .boundVariable(1)
                )
            )
        )
    }

    @Test
    func instantiationReplacesBoundVariablesInDeclarationOrder() {
        let body = CanonicalType.function(
            from: [.boundVariable(1), .boundVariable(0)],
            to: .boundVariable(1)
        )

        #expect(
            body.instantiating([.nat, .bool]) ==
                .function(from: [.nat, .bool], to: .nat)
        )
    }
}
