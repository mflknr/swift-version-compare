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
protocol SemanticVersionComparable: Comparable, Hashable {
    /// The `MAJOR` identifier of a version.
    var major: UInt { get }
    /// The `MINOR` identifier of a version
    var minor: UInt? { get }
    /// The `PATCH` identifer of a verion.
    var patch: UInt? { get }

    /// Contains strings with pre-release information.
    var extensions: [String]? { get }
}

// MARK: - Equatable

extension SemanticVersionComparable {
    /**
     Compares version objects for equality.

     - Returns: `true` if version objects are equal.
     */
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.major == rhs.major &&
        lhs.minor ?? 0 == rhs.minor ?? 0 &&
        lhs.patch ?? 0 == rhs.patch ?? 0 
    }

    /**
     Strictly compares version objects for equality.

     - Returns: `true` if version objects are strictly equal.
     */
    public static func === (lhs: Self, rhs: Self) -> Bool {
        lhs.major == rhs.major &&
        lhs.minor ?? 0 == rhs.minor ?? 0 &&
        lhs.patch ?? 0 == rhs.patch ?? 0 &&
        lhs.extensions == rhs.extensions
    }
}

// MARK: - Comparable

extension SemanticVersionComparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        guard !(lhs === rhs) else { return false }

        if lhs.major < rhs.major {
            return true
        } else if
            lhs.major == rhs.major,
            lhs.minor ?? 0 < rhs.minor ?? 0 {
            return true
        } else if
            lhs.major == rhs.major,
            lhs.minor == rhs.minor,
            lhs.patch ?? 0 < rhs.patch ?? 0 {
            return true
        } else if
            lhs.major == rhs.major,
            lhs.minor == rhs.minor,
            lhs.patch == rhs.patch,
            lhs.extensions != nil,
            rhs.extensions == nil {
            return true
        } else {
            return false
        }
    }

    public static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs === rhs || lhs < rhs
    }

    public static func > (lhs: Self, rhs: Self) -> Bool {
        guard !(lhs === rhs) else { return false }

        if lhs.major > rhs.major {
            return true
        } else if
            lhs.major == rhs.major,
            lhs.minor ?? 0 > rhs.minor ?? 0 {
            return true
        } else if
            lhs.major == rhs.major,
            lhs.minor == rhs.minor,
            lhs.patch ?? 0 > rhs.patch ?? 0 {
            return true
        } else if
            lhs.major == rhs.major,
            lhs.minor == rhs.minor,
            lhs.patch == rhs.patch,
            lhs.extensions == nil,
            rhs.extensions != nil {
            return true
        } else {
            return false
        }
    }

    public static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs === rhs || lhs > rhs
    }
}

// MARK: - Operations

extension SemanticVersionComparable {
    /**
     A Boolean value indicating the compatibility of two versions.

     - Parameter version: An object that conforms to the `SemanticVersionComparable`protocol.

     - Returns: `true` if both objects have equal major versions.
     */
    public func isCompatible(with version: Self) -> Bool {
        self.major == version.major
    }
}
