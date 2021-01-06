//
//  SemanticVersionComparable+Equatable.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 05.01.21.
//

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
