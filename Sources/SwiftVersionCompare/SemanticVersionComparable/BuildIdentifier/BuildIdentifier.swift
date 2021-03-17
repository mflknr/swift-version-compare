//
//  BuildIdentifier.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 12.03.21.
//

/// Typed build-meta-data identifier.
///
/// - Note: Identifier can be described using alphanumeric letters or digits.
///
/// - Attention: 
public enum BuildIdentifier: Comparable {
    /// Alphanumeric identifier are lower- and uppercased letters and numbers from 0-9.
    case alphaNumeric(_ identifier: String)

    /// Digit identifier are positive numbers and zeros, thus allowing leading zeros.
    case digits(_ digits: String)

    internal init?(private string: String) {
        if let _ = Int(string) {
            self = .digits(string)
        } else if string.isAlphaNumericString {
            self = .alphaNumeric(string)
        } else {
            return nil
        }
    }
}

extension BuildIdentifier {
    var value: String {
        switch self {
        case let .alphaNumeric(identifier):
            return identifier
        case let .digits(identifier):
            return identifier
        }
    }
}
