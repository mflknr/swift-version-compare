//
//  BuildMetaData+ExpressibleByLiteral.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 12.03.21.
//

extension BuildMetaData: LosslessStringConvertible {
    public init?(_ string: String) {
        self.init(private: string)
    }

    public var description: String { value }
}
