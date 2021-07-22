//
//  SemanticVersionComparableTests.swift
//  SwiftVersionCompareTests
//
//  Created by Marius Felkner on 01.01.21.
//

import XCTest
@testable import SwiftVersionCompare

typealias ValidVersionStringLiteral = String
typealias ExpectedVersionString = String
typealias ExpectedExtensionString = String

final class VersionTests: XCTestCase {
    private let validVersionData: [(ValidVersionStringLiteral, ExpectedVersionString, ExpectedExtensionString?)] = [
        ("1.0.0", "1.0.0", nil) ,
        ("1.2.3-alpha.1", "1.2.3", "alpha.1"),
        ("1.0", "1.0" , nil),
        ("1", "1", nil),
        ("13434", "13434", nil),
        ("0.123123.0", "0.123123.0", nil),
        ("0.0.127498127947", "0.0.127498127947", nil),
        ("1+1", "1", "1"),
        ("1-beta.1+exval30", "1", "beta.1+exval30"),
        ("23.400-familyalpha.2.beta+172948712.1", "23.400", "familyalpha.2.beta+172948712.1"),
        ("1.5+thomassbuild", "1.5", "thomassbuild"),
        ("3.265893.15-alpha.13.beta+exp.sha.315", "3.265893.15", "alpha.13.beta+exp.sha.315"),
        ("5", "5", nil),
        ("5.3", "5.3", nil),
        ("5.3.2", "5.3.2", nil),
        ("5.0", "5.0", nil),
        ("5.0.0", "5.0.0", nil),
        ("5.3.0", "5.3.0", nil),
        ("5.3.2", "5.3.2", nil),
        ("5+3990", "5", "3990"),
        ("5.3+3990", "5.3", "3990"),
        ("5.3.2+3990", "5.3.2", "3990"),
        ("5.0+3990", "5.0", "3990"),
        ("5.0.0+3990", "5.0.0", "3990"),
        ("5.3.0+3990", "5.3.0", "3990"),
        ("5.3.2+3990", "5.3.2", "3990"),
        ("5-rc", "5", "rc"),
        ("5.3-rc", "5.3", "rc"),
        ("5.3.2-rc", "5.3.2", "rc"),
        ("5.0-rc", "5.0", "rc"),
        ("5.0.0-rc", "5.0.0", "rc"),
        ("5.3.0-rc", "5.3.0", "rc"),
        ("5.3.2-rc", "5.3.2", "rc"),
        ("5-rc+3990", "5", "rc+3990"),
        ("5.3-rc+3990", "5.3", "rc+3990"),
        ("5.3.2-rc+3990", "5.3.2", "rc+3990"),
        ("5.0-rc+3990", "5.0", "rc+3990"),
        ("5.0.0-rc+3990", "5.0.0", "rc+3990"),
        ("5.3.0-rc+3990", "5.3.0", "rc+3990"),
        ("5.3.2-rc+3990", "5.3.2", "rc+3990"),
        ("1-1", "1", "1"),
        ("1.2.3-alpha-beta+3", "1.2.3", "alpha-beta+3"),
        ("1.0.0-alpha-1skladnk1.1+123", "1.0.0", "alpha-1skladnk1.1+123"),
        ("1.0.0-alpha-1skl--------ad---nk1.---+123", "1.0.0", "alpha-1skl--------ad---nk1.---+123"),
        ("1.2.3-test+123-123-123-123", "1.2.3", "test+123-123-123-123")
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
        "1.1.4354vdf",
        "18+123+something",
        "1.2.3-test+123-123-123-123+",
        "0000001.00000001.01111",
        "1.1.1-alpha%",
        "2-beta+23$"
    ]

