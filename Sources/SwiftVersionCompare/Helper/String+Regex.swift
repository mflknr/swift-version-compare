//
//  String+Regex.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 05.01.21.
//

import Foundation

extension String {
    func matches(_ regex: String) -> Bool {
        self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    func matchesSemVerFormat() -> Bool {
        self.matches("^([0-9a-zA-Z]+)\\.([0-9a-zA-Z]+)\\.([0-9a-zA-Z]+)$") ||
            self.matches("^([0-9a-zA-Z]+)\\.([0-9a-zA-Z]+)$") ||
            self.matches("^([0-9a-zA-Z]+)$")
    }

    var isAlphaNumericString: Bool {
        self.matches("[A-Za-z0-9]+")
    }

    var isNumericString: Bool {
        self.matches("[0-9]+")
    }

    func alphaNumericString() -> String {
        let pattern = "[^A-Za-z0-9]+"
        let result = self.replacingOccurrences(
            of: pattern,
            with: "",
            options: [.regularExpression]
        )

        return result
    }
}
