//
//  Version+Bundle.swift
//  SwiftVersionCompare
//
//  Created by Marius Felkner on 05.01.21.
//

import Foundation

public extension Bundle {
     /// The version of the current bundle.
     ///
     /// - Note: Uses the key `CFBundleShortVersionString` for retrieving version values.
    var shortVersion: Version? {
        guard let versionString: String = infoDictionary?["CFBundleShortVersionString"] as? String else { return nil }
        let version: Version? = Version(versionString)

        return version
    }

    /// The full version of the current bundle.
    ///
    /// - Note: Uses the key `CFBundleShortVersionString` and `CFBundleVersion` for retrieving version values.
    var version: Version? {
        guard
            let versionString: String = infoDictionary?["CFBundleShortVersionString"] as? String,
            let buildString: String = infoDictionary?["CFBundleVersion"] as? String else {
            return nil
        }
        let fullVersionString: String = "\(versionString)+\(buildString)"
        let version: Version? = Version(fullVersionString)

        return version
    }
}
