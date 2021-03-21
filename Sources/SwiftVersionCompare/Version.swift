//
//  Version.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 29.12.20.
//

import Foundation

/// A version type conforming to `SemVer`.
///
/// You can create a new version using string, string literals, string interpolation formatted like `MAJOR.MINOR.PATCH-EXTENSIONS` or memberwise properties.
///
///     // from string
///     let version: Version? = "1.0.0"
///     let version: Version? = Version("1.0.0")
///     let version: Version = "1.0.0" // <- will crash if string does not conform to `SemVer`
///     let version: Version = Version("1.0.0") // <- will also crash if string is not a semantic version
///
///     // from memberwise properties
///     let version: Version = Version(1, 0, 0)
///     let version: Version = Version(major: 1, minor: 0, patch: 0)
///
/// Pre-Release or buildmetadata information are handled as strings in extensions.
///
///     let version: Version = let version: Version = Version(major: 1, minor: 0, patch: 0, extensions: ["alpha"])
///     version.absoluteString // -> "1.0.0-alpha"
///
///     let version: Version = Version(2, 32, 16, ["pre-release", "alpha"])
///     version.absoluteString // -> "2.32.16-pre-release.alpha"
///     version.extensions // -> "pre-release.alpha"
///
/// - Remark: See `https://semver.org` for detailed information.
public struct Version: SemanticVersionComparable {
    public var major: UInt
    public var minor: UInt?
    public var patch: UInt?

    public var prerelease: [PrereleaseIdentifier]?
    public var build: [BuildIdentifier]?

    /// An initial version representing the string `0.0.0`.
    public static var initial: Version = Version(major: 0, minor: 0, patch: 0)

    // MARK: -

    /// Creates a new version.
    ///
    /// - Parameters:
    ///    - major: The `MAJOR` identifier of a version.
    ///    - minor: The `MINOR` identifier of a version.
    ///    - patch: The `PATCH` identifier of a version.
    ///    - extensions: Contains strings with pre-release information.
    ///
    /// - Returns: A new version.
    ///
    /// - Note: Unsigned integers are used to provide an straightforward way to make sure that the identifiers
    /// are not negative numbers.
    @inlinable
    public init(
        _ major: UInt,
        _ minor: UInt? = nil,
        _ patch: UInt? = nil,
        _ prerelease: [PrereleaseIdentifier]? = nil,
        _ build: [BuildIdentifier]? = nil
    ) {
        self.major = major
        self.minor = minor
        self.patch = patch

        self.prerelease = prerelease
        self.build = build
    }

    /// Creates a new version.
    ///
    /// - Parameters:
    ///    - major: The `MAJOR` identifier of a version.
    ///    - minor: The `MINOR` identifier of a version.
    ///    - patch: The `PATCH` identifier of a version.
    ///    - extensions: Contains strings with pre-release information.
    ///
    /// - Note: Unsigned integers are used to provide an straightforward way to make sure that the identifiers
    ///         are not negative numbers.
    @inlinable
    public init(
        major: UInt,
        minor: UInt? = nil,
        patch: UInt? = nil,
        prerelease: [PrereleaseIdentifier]? = nil,
        build: [BuildIdentifier]? = nil
    ) {
        self.init(major, minor, patch, prerelease, build)
    }

    internal init?(private string: String) {
        // split string into version, pre-release and build-meta-data identifier substrings
        let versionSplitBuild = string
            .split(separator: "+", maxSplits: 1, omittingEmptySubsequences: false)
        guard
            !versionSplitBuild.isEmpty,
            let versionPrereleaseString = versionSplitBuild.first else {
            return nil
        }

        let versionSplitPrerelease = versionPrereleaseString
            .split(separator: "-", maxSplits: 1, omittingEmptySubsequences: false)

        // check for non-empty version string e.g. "-alpha"
        guard
            !versionSplitPrerelease.isEmpty,
            let versionStringElement = versionSplitPrerelease.first else {
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

        // extract pre-release identifier if available
        if
            versionSplitPrerelease.indices.contains(1),
            let prereleaseSubstring = versionSplitPrerelease.last {
            self.prerelease = String(prereleaseSubstring)
                .split(separator: ".")
                .map(String.init)
                .compactMap {
                    if let asInt = Int($0) {
                        return PrereleaseIdentifier.init(integerLiteral: asInt)
                    } else {
                        return PrereleaseIdentifier.init($0)
                    }
                }
        } else {
            self.prerelease = nil
        }

        // extract build-meta-data identifier if available
        if versionSplitBuild.indices.contains(1), let buildSubstring = versionSplitBuild.last {
            self.build = String(buildSubstring)
                .split(separator: ".")
                .map(String.init)
                .compactMap {
                    BuildIdentifier.init($0)
                }
        } else {
            self.build = nil
        }
    }
}

// MARK: - Accessors

public extension Version {
    /// The absolute string of the version.
    var absoluteString: String {
        var versionString = versionCode
        if let pr = prereleaseIdentifier {
            versionString = [versionString, pr].joined(separator: "-")
        }

        if let build = buildMetaData {
            versionString = [versionString, build].joined(separator: "+")
        }

        return versionString
    }

    /// The string of the version representing `MAJOR.MINOR.PATCH`.
    var versionCode: String {
        [major, minor, patch]
            .compactMap { $0 }
            .map(String.init)
            .joined(separator: ".")
    }

    /// The string of the version representing the pre-release identifier and build-meta-data.
    var versionExtension: String? {
        var extensionsString: String? = prereleaseIdentifier
        if let build = buildMetaData {
            if let ext = extensionsString {
                extensionsString = [ext, build].joined(separator: "+")
            } else {
                extensionsString = build
            }
        }

        return extensionsString
    }

    /// The pre-release identifier as a string if available.
    var prereleaseIdentifier: String? {
        prerelease?
            .compactMap { $0.value }
            .joined(separator: ".")
    }

    /// The build meta data as a string if available.
    var buildMetaData: String? {
        build?
            .compactMap { $0.value }
            .joined(separator: ".")
    }
}

extension Version: CustomDebugStringConvertible {
    public var debugDescription: String { absoluteString }
}
