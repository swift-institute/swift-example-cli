public import Example
public import ISO_9945_Core
public import ISO_9945_Utility
public import ISO_9945_Utility_Coder

extension Example.CLI.Coder {

    public enum Error: Swift.Error, Equatable {

        case name(ISO_9945.Utility.Name.Coder.Error)

        case invocation(ISO_9945.Utility.Invocation.Coder.Error)

        case missingOperand

        case unknown(domain: Swift.String, operation: Swift.String)
    }
}
