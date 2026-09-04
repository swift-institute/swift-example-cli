import Example
import Example_CLI
import Example_Counter
import Example_Counter_Signature
import Example_Greeting
import Example_Greeting_Signature
import Tagged
import Testing

@Suite
struct `Example.CLI.Coder Tests` {

    @Test
    func `a greeting invocation reads its operand into a call`() throws {
        var arguments: ArraySlice<String> = ["greeting", "greet", "Ada"]

        let call = try Example.CLI.coder.parse(&arguments)

        guard case .greeting(.greet(let application)) = call else {
            Issue.record("expected the greeting operation")
            return
        }
        #expect(application.input == .init("Ada"))
    }

    @Test
    func `a counter invocation reads its option into a call`() throws {
        var arguments: ArraySlice<String> = ["counter", "increment", "-l", "3"]

        let call = try Example.CLI.coder.parse(&arguments)

        guard case .counter(.increment(let application)) = call else {
            Issue.record("expected the counter operation")
            return
        }
        #expect(application.input == .init(3))
    }

    @Test
    func `a call round trips back to its argument vector`() throws {
        var arguments: ArraySlice<String> = ["counter", "increment", "-l", "3"]
        let call = try Example.CLI.coder.parse(&arguments)

        var written: [String] = []
        try Example.CLI.coder.serialize(call, into: &written)

        #expect(written == ["counter", "increment", "-l", "3"])
    }
}
