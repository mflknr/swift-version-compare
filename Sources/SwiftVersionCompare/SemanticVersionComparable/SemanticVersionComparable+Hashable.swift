//
//  SemanticVersionComparable+Hashable.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 13.03.21.
//

extension SemanticVersionComparable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(major)
        hasher.combine(minor)
        hasher.combine(patch)
        hasher.combine(prerelease)
    }
}
