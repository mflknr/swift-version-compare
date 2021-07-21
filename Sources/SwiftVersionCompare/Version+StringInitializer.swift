//
//  Version+StringOperators.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 05.01.21.
//

extension Version: LosslessStringConvertible {
    /// Creates a new version from a string.
    ///
    /// - Parameter string: The string beeing parsed into a version.
    ///
    /// - Returns: A version object or `nil` if string does not conform to `SemVer`.
    public init?(_ string: String) {
        self.init(private: string)
    }

    public var description: String { absoluteString }
}

extension Version: ExpressibleByStringLiteral {
    /// Creates a new version from a string literal.
    ///
    /// - Warning: Usage is not recommended unless the given string conforms to `SemVer`.
    public init(stringLiteral value: StringLiteralType) {
        self.init(private: value)!
    }
}

extension Version: ExpressibleByStringInterpolation {
    /// Creates a new version from a string interpolation.
    ///
    /// - Warning: Usage is not recommended unless the given string conforms to `SemVer`.
    public init(stringInterpolation: DefaultStringInterpolation) {
        self.init(private: String(stringInterpolation: stringInterpolation))!
    }
}
