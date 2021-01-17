//
//  Version+Hashable.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 17.01.21.
//

extension Version: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(major)
        hasher.combine(minor)
        hasher.combine(patch)
        hasher.combine(extensions)
    }
}
