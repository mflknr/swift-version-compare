//
//  SemanticVersionComparableTests.swift
//  SwiftVersionCompareTests
//
//  Created by Marius Hötten-Löns on 01.01.21.
//

import XCTest
@testable import SwiftVersionCompare

final class VersionTests: XCTestCase {
    private let validVersionData: [(String, String, String?)] = [
        ("1.0.0", "1.0.0", nil) ,
        ("1.2.3-alpha.1", "1.2.3", "alpha.1"),
        ("1.0", "1.0" , nil),
        ("1", "1", nil),
        ("13434", "13434", nil),
        ("0.123123.0", "0.123123.0", nil),
        ("0.0.127498127947", "0.0.127498127947", nil)
    ]

    private let invalidVersionData: [String] = [
        ".0.",
        ".0",
        ".123",
        ".400.",
        "1.0.x",
        "1.x.0",
        "x.0.0",
        "",
        "ofkn",
        "_`'*§!§",
        "da.a`sm-k132/89",
        "1.1.1.1",
        "0.0.0.0.0.0",
        ".0.0",
        "0.0.",
        "alpha",
        "-alpha",
        "-beta.123",
        "-",
        "-pre-build",
        "sdjflk.ksdjla.123",
        "asdasd.1.1",
        "1.1.4354vdf"
    ]

    func testValidConstruction() {
        validVersionData.forEach {
            let version = Version($0.0)
            XCTAssertNotNil(version, "Expected object from string `\($0.0)` not to be nil!")
            XCTAssertTrue(version!.versionCode == $0.1, "Expected versionCode to be \($0.1), is: \(version!.versionCode)")
            XCTAssertEqual(version!.debugDescription, version!.description)
            if let expectedExtension = $0.2 {
//                XCTAssertEqual(version!.extension, $0.2, "Expected extension to be \(expectedExtension), is: \(version!.extension ?? "nil")")
            } else {
//                XCTAssertNil(version!.extension, "Expected extension to be nil!")
            }
        }

        // test string literal
        validVersionData.forEach {
            // equivalent to `let version: Version = ""`
            let version = Version(stringLiteral: $0.0)
            XCTAssertNotNil(version, "Expected object from string `\($0.0)` not to be nil!")
            XCTAssertTrue(version.versionCode == $0.1, "Expected versionCode to be \($0.1), is: \(version.versionCode)")
            XCTAssertEqual(version.debugDescription, version.description)
            if let expectedExtension = $0.2 {
//                XCTAssertEqual(version.extension, $0.2, "Expected extension to be \(expectedExtension), is: \(version.extension ?? "nil")")
            } else {
//                XCTAssertNil(version.extension, "Expected extension to be nil!")
            }
        }

        // test string interpolation
        validVersionData.forEach {
            // equivalent to `let version: Version = ""`
            let version: Version = "\($0.0)"
            XCTAssertNotNil(version, "Expected object from string `\($0.0)` not to be nil!")
            XCTAssertTrue(version.versionCode == $0.1, "Expected versionCode to be \($0.1), is: \(version.versionCode)")
            XCTAssertEqual(version.debugDescription, version.description)
            if let expectedExtension = $0.2 {
//                XCTAssertEqual(version.extension, $0.2, "Expected extension to be \(expectedExtension), is: \(version.extension ?? "nil")")
            } else {
//                XCTAssertNil(version.extension, "Expected extension to be nil!")
            }
        }
    }

    func testMemberwiseConstruction() {
        let versionA = Version(major: 1, minor: 2, patch: 3, prerelease: [.alpha])
        XCTAssertEqual(versionA.absoluteString, "1.2.3-alpha", "Expected version to be `1.2.3-alpha`, is: \(versionA)!")

        let versionB = Version(major: 125)
        XCTAssertEqual(versionB, "125.0.0")
    }

    func testInvalidConstruction() {
        invalidVersionData.forEach {
            XCTAssertNil(Version($0), "Expected object from string `\($0)` to be nil!")
        }
    }

    func testBundleVersion() {
        let testBundle = Bundle(for: type(of: self))
        let versionString = testBundle.infoDictionary?["CFBundleShortVersionString"] as? String
        let bundleVersion: Version? = testBundle.shortVersion
        
        XCTAssertNotNil(bundleVersion)
        XCTAssertEqual(versionString!, bundleVersion!.absoluteString, "Expected \(bundleVersion!) to be equal to \(versionString!)!")
    }

    func testProcessInfoVersion() {
        let processInfoOsVersion: OperatingSystemVersion = ProcessInfo.processInfo.operatingSystemVersion
        let comparableOsVersion: Version = ProcessInfo.processInfo.comparableOperatingSystemVersion

        XCTAssertEqual(
            UInt(processInfoOsVersion.majorVersion),
            comparableOsVersion.major,
            "Expected \(processInfoOsVersion.majorVersion) to be equal to \(comparableOsVersion.major)!"
        )
        XCTAssertEqual(
            UInt(processInfoOsVersion.minorVersion),
            comparableOsVersion.minor,
            "Expected \(processInfoOsVersion.minorVersion) to be equal to \(comparableOsVersion.minor!)!"
        )
        XCTAssertEqual(
            UInt(processInfoOsVersion.patchVersion),
            comparableOsVersion.patch,
            "Expected \(processInfoOsVersion.patchVersion) to be equal to \(comparableOsVersion.patch!)!"
        )
    }

    static var allTests = [
        ("testValidConstruction", testValidConstruction),
        ("testMemberwiseConstruction", testMemberwiseConstruction),
        ("testInvalidConstruction", testInvalidConstruction),
        ("testBundleVersion", testBundleVersion),
        ("testProcessInfoVersion", testProcessInfoVersion)
    ]
}
