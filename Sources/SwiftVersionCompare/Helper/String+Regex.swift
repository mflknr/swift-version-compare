//
//  String+Regex.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 05.01.21.
//

import Foundation

internal extension String {
    func matches(_ regex: String) -> Bool {
        range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    func matchesSemVerFormat() -> Bool {
        matches("^([0-9a-zA-Z]+)\\.([0-9a-zA-Z]+)\\.([0-9a-zA-Z]+)$") ||
            matches("^([0-9a-zA-Z]+)\\.([0-9a-zA-Z]+)$") ||
            matches("^([0-9a-zA-Z]+)$")
    }

    var isAlphaNumericString: Bool {
        matches("[a-zA-Z-][0-9a-zA-Z-]+")
    }

    var isNumericString: Bool {
        matches("[0-9]+")
    }
}
