//
//  BuildMetaData+ExpressibleByLiteral.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 12.03.21.
//

// MARK: - BuildMetaData + LosslessStringConvertible

extension BuildMetaData: LosslessStringConvertible {
    public var description: String { value }

    public init?(_ string: String) {
        self.init(private: string)
    }
}

// MARK: - BuildMetaData + ExpressibleByStringLiteral

extension BuildMetaData: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(private: value)
    }
}
