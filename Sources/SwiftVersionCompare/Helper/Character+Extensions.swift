//
//  Character+Extensions.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 30.03.21.
//

internal extension Character {
    var isZero: Bool {
        if self == "0" {
            return true
        } else {
            return false
        }
    }
}
