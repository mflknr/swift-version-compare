//
//  BuildIdentifier+ExpressibleByLiteral.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 12.03.21.
//

extension BuildIdentifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        if Int(value) != nil {
            self = .digits(value)
        } else {
            let alphaNumericString: String = value.alphaNumericString()
            self = .alphaNumeric(alphaNumericString)
        }
    }
}
