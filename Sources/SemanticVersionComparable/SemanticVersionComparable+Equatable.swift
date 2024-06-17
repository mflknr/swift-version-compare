//
//  SemanticVersionComparable+Equatable.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 05.01.21.
//

public extension SemanticVersionComparable {
    /// Compares types conforming to ``SemanticVersionComparable`` for equality.
    ///
    /// - Returns: `true` if version objects are equal.
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.major == rhs.major
            && lhs.minor ?? 0 == rhs.minor ?? 0
            && lhs.patch ?? 0 == rhs.patch ?? 0
            && lhs.prerelease == rhs.prerelease
    }

    /// Strictly compares types conforming to``SemanticVersionComparable`` for equality.
    ///
    /// - Returns: `true` if version objects are strictly equal.
    static func === (lhs: Self, rhs: Self) -> Bool {
        lhs.major == rhs.major
            && lhs.minor ?? 0 == rhs.minor ?? 0
            && lhs.patch ?? 0 == rhs.patch ?? 0
            && lhs.prerelease == rhs.prerelease
            && lhs.build == rhs.build
    }
}
