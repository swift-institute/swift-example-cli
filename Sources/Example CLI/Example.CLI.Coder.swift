public import Coder
public import Example
public import ISO_9945_Core
public import ISO_9945_Utility
public import ISO_9945_Utility_Coder
import Operation
import Optic
import Tagged

extension Example.CLI {

    public struct Coder: ISO_9945.Utility.Coding<Example.Call, Example.CLI.Coder.Error> {

        public init() {}
    }
}

extension Example.CLI {

    public static var coder: Example.CLI.Coder {
        .init()
    }
}

extension Example.CLI.Coder {

    public var body: Never {
        borrowing get {
            return fatalError("\(Self.self) is a leaf: implement its conformance requirements directly")
        }
    }

    public borrowing func parse(
        _ input: inout ArraySlice<Swift::String>
    ) throws(Example.CLI.Coder.Error) -> Example.Call {
        let domain: ISO_9945.Utility.Name
        do throws(ISO_9945.Utility.Name.Coder.Error) {
            domain = try ISO_9945.Utility.Name.coder.parse(&input)
        } catch {
            throw .name(error)
        }

        let invocation: ISO_9945.Utility.Invocation
        do throws(ISO_9945.Utility.Invocation.Coder.Error) {
            invocation = try ISO_9945.Utility.Invocation.Coder(arguments: ["l"]).parse(&input)
        } catch {
            throw .invocation(error)
        }

        switch (domain, invocation.name) {
        case (.greeting, .greet):
            guard let operand = invocation.operands.first else {
                throw .missingOperand
            }
            return .greeting(.greet(.init(Swift::String(operand))))

        case (.counter, .increment):
            guard
                let option = invocation.options.first(where: { $0.name == "l" }),
                let argument = option.argument,
                let limit = Swift::Int(Swift::String(argument))
            else {
                throw .missingOperand
            }
            return .counter(.increment(limit: .init(limit)))

        default:
            throw .unknown(domain: domain, operation: invocation.name)
        }
    }

    public borrowing func serialize(
        _ output: borrowing Example.Call,
        into buffer: inout [Swift::String]
    ) throws(Example.CLI.Coder.Error) {
        if Example.Call.folds.greeting(
            output,
            { call in
                _ = Example.Greeting.Call.folds.greet(call) { application in
                    buffer.append(contentsOf: ["greeting", "greet", application.input.name.underlying])
                }
            }
        ) {
            return
        }

        if Example.Call.folds.counter(
            output,
            { call in
                _ = Example.Counter.Call.folds.increment(call) { application in
                    buffer.append(
                        contentsOf: ["counter", "increment", "-l", Swift::String(application.input.limit.underlying)]
                    )
                }
            }
        ) {
            return
        }
    }
}

extension ISO_9945.Utility.Name {

    fileprivate static let greeting = Self(unchecked: "greeting")

    fileprivate static let greet = Self(unchecked: "greet")

    fileprivate static let counter = Self(unchecked: "counter")

    fileprivate static let increment = Self(unchecked: "increment")
}
