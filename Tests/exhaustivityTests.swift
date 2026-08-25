import Testing
@testable import StellaTypeChecker

@Suite("Nat exhaustivity")
struct NatExhaustivityTests {
    private let wildcard = Pattern.var(Name(value: "n"))

    @Test("Nested successor cases can jointly cover every successor")
    func nestedSuccessorPartitionIsExhaustive() {
        let patterns: [Pattern] = [
            .zero,
            .succ(.zero),
            .succ(.succ(wildcard)),
        ]

        do {
            try CanonicalType.nat.checkExhaustiveness(of: patterns)
        } catch {
            Issue.record(error)
        }
    }
}
