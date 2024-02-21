//
//  VersionValidationError.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 29.12.20.
//

import Foundation

enum VersionValidationError: Swift.Error {
    case invalidVersionIdentifier
}

extension VersionValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidVersionIdentifier:
            return NSLocalizedString(
                "The parsed string contained an invalid SemVer version identifier.",
                comment: ""
            )
        }
    }
}
