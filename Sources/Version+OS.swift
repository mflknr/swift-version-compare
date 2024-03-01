//
//  Version+OS.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 06.01.21.
//

import Foundation

public extension ProcessInfo {
    /// The version of the operating system on which the current process is executing.
    @available(macOS, introduced: 10.10)
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
