//
//  SemanticVersionComparable.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 29.12.20.
//

/// A type that can be expressed and utilized as a semantic version conforming to `SemVer`.
///
/// Additionally to the ranking and comparison rules if their version core identifiers are `nil` they
/// will be treated as `0`.
///
///     let versionOne = Version(1, 0, 0)
///     let versionTwo = Version(1)
///
///     versionOne == versionTwo // <- this statement is `true`
///
/// You can choose between a loosly or strictly comparison considering if you want to include the ``BuildMetaData`` of
/// versions when comparing:
///
///     let versionOne = Version(1, 0, 0, [.alpha])
///     let versionTwo = Version(1, 0, 0, [.alpha], ["exp"])
///
///     versionOne == versionTwo // `true`
///     versionOne === versionTwo // `false`
///
/// - Remark: See [semver.org](https://semver.org) for detailed information.
public protocol SemanticVersionComparable: Comparable, Hashable, Sendable {
    /// The `MAJOR` identifier of a version.
    var major: UInt { get }
    /// The `MINOR` identifier of a version
    var minor: UInt? { get }
    /// The `PATCH` identifer of a verion.
    var patch: UInt? { get }

    /// Pre-release identifier of a version.
    var prerelease: [PrereleaseIdentifier]? { get }
    /// Build-meta-data of a version.
    var build: [BuildMetaData]? { get }
}

// MARK: -

public extension SemanticVersionComparable {
    /// A boolean value indicating the compatibility of two versions. As `SemVer` states two versions are
    /// compatible if they have the same major version.
    ///
    /// - Parameter version: A version object that conforms to the ``SemanticVersionComparable`` protocol.
    ///
    /// - Returns: `true` if both versions have equal major versions.
    func isCompatible(with version: Self) -> Bool {
        major == version.major
    }

    /// Compare a object (lhs) conforming to ``SemanticVersionComparable`` with a greater version object (rhs).
    /// Lhs must be a lower version to return a valid result. Otherwise `VersionCompareResult.noUpdate` will be
    /// returned regardless of the difference between the two version objects.
    ///
    /// - Parameter version: A version object that conforms to the ``SemanticVersionComparable`` protocol that will be
    /// compared.
    ///
    /// - Returns: A `VersionCompareResult` as the severity of the update.
    func compare(with version: Self) -> VersionCompareResult {
        let lhs: Self = self
        let rhs: Self = version

        guard !lhs.hasEqualVersionCore(as: rhs) else {
            if lhs < rhs {
                return .prerelease
            }
            if lhs.build != rhs.build,
               lhs.prereleaseIdentifierString == rhs.prereleaseIdentifierString
            {
                return .build
            }

            return .noUpdate
        }

        if lhs.major == rhs.major, lhs.minor == rhs.minor, lhs.patch ?? 0 < rhs.patch ?? 0 {
            return .patch
        }

        if lhs.major == rhs.major, lhs.minor ?? 0 < rhs.minor ?? 0 {
            return .minor
        }

        if lhs.major < rhs.major {
            return .major
        }

        return .noUpdate
    }

    /// Check if a version has an equal version core as another version.
    ///
    /// - Parameter version: A version object that conforms to the ``SemanticVersionComparable`` protocol.
    ///
    /// - Returns: `true` if the respective version cores are equal.
    ///
    /// - Note: A version core is defined as the `MAJOR.MINOR.PATCH` part of a semantic version.
    func hasEqualVersionCore(as version: Self) -> Bool {
        let lhsAsIntSequence: [Int] = [Int(major), Int(minor ?? 0), Int(patch ?? 0)]
        let rhsAsIntSequence: [Int] = [Int(version.major), Int(version.minor ?? 0), Int(version.patch ?? 0)]
        return lhsAsIntSequence.elementsEqual(rhsAsIntSequence)
    }
}

// MARK: - Accessors

public extension SemanticVersionComparable {
    /// The absolute string of the version containing the core version, pre-release identifier and build-meta-data
    /// formatted as `MAJOR.MINOR.PATCH-PRERELEASE+BUILD`.
    var absoluteString: String {
        var versionString: String = coreString
        if let pr = prereleaseIdentifierString {
            versionString = [versionString, pr].joined(separator: "-")
        }

        if let build = buildMetaDataString {
            versionString = [versionString, build].joined(separator: "+")
        }

        return versionString
    }

    /// The string of the version representing `MAJOR.MINOR.PATCH` only.
    var coreString: String {
        [major, minor, patch]
            .compactMap { $0 }
            .map(String.init)
            .joined(separator: ".")
    }

    /// The string of the version containing the pre-release identifier and build-meta-data only.
    var extensionString: String? {
        var extensionsString: String? = prereleaseIdentifierString
        if let build = buildMetaDataString {
            if let ext = extensionsString {
                extensionsString = [ext, build].joined(separator: "+")
            } else {
                extensionsString = build
            }
        }

        return extensionsString
    }

    /// The pre-release identifier as a string if available.
    var prereleaseIdentifierString: String? {
        prerelease?
            .compactMap { $0.value }
            .joined(separator: ".")
    }

    /// The build-meta-data as a string if available.
    var buildMetaDataString: String? {
        build?
            .compactMap { $0.value }
            .joined(separator: ".")
    }
}
