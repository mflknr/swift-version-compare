//
//  Version+Bundle.swift
//  SwiftVersionCompare
//
//  Created by Marius Hötten-Löns on 05.01.21.
//

import Foundation

public extension Bundle {
    /**
     The version of the current bundle.

     - Note: Uses the key `CFBundleShortVersionString` for retrieving version values.
     */
    var shortVersion: Version? {
        guard let versionString: String = infoDictionary?["CFBundleShortVersionString"] as? String else { return nil }
        let version: Version? = Version(versionString)

        return version
    }
}
