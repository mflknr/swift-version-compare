//
//  PrereleaseIdentifier+Equatable.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 12.03.21.
//

extension PrereleaseIdentifier {
    /// Compares pre-release identifiers for equality.
    ///
    /// - Returns: `true` if pre-release identifiers are equal.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}
