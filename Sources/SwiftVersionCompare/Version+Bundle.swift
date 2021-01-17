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

    /**
     The version and build of the current bundle.

     - Note: Uses the key `CFBundleShortVersionString` and `CFBundleVersion` for retrieving version values.
     */
    var version: Version? {
        guard
            let shortVersionString: String = infoDictionary?["CFBundleShortVersionString"] as? String,
            let buildString: String = infoDictionary?["CFBundleVersion"] as? String else {
            return nil
        }

        let versionString: String = "\(shortVersionString)+\(buildString)"
        let version: Version? = Version(versionString)

        return version
    }
}
