//
//  Version+OS.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 06.01.21.
//

import Foundation

public extension ProcessInfo {
    /// The version of the operating system on which the current process is executing.
    @available(macOS, introduced: 10.10)
    @available(iOS, introduced: 8.0)
    @available(tvOS, introduced: 9.0)
    @available(watchOS, introduced: 2.0)
    var comparableOperatingSystemVersion: Version {
        let osVersion: OperatingSystemVersion = operatingSystemVersion
        let version: Version = Version(
            major: UInt(osVersion.majorVersion),
            minor: UInt(osVersion.minorVersion),
            patch: UInt(osVersion.patchVersion)
        )

        return version
    }
}
