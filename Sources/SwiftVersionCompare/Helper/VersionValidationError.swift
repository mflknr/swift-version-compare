//
//  VersionValidationError.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 29.12.20.
//

import Foundation

enum VersionValidationError: Swift.Error {
    case invalidVersionIdentifier(identifier: String)
}

extension VersionValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidVersionIdentifier(let identifier):
            return NSLocalizedString(
                "The parsed string contained an invalid SemVer version identifier: \(identifier).",
                comment: ""
            )
        }
    }
}
