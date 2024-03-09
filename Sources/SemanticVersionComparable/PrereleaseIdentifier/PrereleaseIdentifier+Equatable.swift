//
//  PrereleaseIdentifier+Equatable.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 12.03.21.
//

public extension PrereleaseIdentifier {
    /// Compares pre-release identifiers for equality.
    ///
    /// - Returns: `true` if pre-release identifiers are equal.
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}
