//
//  SemanticVersionComparable+Hashable.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 13.03.21.
//

public extension SemanticVersionComparable {
    /// Conformance to `Hashable` protocol.
    ///
    /// - Note: Since ``BuildMetaData`` are not considered in ranking semantic version, it won't be considered
    ///         here either.
    func hash(into hasher: inout Hasher) {
        hasher.combine(major)
        hasher.combine(minor)
        hasher.combine(patch)
        hasher.combine(prerelease)
    }
}
