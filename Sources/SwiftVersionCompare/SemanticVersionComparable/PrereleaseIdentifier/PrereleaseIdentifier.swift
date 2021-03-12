//
//  PrereleaseIdentifier.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 12.03.21.
//

public enum PrereleaseIdentifier: Comparable {
    case alpha
    case beta
    case prerelease
    case releaseCandidate
    case alphaNumeric(_ identifier: String)
    case numeric(_ identifier: UInt)
}

extension PrereleaseIdentifier {
    var identifier: String {
        switch self {
        case .alpha:
            return "alpha"
        case .beta:
            return "beta"
        case .prerelease:
            return "pre-release"
        case .releaseCandidate:
            return "rc"
        case let .alphaNumeric(identifier):
            return identifier
        case let .numeric(identifier):
            return String(identifier)
        }
    }
}
