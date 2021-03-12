//
//  PrereleaseIdentifier+ExpressibleByLiteral.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 12.03.21.
//

extension PrereleaseIdentifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        let alphaNumericString: String = value.alphaNumericString()
        self = .alphaNumeric(alphaNumericString)
    }
}

extension PrereleaseIdentifier: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        let absoluteInteger = abs(value)
        let unsignedInteger = UInt(absoluteInteger)
        self = .numeric(unsignedInteger)
    }
}
