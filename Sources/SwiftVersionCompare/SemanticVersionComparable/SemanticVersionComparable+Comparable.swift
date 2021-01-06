//
//  SemanticVersionComparable+Comparable.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 05.01.21.
//

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
