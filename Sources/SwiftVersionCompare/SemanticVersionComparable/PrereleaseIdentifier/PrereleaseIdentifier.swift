//
//  PrereleaseIdentifier.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 12.03.21.
//

/// Typed pre-release identifier.
///
/// - Note: Identifier can be described using alphanumeric or numeric letters.
///
/// - Attention: If an identifier does not show conformance for beeing numeric or alphanumeric it is initialized
///              as `nil`.
public enum PrereleaseIdentifier: Comparable, Hashable {
    /// Identifier displaying `alpha`.
    case alpha

    /// Identifier displaying `beta`.
    case beta

    /// Identifier displaying `prerelease`.
    case prerelease

    /// Identifier displaying `rc`.
    case releaseCandidate

    /// Alphanumeric identifier are lower- and uppercased letters and numbers from 0-9.
    case alphaNumeric(_ identifier: String)

    /// Numeric identifier are positive numbers and zeros, yet they do not allow for leading zeros.
    case numeric(_ identifier: UInt)

    init?(private string: String) {
        if string.isNumericString,
           let numeric = UInt(string) {
            self = .numeric(numeric)
        } else if string.isAlphaNumericString {
            self = .alphaNumeric(string)
        } else {
            return nil
        }
    }
}

public extension PrereleaseIdentifier {
    var value: String {
        switch self {
        case .alpha:
            return "alpha"
        case .beta:
            return "beta"
        case .prerelease:
            return "prerelease"
        case .releaseCandidate:
            return "rc"
        case let .alphaNumeric(identifier):
            return identifier
        case let .numeric(identifier):
            return String(identifier)
        }
    }
}
