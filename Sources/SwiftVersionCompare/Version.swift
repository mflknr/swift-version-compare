//
//  Version.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 29.12.20.
//

import Foundation

/**
 A version type conforming to `SemVer`.

 You can create a new version using string, string literals, string interpolation or memberwise properties.

     // from string
     let version: Version? = "1.0.0"
     let version: Version? = Version("1.0.0")
     let version: Version = "1.0.0" // <- will crash if string does not conform to `SemVer`
     let version: Version = Version("1.0.0") // <- will also crash if string is not a semantic version

     // from memberwise properties
     let version: Version = Version(1, 0, 0)
     let version: Version = Version(major: 1, minor: 0, patch: 0)

 Pre-Release or buildmetadata information are handled as strings in extensions.

     let version: Version = let version: Version = Version(major: 1, minor: 0, patch: 0, extensions: ["alpha"])
     version.absoluteString // -> "1.0.0-alpha"

     let version: Version = Version(2, 32, 16, ["pre-release", "alpha"])
     version.absoluteString // -> "2.32.16-pre-release.alpha"
     version.extensions // -> "pre-release.alpha"

 - Remark: See `https://semver.org` for detailed information.
 */
public struct Version: SemanticVersionComparable {
    public var major: UInt
    public var minor: UInt?
    public var patch: UInt?

    public var extensions: [String]?

    /// An initial version representing the string `0.0.0`.
    public static var initial: Version = Version(major: 0, minor: 0, patch: 0)

    // MARK: -

    /**
     Creates a new version.

     - Parameters:
        - major: The `MAJOR` identifier of a version.
        - minor: The `MINOR` identifier of a version.
        - patch: The `PATCH` identifier of a version.
        - extensions: Contains strings with pre-release information.

     - Returns: A new version.

     - Note: Unsigned integers are used to provide an straightforward way to make sure that the identifiers
     are not negative numbers.
     */
    @inlinable
    public init(_ major: UInt, _ minor: UInt? = nil, _ patch: UInt? = nil, _ extensions: [String]? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch

        self.extensions = extensions
    }

    /**
     Creates a new version.

     - Parameters:
        - major: The `MAJOR` identifier of a version.
        - minor: The `MINOR` identifier of a version.
        - patch: The `PATCH` identifier of a version.
        - extensions: Contains strings with pre-release information.

     - Note: Unsigned integers are used to provide an straightforward way to make sure that the identifiers
     are not negative numbers.
     */
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

// MARK: - Accessors

extension Version {
    /// The absolute string of the version.
    public var absoluteString: String {
        [versionCode, `extension`]
            .compactMap { $0 }
            .joined(separator: "-")
    }

    /// The string of the version representing `MAJOR.MINOR.PATCH`.
    public var versionCode: String {
        [major, minor, patch]
            .compactMap { $0 }
            .map(String.init)
            .joined(separator: ".")
    }

    /// The string of the version containing the extension.
    public var `extension`: String? {
        extensions?.joined(separator: ".")
    }
}

// MARK: - String Expressable and Convertable

extension Version: LosslessStringConvertible {
    /**
     Creates a new version from a string.

     - Parameter string: The string beeing parsed into a version.

     - Returns: A version object or `nil` if string does not conform to `SemVer`.
     */
    public init?(_ string: String) {
        self.init(private: string)
    }

    public var description: String { absoluteString }
}

extension Version: ExpressibleByStringLiteral {
    /**
     Creates a new version from a string literal.

     - Warning: Usage is not recommended unless the given string conforms to `SemVer`.
     */
    public init(stringLiteral value: StringLiteralType) {
        self.init(private: value)!
    }
}

extension Version: ExpressibleByStringInterpolation {
    /**
     Creates a new version from a string interpolation.

     - Warning: Usage is not recommended unless the given string conforms to `SemVer`.
     */
    public init(stringInterpolation: DefaultStringInterpolation) {
        self.init(private: String(stringInterpolation: stringInterpolation))!
    }
}

// MARK: - CustomDebugStringConvertible

extension Version: CustomDebugStringConvertible {
    public var debugDescription: String { absoluteString }
}

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
