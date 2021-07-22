//
//  BuildMetaData.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 12.03.21.
//

/// Enumerated build-meta-data for simple and `SemVer` conform access.
///
/// - Note: Identifier can be described using alphanumeric letters or digits.
///
/// - Attention: Strings not conforming to `SemVer` will be handled as `nil`.
public enum BuildMetaData: Comparable {
    /// Alphanumeric identifier are lower- and uppercased letters and numbers from 0-9.
    case alphaNumeric(_ identifier: String)

    /// Digit identifier are positive numbers and zeros, thus allowing leading zeros.
    case digits(_ digits: String)

    /// Unknown identifier are used when string literals do not conform to `SemVer` and are removed.
    case unknown

    init(private string: String) {
        if let _ = Int(string) {
            self = .digits(string)
        } else if string.isAlphaNumericString {
            self = .alphaNumeric(string)
        } else {
            self = .unknown
        }
    }
}

public extension BuildMetaData {
    /// Raw string representation of a build-meta-data.
    var value: String {
        switch self {
        case let .alphaNumeric(identifier):
            return identifier
        case let .digits(identifier):
            return identifier
        case .unknown:
            return ""
        }
    }
}
