//
//  VersionCompareResult.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 06.01.21.
//

/// The severity of an update between versions.
///
/// - Note: A difference between ``BuildMetaData`` of versions are as `SemVer` states explicitly ignored.
public enum VersionCompareResult {
    /// A `MAJOR`update
    case major
    /// A `MINOR`update
    case minor
    /// A `PATCH`update
    case patch
    /// A pre-release update
    case prerelease
    /// A build update
    case build
    /// The version is not an update (less or equal)
    case noUpdate
}
