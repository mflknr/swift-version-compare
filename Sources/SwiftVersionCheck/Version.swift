import Foundation

struct Version: SemanticVersionComparable {
    private(set) var major: UInt
    private(set) var minor: UInt
    private(set) var patch: UInt

    private(set) var extensions: [String]?

    // MARK: -

    init(_ string: String) throws {
        // split string into version and extension substrings
        let stringElements = string.split(separator: "-", maxSplits: 1, omittingEmptySubsequences: false)

        // check for non-empty version string e.g. "-alpha"
        guard let versionStringElement = stringElements.first, !versionStringElement.isEmpty else {
            throw Error.emptyVersionString
        }

        // check that the versionString has the correct SemVer format which would be any character (number or letter,
        // no symbols!) x in the form of `x`, `x.x`or `x.x.x`.
        let versionString = String(versionStringElement)
        guard versionString.matchesSemVerFormat() else {
            throw Error.invalidVersionFormat
        }

        // extract version elements from validated versionString as unsigned integers
        let versionIdentifiers: [UInt] = try versionString.split(separator: ".").map(String.init).map {
            // since we already checked the format, we can now try to extract an UInt from the string
            guard let element = UInt($0) else {
                throw Error.invalidVersionIdentifier
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

// MARK: - Initializer

extension Version {
    init(
        major: UInt,
        minor: UInt = 0,
        patch: UInt = 0,
        extensions: [String]? = nil
    ) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.extensions = extensions
    }
}

extension Version: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        try! self.init(value)
    }
}
extension Version: ExpressibleByStringInterpolation {
    init(stringInterpolation: DefaultStringInterpolation) {
        try! self.init(String(stringInterpolation: stringInterpolation))
    }
}

// MARK: - Protocol Conformances

extension Version: CustomDebugStringConvertible {
    var debugDescription: String { absoluteString }
}

extension Version: Codable {}

extension Version: Hashable {}

// MARK: - Regex

private extension String {
    func matches(_ regex: String) -> Bool {
        self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    func matchesSemVerFormat() -> Bool {
        self.matches("^([0-9a-zA-Z]+)\\.([0-9a-zA-Z]+)\\.([0-9a-zA-Z]+)$") ||
            self.matches("^([0-9a-zA-Z]+)\\.([0-9a-zA-Z]+)$") ||
            self.matches("^([0-9a-zA-Z]+)$")
    }
}
