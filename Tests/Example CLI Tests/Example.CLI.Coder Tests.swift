import Example
import Example_CLI
import ISO_9945_Utility
import Operation
import Tagged
import Testing

extension Example.CLI.Coder {

    @Suite
    struct Test {

        @Test
        func `a greeting invocation reads its operand into a call`() throws {
            var arguments: ArraySlice<String> = ["greeting", "greet", "Ada"]

            let call = try Example.CLI.coder.parse(&arguments)

            guard case .greeting(.greet(let application)) = call else {
                Issue.record("expected the greeting operation")
                return
            }
            #expect(application.input.name == "Ada")
        }

        @Test
        func `a counter invocation reads its option into a call`() throws {
            var arguments: ArraySlice<String> = ["counter", "increment", "-l", "3"]

            let call = try Example.CLI.coder.parse(&arguments)

            guard case .counter(.increment(let application)) = call else {
                Issue.record("expected the counter operation")
                return
            }
            #expect(application.input.limit == 3)
        }

        @Test
        func `a call round trips back to its argument vector`() throws {
            var arguments: ArraySlice<String> = ["counter", "increment", "-l", "3"]
            let call = try Example.CLI.coder.parse(&arguments)

            var written: [String] = []
            try Example.CLI.coder.serialize(call, into: &written)

            #expect(written == ["counter", "increment", "-l", "3"])
        }

        @Test
        func `an unknown operation reports its domain and operation names`() throws {
            var arguments: ArraySlice<String> = ["greeting", "wave"]

            #expect(throws: Example.CLI.Coder.Error.unknown(domain: try .init("greeting"), operation: try .init("wave"))) {
                try Example.CLI.coder.parse(&arguments)
            }
        }

        @Test(arguments: ["Ada", "Ada Lovelace", "Zoë", "", "  padded  ", "x=1,y=2"])
        func `a greeting operand keeps its exact bytes`(operand: String) throws {
            var arguments: ArraySlice<String> = ["greeting", "greet", operand]

            let call = try Example.CLI.coder.parse(&arguments)

            guard case .greeting(.greet(let application)) = call else {
                Issue.record("expected the greeting operation")
                return
            }
            #expect(Array(application.input.name.underlying.utf8) == Array(operand.utf8))
        }

        @Test(arguments: ["three", "", "3.0", " 3", "99999999999999999999"])
        func `a non integer limit reports the missing operand`(limit: String) {
            var arguments: ArraySlice<String> = ["counter", "increment", "-l", limit]

            #expect(throws: Example.CLI.Coder.Error.missingOperand) {
                try Example.CLI.coder.parse(&arguments)
            }
        }

        @Test(arguments: [0, -1, 42, Int.max, Int.min])
        func `an integer limit keeps its exact value`(limit: Int) throws {
            var arguments: ArraySlice<String> = ["counter", "increment", "-l", String(limit)]

            let call = try Example.CLI.coder.parse(&arguments)

            guard case .counter(.increment(let application)) = call else {
                Issue.record("expected the counter operation")
                return
            }
            #expect(application.input.limit.underlying == limit)
        }

        @Test
        func `a greeting without an operand reports the missing operand`() {
            var arguments: ArraySlice<String> = ["greeting", "greet"]

            #expect(throws: Example.CLI.Coder.Error.missingOperand) {
                try Example.CLI.coder.parse(&arguments)
            }
        }
    }
}
