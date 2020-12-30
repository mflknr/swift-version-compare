import Foundation

struct Version: SemanticVersionComparable {
    private(set) var major: UInt
    private(set) var minor: UInt
    private(set) var patch: UInt

    private(set) var extensions: [String]?

    // MARK: -

    init(_ string: String) throws {
        // split string into version and extension substrings
        let stringElements = string.split(separator: "-", maxSplits: 1, omittingEmptySubsequences: true)

        // check for non-empty version string e.g. "-alpha"
        guard let versionStringElement = stringElements.first else {
            throw Error.parse("Empty version string in: \(string)")
        }

        // now make sure that the version has the correct SemVer format
        let versionString = String(versionStringElement)
        guard versionString.matchesSemVerIdentifiers() else {
            throw Error.format("Version string (\(versionStringElement)) seems to alternate from SemVer format.")
        }

        // extract version elements from validated versionString as unsigned integers
        let versionIdentifiers: [UInt] = try versionString.split(separator: ".").map(String.init).map {
            // since we checked for only positive numbers with regex we can savely init UInt from String, but i won't
            // the crash operator (`return UInt($0)!`) even if my very live depends on it
            guard let element = UInt($0) else {
                throw Error.parse("Version element is invalid: \($0)")
            }

            return element
        }

        // even if we only get `1` as a version (which is valid SemVer btw.) we default to `1.0.0`
        // same goes for `1.0` -> `1.0.0`
        self.major = versionIdentifiers[0]
        self.minor = versionIdentifiers.indices.contains(1) ? versionIdentifiers[1] : 0
        self.patch = versionIdentifiers.indices.contains(2) ? versionIdentifiers[2] : 0

        // if an extension label can be found, extract its content and save it to `extensions`
        if stringElements.indices.contains(1), let attachmentString = stringElements.last {
            self.extensions = attachmentString.split(separator: ".").map(String.init)
        } else {
            self.extensions = nil
        }
    }
}

// MARK: -

extension Version: CustomDebugStringConvertible {
    var debugDescription: String { absoluteString }
}

private extension String {
    func matches(_ regex: String) -> Bool {
        self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    func matchesSemVerIdentifiers() -> Bool {
        self.matches("^([0-9]+)\\.([0-9]+)\\.([0-9]+)$") ||
            self.matches("^([0-9]+)\\.([0-9]+)$") ||
            self.matches("^([0-9]+)$")
    }
}
