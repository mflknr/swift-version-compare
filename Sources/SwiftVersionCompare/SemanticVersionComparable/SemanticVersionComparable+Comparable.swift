//
//  SemanticVersionComparable+Comparable.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 05.01.21.
//

extension SemanticVersionComparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        // if versions are identical on major, minor and patch level, compare them lexicographiocally
        guard lhs == rhs else {
            // cast UInt to Int for each identifier to compare ordering lexicographically. missing
            // identifier for minor or patch versions (e. g. "1" or "2.0") are handled as zeros.
            let lhsAsIntSequence = [Int(lhs.major), Int(lhs.minor ?? 0), Int(lhs.patch ?? 0)]
            let rhsAsIntSequence = [Int(rhs.major), Int(rhs.minor ?? 0), Int(rhs.patch ?? 0)]
            return lhsAsIntSequence.lexicographicallyPrecedes(rhsAsIntSequence)
        }

        // non-pre-release lhs version is always >= than rhs version
        guard
            let lhspr = lhs.prerelease,
            lhspr.count > 0 else {
            return false
        }

        // same goes for rhs vise versa
        guard
            let rhspr = rhs.prerelease,
            rhspr.count > 0  else {
            return true
        }

        // compare content of pre-release identifier
        for (untypedLhs, untypedRhs) in zip(lhspr, rhspr) {
            // if both pre-release identifier are equal, skip the now obsolete comparison
            if untypedLhs == untypedRhs { continue }

            // cast identifiers to int or string as Any
            let typedLhs: Any = Int(untypedLhs.value) ?? untypedLhs.value
            let typedRhs: Any = Int(untypedRhs.value) ?? untypedRhs.value

            switch (typedLhs, typedRhs) {
            case let (intLhs as Int, intRhs as Int):
                // numerics are compared numerically
                return intLhs < intRhs
            case let (stringLhs as String, stringRhs as String):
                // strings alphanumerically using ASCII
                return stringLhs < stringRhs
            case (is Int, is String):
                // numeric pre-releases are lesser than string pre-releases
                return true
            case (is String, is Int):
                return false
            default:
                // since we are relatively type safe at this point, it is save to assume we will never
                // enter here. so do nothing
                ()
            }
        }

        // lastly, if number of identifiers of lhs version is lower than rhs version, it ranks lower
        return lhspr.count < rhspr.count
    }

    public static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs === rhs || lhs < rhs
    }

    public static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs === rhs || lhs > rhs
    }
}
