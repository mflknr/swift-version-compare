//
//  VersionTests.swift
//  VersionCompareTests
//
//  Created by Marius Felkner on 01.01.21.
//

import XCTest
@testable import VersionCompare

typealias ValidVersionStringLiteral = String
typealias ExpectedVersionString = String
typealias ExpectedExtensionString = String

final class VersionTests: XCTestCase {
    // swiftlint:disable:next large_tuple
    private let validVersionData: [(ValidVersionStringLiteral, ExpectedVersionString, ExpectedExtensionString?)] = [
        ("1.0.0", "1.0.0", nil),
        ("1.2.3-alpha.1", "1.2.3", "alpha.1"),
        ("1.0", "1.0", nil),
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
        // swiftlint:disable force_unwrapping
        for validVersionData in validVersionData {
            let version: Version? = Version(validVersionData.0)
            XCTAssertNotNil(version, "Expected object from string `\(validVersionData.0)` not to be nil!")
            XCTAssertEqual(
                version!.coreString,
                validVersionData.1,
                "Expected versionCode to be \(validVersionData.1), is: \(version!.coreString)"
            )
            XCTAssertEqual(version!.debugDescription, version!.description)
            if let expectedExtension = validVersionData.2 {
                XCTAssertEqual(
                    version!.extensionString,
                    validVersionData.2,
                    "Expected extension to be \(expectedExtension), is: \(version!.extensionString ?? "nil")"
                )
            } else {
                XCTAssertNil(version!.extensionString, "Expected extension to be nil!")
            }
        }
        // swiftlint:enable force_unwrapping

        // test string literal
        for validVersionData in validVersionData {
            // equivalent to `let version: Version = ""`
            let version = Version(stringLiteral: validVersionData.0)
            XCTAssertNotNil(version, "Expected object from string `\(validVersionData.0)` not to be nil!")
            XCTAssertEqual(
                version.coreString,
                validVersionData.1,
                "Expected versionCode to be \(validVersionData.1), is: \(version.coreString)"
            )
            XCTAssertEqual(version.debugDescription, version.description)
            if let expectedExtension = validVersionData.2 {
                XCTAssertEqual(
                    version.extensionString,
                    validVersionData.2,
                    "Expected extension to be \(expectedExtension), is: \(version.extensionString ?? "nil")"
                )
            } else {
                XCTAssertNil(version.extensionString, "Expected extension to be nil!")
            }
        }

        // test string interpolation
        for validVersionData in validVersionData {
            // equivalent to `let version: Version = ""`
            let version: Version = "\(validVersionData.0)"
            XCTAssertNotNil(version, "Expected object from string `\(validVersionData.0)` not to be nil!")
            XCTAssertEqual(
                version.coreString,
                validVersionData.1,
                "Expected versionCode to be \(validVersionData.1), is: \(version.coreString)"
            )
            XCTAssertEqual(version.debugDescription, version.description)
            if let expectedExtension = validVersionData.2 {
                XCTAssertEqual(
                    version.extensionString,
                    validVersionData.2,
                    "Expected extension to be \(expectedExtension), is: \(version.extensionString ?? "nil")"
                )
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
            build: [
                .alphaNumeric("exp"),
                .digits("300"),
                "test"
            ]
        )
        XCTAssertEqual(
            versionC.absoluteString,
            "1.2.3-alpha.release+exp.300.test",
            "Expected version to be `1.2.3-alpha.release+exp.300.test`, is: \(versionC)!"
        )

        let versionD = Version(
            major: 1,
            minor: 2,
            patch: 3,
            prerelease: [.alphaNumeric("alpha"), .numeric(1), .beta, .releaseCandidate, .prerelease],
            build: [.alphaNumeric("exp"), .digits("300"), "test"]
        )
        XCTAssertEqual(
            versionD.absoluteString,
            "1.2.3-alpha.1.beta.rc.prerelease+exp.300.test",
            "Expected version to be `1.2.3-alpha.release+exp.300.test`, is: \(versionD)!"
        )
    }

    func testInvalidConstruction() {
        for invalidVersionData in invalidVersionData {
            XCTAssertNil(Version(invalidVersionData), "Expected object from string `\(invalidVersionData)` to be nil!")
        }
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
            // swiftlint:disable:next force_unwrapping
            "Expected \(processInfoOsVersion.minorVersion) to be equal to \(comparableOsVersion.minor!)!"
        )
        XCTAssertEqual(
            UInt(processInfoOsVersion.patchVersion),
            comparableOsVersion.patch,
            // swiftlint:disable:next force_unwrapping
            "Expected \(processInfoOsVersion.patchVersion) to be equal to \(comparableOsVersion.patch!)!"
        )
    }
}
