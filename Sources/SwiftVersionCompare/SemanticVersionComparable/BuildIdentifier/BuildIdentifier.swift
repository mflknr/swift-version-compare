//
//  BuildIdentifier.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 12.03.21.
//

public enum BuildIdentifier: Comparable {
    case alphaNumeric(_ identifier: String)
    case digits(_ digits: String)
}

extension BuildIdentifier {
    var identifier: String {
        switch self {
        case let .alphaNumeric(identifier):
            return identifier
        case let .digits(identifier):
            return identifier
        }
    }
}
