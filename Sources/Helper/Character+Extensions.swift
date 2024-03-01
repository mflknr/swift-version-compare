//
//  Character+Extensions.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 30.03.21.
//

internal extension Character {
    var isZero: Bool {
        if self == "0" {
            return true
        }
        return false
    }
}