    func testValidConstruction() {
        validVersionData.forEach {
            let version = Version($0.0)
            XCTAssertNotNil(version, "Expected object from string `\($0.0)` not to be nil!")
            XCTAssertTrue(version!.coreString == $0.1, "Expected versionCode to be \($0.1), is: \(version!.coreString)")
            XCTAssertEqual(version!.debugDescription, version!.description)
            if let expectedExtension = $0.2 {
                XCTAssertEqual(version!.extensionString, $0.2, "Expected extension to be \(expectedExtension), is: \(version!.extensionString ?? "nil")")
            } else {
                XCTAssertNil(version!.extensionString, "Expected extension to be nil!")
            }
        }

        // test string literal
        validVersionData.forEach {
            // equivalent to `let version: Version = ""`
            let version = Version(stringLiteral: $0.0)
            XCTAssertNotNil(version, "Expected object from string `\($0.0)` not to be nil!")
            XCTAssertTrue(version.coreString == $0.1, "Expected versionCode to be \($0.1), is: \(version.coreString)")
            XCTAssertEqual(version.debugDescription, version.description)
            if let expectedExtension = $0.2 {
                XCTAssertEqual(version.extensionString, $0.2, "Expected extension to be \(expectedExtension), is: \(version.extensionString ?? "nil")")
            } else {
                XCTAssertNil(version.extensionString, "Expected extension to be nil!")
            }
        }

        // test string interpolation
        validVersionData.forEach {
            // equivalent to `let version: Version = ""`
            let version: Version = "\($0.0)"
            XCTAssertNotNil(version, "Expected object from string `\($0.0)` not to be nil!")
            XCTAssertTrue(version.coreString == $0.1, "Expected versionCode to be \($0.1), is: \(version.coreString)")
            XCTAssertEqual(version.debugDescription, version.description)
            if let expectedExtension = $0.2 {
                XCTAssertEqual(version.extensionString, $0.2, "Expected extension to be \(expectedExtension), is: \(version.extensionString ?? "nil")")
            } else {
                XCTAssertNil(version.extensionString, "Expected extension to be nil!")
            }
        }
    }

    func testMemberwiseConstruction() {
        let versionA = Version(major: 1, minor: 2, patch: 3, prerelease: [.alpha])
        XCTAssertEqual(versionA.absoluteString, "1.2.3-alpha", "Expected version to be `1.2.3-alpha`, is: \(versionA)!")

        let versionB = Version(major: 125)
        XCTAssertEqual(versionB, "125.0.0")

        let versionC = Version(
            major: 1,
            minor: 2,
            patch: 3,
            prerelease: [.alpha, "release"],
            build: [.alphaNumeric("exp"), .digits("300"), "test"])
        XCTAssertEqual(versionC.absoluteString, "1.2.3-alpha.release+exp.300.test", "Expected version to be `1.2.3-alpha.release+exp.300.test`, is: \(versionC)!")

        let versionD = Version(
            major: 1,
            minor: 2,
            patch: 3,
            prerelease: [.alphaNumeric("alpha"), .numeric(1), .beta, .releaseCandidate, .prerelease],
            build: [.alphaNumeric("exp"), .digits("300"), "test"])
        XCTAssertEqual(versionD.absoluteString, "1.2.3-alpha.1.beta.rc.prerelease+exp.300.test", "Expected version to be `1.2.3-alpha.release+exp.300.test`, is: \(versionD)!")
    }

    func testInvalidConstruction() {
        invalidVersionData.forEach {
            XCTAssertNil(Version($0), "Expected object from string `\($0)` to be nil!")
        }
    }

    func testInvalidBundleVersion() {
        // the main bundle from test targets is different from actual app targets and will be invalid for use,
        // but not for testing
        XCTAssertNil(Bundle.main.shortVersion)
        XCTAssertNil(Bundle.main.version)
    }

    func testValidBundleVersion() {
        let testBundle = Bundle(for: type(of: self))
        let shortVersionString = testBundle.infoDictionary?["CFBundleShortVersionString"] as? String
        let buildString = testBundle.infoDictionary?["CFBundleVersion"] as? String
        let shortVersion: Version? = testBundle.shortVersion
        let version: Version? = testBundle.version

        XCTAssertNotNil(shortVersion)
        XCTAssertEqual(shortVersionString!, shortVersion!.absoluteString, "Expected \(shortVersion!) to be equal to \(shortVersionString!)!")

        XCTAssertNotNil(version)
        XCTAssertEqual("\(shortVersionString!)+\(buildString!)", version!.absoluteString, "Expected \(version!) to be equal to \(buildString!)!")
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
        ("testBundleVersion", testValidBundleVersion),
        ("testProcessInfoVersion", testProcessInfoVersion)
    ]
}
