struct Version: SemanticVersionComparable {
    private(set) var major: UInt
    private(set) var minor: UInt
    private(set) var patch: UInt

    private(set) var extensions: [String]?

    init(_ string: String) throws {
        // split string into version and attachment substrings
        let stringElements = string.split(separator: "-", maxSplits: 1, omittingEmptySubsequences: true)

        // throw if version can't be parsed from string
        guard let versionString = stringElements.first else {
            throw Error.parse("Empty version string in: \(string)")
        }

        // extract version elements from versionString
        let versionIdentifiers: [UInt] = try versionString.split(separator: ".").map(String.init).map {
            guard let element = UInt($0) else {
                throw Error.parse("Version element is invalid: \($0)")
            }

            return element
        }

        // check for correct
        let numberAllowedElements = 1...3
        guard numberAllowedElements ~= versionIdentifiers.count else {
            throw Error.format("Version elements are the wrong size, \(versionIdentifiers.count), it should be >=1, <=3")
        }

        self.major = versionIdentifiers[0]
        self.minor = versionIdentifiers.indices.contains(1) ? versionIdentifiers[1] : 0
        self.patch = versionIdentifiers.indices.contains(2) ? versionIdentifiers[2] : 0

        // if an attachment label can be found, extract it and save it to `attachments`
        if stringElements.indices.contains(1), let attachmentString = stringElements.last {
            self.extensions = attachmentString.split(separator: ".").map(String.init)
        } else {
            self.extensions = nil
        }
    }
}

extension Version: CustomDebugStringConvertible {
    var debugDescription: String { absoluteString }
}
