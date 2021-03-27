//
//  Version.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 29.12.20.
//

import Foundation

/// A version type conforming to `SemVer`.
///
/// You can create a new version using string, string literals and string interpolation formatted like `MAJOR.MINOR.PATCH-PRERELEASE+BUILD` or memberwise properties.
///
///     // from string
///     let version: Version? = "1.0.0"
///     let version: Version? = Version("1.0.0-alpha.1+23")
///     let version: Version = "1.0.0" // <- will crash if string does not conform to `SemVer`
///     let version: Version = Version("1.0.0") // <- will also crash if string is not a semantic version
///
///     // from memberwise properties
///     let version: Version = Version(1, 0, 0)
///     let version: Version = Version(major: 1, minor: 0, patch: 0, prerelease: ["alpha, "1"], build: ["exp"])
///
/// Pre-release identifier or build-meta-data can be handled as strings or as a few selected enumared case with it
/// associated raw value (see `PrereleaseIdentifier` and `BuildMetaData` for more).
///
///     let version: Version = let version: Version = Version(major: 1, minor: 0, patch: 0, prerelease: ["alpha"], build: ["500"])
///     version.absoluteString // -> "1.0.0-alpha+500"
///
///     let version: Version = Version(2, 32, 16, ["family", .alpha], ["1"])
///     version.absoluteString // -> "2.32.16-family.alpha+1"
///     version.coreString // -> "2.32.16"
///     version.extensionString // -> "family.alpha+1"
///     version.prereleaseIdentifer // -> "family.alpha"
///     version.buildMetaData // -> "1"
///
/// - Remark: See `https://semver.org` for detailed information.
public struct Version: SemanticVersionComparable {
    public var major: UInt
    public var minor: UInt?
    public var patch: UInt?

    public var prerelease: [PrereleaseIdentifier]?
    public var build: [BuildMetaData]?

    // MARK: - Init

    /// Creates a new version.
    ///
    /// - Parameters:
    ///    - major: The `MAJOR` identifier of a version.
    ///    - minor: The `MINOR` identifier of a version.
    ///    - patch: The `PATCH` identifier of a version.
    ///    - prerelease: The pre-release identifier of a version.
    ///    - build: The build-meta-data of a version.
    ///
    /// - Returns: A new version.
    ///
    /// - Note: Unsigned integers are used to provide an straightforward way to make sure that the identifiers
    ///         are not negative numbers.
    @inlinable
    public init(
        _ major: UInt,
        _ minor: UInt? = nil,
        _ patch: UInt? = nil,
        _ prerelease: [PrereleaseIdentifier]? = nil,
        _ build: [BuildMetaData]? = nil
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
    ///    - prerelease: The pre-release identifier of a version.
    ///    - build: The build-meta-data of a version.
    ///
    /// - Note: Unsigned integers are used to provide an straightforward way to make sure that the identifiers
    ///         are not negative numbers.
    @inlinable
    public init(
        major: UInt,
        minor: UInt? = nil,
        patch: UInt? = nil,
        prerelease: [PrereleaseIdentifier]? = nil,
        build: [BuildMetaData]? = nil
    ) {
        self.init(major, minor, patch, prerelease, build)
    }

    internal init?(private string: String) {
        // split string into version with pre-release identifier and build-meta-data substrings
        let versionSplitBuild = string.split(separator: "+", omittingEmptySubsequences: false)

        // check if string does not contain only build-meta-data e.g. "+123" or falsely "+123+something"
        guard
            !versionSplitBuild.isEmpty,
            versionSplitBuild.count <= 2,
            let versionPrereleaseString = versionSplitBuild.first else {
            return nil
        }

        // split previously splitted substring into version and pre-release identifier substrings
        let versionSplitPrerelease = versionPrereleaseString
            .split(separator: "-", omittingEmptySubsequences: false)

        // check for non-empty or invalid version string e.g. "-alpha" or "-alpha-beta"
        guard
            !versionSplitPrerelease.isEmpty,
            versionSplitPrerelease.count <= 2,
            let versionStringElement = versionSplitPrerelease.first else {
            return nil
        }

        // check that the version string has the correct SemVer format which are 0 and positive numbers in the form
        // of `x`, `x.x`or `x.x.x`.
        let versionString = String(versionStringElement)
        guard versionString.matchesSemVerFormat() else { return nil }

        // extract version elements from validated version string as unsigned integers, throws and returns nil
        // if a substring cannot be casted as UInt, since only positive numbers are allowed
        let versionIdentifiers: [UInt]? = try? versionString.split(separator: ".").map(String.init).map {
            // we already checked the format so we can now try to extract an UInt from the string
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
                    BuildMetaData.init($0)
                }
        } else {
            self.build = nil
        }
    }
}

// MARK: - Static Accessors

public extension Version {
    /// An initial version representing the string `0.0.0`.
    static var initial: Version = Version(major: 0, minor: 0, patch: 0)
}

extension Version: CustomDebugStringConvertible {
    public var debugDescription: String { absoluteString }
}
