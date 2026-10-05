import Example
import Example_CLI

var arguments = CommandLine.arguments.dropFirst()[...]

do throws(Example.CLI.Coder.Error) {
    let call = try Example.CLI.coder.parse(&arguments)
    var words: [String] = []
    try Example.CLI.coder.serialize(call, into: &words)
    print(words.joined(separator: " "))
} catch {
    print("could not parse the command line: \(error)")
}
