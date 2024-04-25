//
//  PrereleaseIdentifier+ExpressibleByLiteral.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 12.03.21.
//

// MARK: - PrereleaseIdentifier + LosslessStringConvertible

extension PrereleaseIdentifier: LosslessStringConvertible {
    public var description: String { value }

    public init?(_ string: String) {
        self.init(private: string)
    }
}

// MARK: - PrereleaseIdentifier + ExpressibleByStringLiteral

extension PrereleaseIdentifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(private: value)
    }
}

// MARK: - PrereleaseIdentifier + ExpressibleByIntegerLiteral

extension PrereleaseIdentifier: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        let absoluteInteger: Int = abs(value)
        let unsignedInteger = UInt(absoluteInteger)
        self = .numeric(unsignedInteger)
    }
}
