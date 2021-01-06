//
//  ComparisonResult.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 06.01.21.
//

/// The severity of an update between versions.
public enum VersionCompareResult {
    /// A `MAJOR`update
    case major
    /// A `MINOR`update
    case minor
    /// A `PATCH`update
    case patch
    /// A pre-release update
    case extensions
    /// The version is not an update (less or equal)
    case noUpdate
}
