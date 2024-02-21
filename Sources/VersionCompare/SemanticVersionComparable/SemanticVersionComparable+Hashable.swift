//
//  SemanticVersionComparable+Hashable.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 13.03.21.
//

extension SemanticVersionComparable {
    /// Conformance to `Hashable` protocol.
    ///
    /// - Note: Since build-meta-data are not considered in ranking semantic version, it won't be considered
    ///         here either.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(major)
        hasher.combine(minor)
        hasher.combine(patch)
        hasher.combine(prerelease)
    }
}
