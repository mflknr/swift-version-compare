//
//  Error.swift
//  SwiftVersionCheck
//
//  Created by Marius Hötten-Löns on 29.12.20.
//

enum Error: Swift.Error {
    case parse(String)
    case format(String)
}
