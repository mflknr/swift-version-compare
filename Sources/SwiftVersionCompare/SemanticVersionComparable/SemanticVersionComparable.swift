//
//  SemanticVersionComparable.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 29.12.20.
//

/// A type that can be expressed as a semantic version conforming to `SemVer`.
///
/// Additionally to the ranking rules, when comparing two versions, if their version core identifiers are `nil` they
/// will be treated as `0`.
///
///     let versionOne = Version(1, 0, 0)
///     let versionTwo = Version(1)
///
///     versionOne == versionTwo // <- this statement is `true`
///
/// You can choose between a loosly or strictly comparison considering if you want to compare the build-meta-data of
/// the version
///
///     let versionOne = Version(1, 0, 0, [.alpha])
///     let versionTwo = Version(1, 0, 0, [.alpha], ["exp"])
///
///     versionOne == versionTwo // `true`
///     versionOne === versionTwo // `false`
///
/// - Remark: See `https://semver.org` for detailed information.
public protocol SemanticVersionComparable: Comparable, Hashable {
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
    /// A Boolean value indicating the compatibility of two versions.
    ///
    /// - Parameter version: An object that conforms to the `SemanticVersionComparable`protocol.
    ///
    /// - Returns: `true` if both objects have equal major versions.
    func isCompatible(with version: Self) -> Bool {
        major == version.major
    }

    /// Compare versions for their update severity.
    ///
    /// - Parameter version: The version you want to compare to another version.
    ///
    /// - Returns: The severity of the update the version inherits.
    func compare(with version: Self) -> VersionCompareResult {
        let lhs = self
        let rhs = version

        guard !lhs.hasEqualVersionCore(as: rhs) else {
            if lhs < rhs {
                return .prerelease
            }
            if lhs.build != rhs.build &&
               lhs.prereleaseIdentifierString == rhs.prereleaseIdentifierString {
                return .build
            }

            return .noUpdate
        }

        if
            lhs.major == rhs.major,
            lhs.minor == rhs.minor,
            lhs.patch ?? 0 < rhs.patch ?? 0 {
            return .patch
        } else if
            lhs.major == rhs.major,
            lhs.minor ?? 0 < rhs.minor ?? 0 {
            return .minor
        } else if
            lhs.major < rhs.major {
            return .major
        } else {
            return .noUpdate
        }
    }

    /// Check if a version has an equal version core as another version.
    ///
    /// - Parameter version: The other version you want to check with.
    ///
    /// - Returns: `true` if the respective version cores are equal.
    func hasEqualVersionCore(as version: Self) -> Bool {
        let lhsAsIntSequence = [Int(major), Int(minor ?? 0), Int(patch ?? 0)]
        let rhsAsIntSequence = [Int(version.major), Int(version.minor ?? 0), Int(version.patch ?? 0)]
        return lhsAsIntSequence.elementsEqual(rhsAsIntSequence)
    }
}

// MARK: - Accessors

public extension SemanticVersionComparable {
    /// The absolute string of the version.
    var absoluteString: String {
        var versionString = coreString
        if let pr = prereleaseIdentifierString {
            versionString = [versionString, pr].joined(separator: "-")
        }

        if let build = buildMetaDataString {
            versionString = [versionString, build].joined(separator: "+")
        }

        return versionString
    }

    /// The string of the version representing `MAJOR.MINOR.PATCH`.
    var coreString: String {
        [major, minor, patch]
            .compactMap { $0 }
            .map(String.init)
            .joined(separator: ".")
    }

    /// The string of the version representing the pre-release identifier and build-meta-data.
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

    /// The build meta data as a string if available.
    var buildMetaDataString: String? {
        build?
            .compactMap { $0.value }
            .joined(separator: ".")
    }
}
