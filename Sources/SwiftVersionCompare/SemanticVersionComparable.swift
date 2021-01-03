//
//  SemanticVersionComparable.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 29.12.20.
//

protocol SemanticVersionComparable: Comparable, Codable, Hashable {
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
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.major == rhs.major &&
        lhs.minor ?? 0 == rhs.minor ?? 0 &&
        lhs.patch ?? 0 == rhs.patch ?? 0 &&
        lhs.extensions?.isEmpty == rhs.extensions?.isEmpty
    }

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
        guard lhs != rhs else { return false }

        if lhs.major < rhs.major {
            return true
        } else if lhs.major == rhs.major, lhs.minor ?? 0 < rhs.minor ?? 0 {
            return true
        } else if lhs.major == rhs.major, lhs.minor == rhs.minor, lhs.patch ?? 0 < rhs.patch ?? 0 {
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
        guard lhs != rhs else { return false }

        if lhs.major > rhs.major {
            return true
        } else if lhs.major == rhs.major, lhs.minor ?? 0 > rhs.minor ?? 0 {
            return true
        } else if lhs.major == rhs.major, lhs.minor == rhs.minor, lhs.patch ?? 0 > rhs.patch ?? 0 {
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
    /// A Boolean value indicating whether the version is compatible with a given different version.
    /// - Parameter version: An object that conforms to the `SemanticVersionComparable`protocol.
    /// - Returns: A boolean indication the compatibility.
    public func isCompatible(with version: Self) -> Bool {
        self.major == version.major
    }
}

// MARK: - Accessor

extension SemanticVersionComparable {
    public var absoluteString: String {
        [versionCode, `extension`]
            .compactMap { $0 }
            .joined(separator: "-")
    }

    public var versionCode: String {
        [major, minor, patch]
            .compactMap { $0 }
            .map(String.init)
            .joined(separator: ".")
    }

    public var `extension`: String? {
        extensions?.joined(separator: ".")
    }
}

