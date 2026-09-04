public import Coder
public import Example
public import Example_Counter
public import Example_Counter_Signature
public import Example_Greeting
public import Example_Greeting_Signature
public import Example_Signature
public import ISO_9945_Core
public import ISO_9945_Utility
public import ISO_9945_Utility_Coder
public import Tagged

extension Example.CLI {

    public struct Coder: ISO_9945.Utility.Coding<Example.Call, Example.CLI.Coder.Error> {

        public init() {}

        public borrowing func parse(
            _ input: inout ArraySlice<Swift.String>
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

            switch (domain.rawValue, invocation.name.rawValue) {
            case ("greeting", "greet"):
                guard let operand = invocation.operands.first else {
                    throw .missingOperand
                }
                return .greeting(.greet(.init(operand.rawValue)))

            case ("counter", "increment"):
                guard
                    let option = invocation.options.first(where: { $0.name == "l" }),
                    let argument = option.argument,
                    let limit = Swift.Int(argument.rawValue)
                else {
                    throw .missingOperand
                }
                return .counter(.increment(limit: .init(limit)))

            default:
                throw .unknown(domain: domain.rawValue, operation: invocation.name.rawValue)
            }
        }

        public borrowing func serialize(
            _ output: borrowing Example.Call,
            into buffer: inout [Swift.String]
        ) throws(Example.CLI.Coder.Error) {
            if Example.Call.folds.greeting(output, { call in
                _ = Example.Greeting.Call.folds.greet(call) { application in
                    buffer.append(contentsOf: ["greeting", "greet", application.input.underlying])
                }
            }) {
                return
            }

            if Example.Call.folds.counter(output, { call in
                _ = Example.Counter.Call.folds.increment(call) { application in
                    buffer.append(
                        contentsOf: ["counter", "increment", "-l", Swift.String(application.input.underlying)]
                    )
                }
            }) {
                return
            }
        }
    }
}

extension Example.CLI {

    public static var coder: Example.CLI.Coder {
        .init()
    }
}
