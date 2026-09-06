import Testing
@testable import StellaSemanticAnalyzer

@Suite
@MainActor
struct MatchPatternInferenceTests {
    @Test
    func infersSumTypeFromMatchPatterns() throws {
        let source = #"""
        language core;

        extend with #sum-types, #unit-type, #type-reconstruction;

        fn main(input : auto) -> auto {
          return match test(input) {
              inl(n) => n
            | inr(q) => 0
          }
        }

        fn test(first : auto) -> auto {
          return if first then inl(0) else inr(unit)
        }
        """#
        let program = try Program.parser.run(
            sourceName: "match-pattern-inference.stella",
            input: source
        )

        _ = try Context(from: program)
    }
}
