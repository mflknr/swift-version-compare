//
//  Version.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 29.12.20.
//

import Foundation

public struct Version: SemanticVersionComparable {
    public var major: UInt
    public var minor: UInt?
    public var patch: UInt?

    public var extensions: [String]?

    public static var `default`: Version = Version(major: 0, minor: 0, patch: 0)

    // MARK: -

    @inlinable
    public init(_ major: UInt, _ minor: UInt? = nil, _ patch: UInt? = nil, _ extensions: [String]? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch

        self.extensions = extensions
    }

    @inlinable
    public init(major: UInt, minor: UInt? = nil, patch: UInt? = nil, extensions: [String]? = nil) {
        self.init(major, minor, patch, extensions)
    }

    private init?(private string: String) {
        // split string into version and extension substrings
        let stringElements = string.split(separator: "-", maxSplits: 1, omittingEmptySubsequences: false)

        // check for non-empty version string e.g. "-alpha"
        guard let versionStringElement = stringElements.first, !versionStringElement.isEmpty else {
            return nil
        }

        // check that the versionString has the correct SemVer format which would be any character (number or letter,
        // no symbols!) x in the form of `x`, `x.x`or `x.x.x`.
        let versionString = String(versionStringElement)
        guard versionString.matchesSemVerFormat() else { return nil }

        // extract version elements from validated versionString as unsigned integers, throws and returns nil
        // if a substring cannot be casted as UInt
        let versionIdentifiers: [UInt]? = try? versionString.split(separator: ".").map(String.init).map {
            // since we already checked the format, we can now try to extract an UInt from the string
            guard let element = UInt($0) else {
                throw Error.invalidVersionIdentifier
            }

            return element
        }

        guard let safeIdentifiers = versionIdentifiers else { return nil }

        // map valid identifiers to corresponding version identifier
        self.major = safeIdentifiers[0]
        self.minor = safeIdentifiers.indices.contains(1) ? safeIdentifiers[1] : nil
        self.patch = safeIdentifiers.indices.contains(2) ? safeIdentifiers[2] : nil

        // if an extension label can be found, extract its content and save it to `extensions`
        if stringElements.indices.contains(1), let attachmentString = stringElements.last {
            self.extensions = attachmentString.split(separator: ".").map(String.init)
        } else {
            self.extensions = nil
        }
    }
}

// MARK: - Initializer

extension Version: LosslessStringConvertible {
    public init?(_ string: String) {
        self.init(private: string)
    }

    public var description: String { absoluteString }
}

extension Version: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(private: value)!
    }
}
extension Version: ExpressibleByStringInterpolation {
    public init(stringInterpolation: DefaultStringInterpolation) {
        self.init(private: String(stringInterpolation: stringInterpolation))!
    }
}

// MARK: - Protocol Conformances

extension Version: CustomDebugStringConvertible {
    public var debugDescription: String { absoluteString }
}

extension Version: Codable {}

extension Version: Hashable {}

// MARK: - Regex

extension String {
    func matches(_ regex: String) -> Bool {
        self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    func matchesSemVerFormat() -> Bool {
        self.matches("^([0-9a-zA-Z]+)\\.([0-9a-zA-Z]+)\\.([0-9a-zA-Z]+)$") ||
            self.matches("^([0-9a-zA-Z]+)\\.([0-9a-zA-Z]+)$") ||
            self.matches("^([0-9a-zA-Z]+)$")
    }
}
