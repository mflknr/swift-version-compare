//
//  SemanticVersionComparable.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 29.12.20.
//

/**
 A type that can be expressed as a semantic version conforming to `SemVer` and compared using the relational operators ==, ===, <, <=, >=, and >.

 When comparing two versions their identifier beeing `nil` will be treated as `0`.

     let versionOne = Version(1, 0, 0)
     let versionTwo = Version(1)

     versionOne == versionTwo // <- this statement is `true`

 You can choose between a loosly or strictly comparison considering if you want to compare the extensions a
 the version

     let versionOne = Version(1, 0, 0)
     let versionTwo = Version(1, 0, 0, ["alpha"])

     versionOne == versionTwo // `true`
     versionOne === versionTwo // `false`

 When comparing versions for greater- or lesser-to, the extensions will solely be seen as an indicator for having extensions or not. They will be parsed or interpreted.

     let versionOne = Version(1, 0, 0)
     let versionTwo = Version(1, 0, 0, ["alpha"])

     versionOne > versionTwo // `true`

     let versionThree = Version(1, 0, 0, ["alpha"])
     let versionFour = Version(1, 0, 0, ["pre-release"])

     versionThree > versionFour // `false`

 - Remark: See `https://semver.org` for detailed information.
 */
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
    var build: [BuildIdentifier]? { get }
}

// MARK: -

extension SemanticVersionComparable {
    /**
     A Boolean value indicating the compatibility of two versions.

     - Parameter version: An object that conforms to the `SemanticVersionComparable`protocol.

     - Returns: `true` if both objects have equal major versions.
     */
    public func isCompatible(with version: Self) -> Bool {
        self.major == version.major
    }

    /**
     Compare versions for their update severity.

     - Parameter version: The version you want to compare to another version.

     - Returns: The severity of the update the version inherits.
     */
    public func compare(with version: Self) -> VersionCompareResult {
        let lhs = self
        let rhs = version

        guard lhs != rhs || lhs < rhs else {
            if lhs.prerelease?.count ?? 0 < rhs.prerelease?.count ?? 0 {
                return .prerelease
            } else if lhs.build != rhs.build {
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
}

// MARK: - Default Implementation

extension SemanticVersionComparable {
    public var prerelease: [PrereleaseIdentifier]? { nil }
    public var build: [BuildIdentifier]? { nil }
}
