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
        ("1.0", "1.0.0" , nil),
        ("1", "1.0.0", nil),
        ("13434", "13434.0.0", nil),
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
        "-pre-build"
    ]

    func testValidConstruction() {
        validVersionData.forEach {
            let version = try? Version($0.0)
            XCTAssertNotNil(version, "Expected object from string `\($0.0)` not to be nil!")
            XCTAssertTrue(version!.versionCode == $0.1, "Expected versionCode to be \($0.1), is: \(version!.versionCode)")
            if let expectedExtension = $0.2 {
                XCTAssertEqual(version!.extension, $0.2, "Expected extension to be \(expectedExtension), is: \(version!.extension ?? "nil")")
            } else {
                XCTAssertNil(version!.extension, "Expected extension to be nil!")
            }
        }

        // test string literal
        validVersionData.forEach {
            // equivalent to `let version: Version = ""`
            let version = Version(stringLiteral: $0.0)
            XCTAssertNotNil(version, "Expected object from string `\($0.0)` not to be nil!")
            XCTAssertTrue(version.versionCode == $0.1, "Expected versionCode to be \($0.1), is: \(version.versionCode)")
            if let expectedExtension = $0.2 {
                XCTAssertEqual(version.extension, $0.2, "Expected extension to be \(expectedExtension), is: \(version.extension ?? "nil")")
            } else {
                XCTAssertNil(version.extension, "Expected extension to be nil!")
            }
        }

        // test string interpolation
        validVersionData.forEach {
            // equivalent to `let version: Version = ""`
            let version: Version = "\($0.0)"
            XCTAssertNotNil(version, "Expected object from string `\($0.0)` not to be nil!")
            XCTAssertTrue(version.versionCode == $0.1, "Expected versionCode to be \($0.1), is: \(version.versionCode)")
            if let expectedExtension = $0.2 {
                XCTAssertEqual(version.extension, $0.2, "Expected extension to be \(expectedExtension), is: \(version.extension ?? "nil")")
            } else {
                XCTAssertNil(version.extension, "Expected extension to be nil!")
            }
        }
    }

    func testMemberwiseConstruction() {
        let versionA = Version(major: 1, minor: 2, patch: 3, extensions: ["alpha"])
        XCTAssertEqual(versionA.absoluteString, "1.2.3-alpha", "Expected version to be `1.2.3-alpha`, is: \(versionA)!")

        let versionB = Version(major: 125)
        XCTAssertEqual(versionB, "125.0.0")
    }

    func testInvalidConstruction() {
        invalidVersionData.forEach {
            XCTAssertNil(try? Version($0), "Expected object from string `\($0)` to be nil!")
        }
    }

    func testErrorEmptyVersionString() throws {
        let testStrings = [
            "-alpha",
            "-",
            "-pre-build",
            "-beta.123"
        ]

        try testStrings.forEach { string in
            XCTAssertThrowsError(try Version.init(string)) { error in
                XCTAssertEqual(error as! Error, Error.emptyVersionString, "Expected throwing error for versionString: \(string)")
            }
        }
    }

    func testErrorInvalidVersionFormat() throws {
        let testStrings = [
            "da.a`sm-k132/89",
            "1.1.1.1",
            "0.0.0.0.0.0",
            ".0.0",
            "0.0.",
            "_`'*§!§",
            ".0.",
            ".0",
            ".123",
            ".400."
        ]

        try testStrings.forEach { string in
            XCTAssertThrowsError(try Version.init(string)) { error in
                XCTAssertEqual(error as! Error, Error.invalidVersionFormat, "Expected throwing error for versionString: \(string)")
            }
        }
    }

    func testErrorInvalidVersionIdentifier() throws {
        let testStrings = [
            "1.0.x",
            "1.x.0",
            "x.0.0",
            "sdjflk.ksdjla.123",
            "asdasd.1.1",
            "1.1.4354vdf"
        ]

        try testStrings.forEach { string in
            XCTAssertThrowsError(try Version.init(string)) { error in
                XCTAssertEqual(error as! Error, Error.invalidVersionIdentifier, "Expected throwing error for versionString: \(string)")
            }
        }
    }

    static var allTests = [
        ("testValidConstruction", testValidConstruction),
        ("testMemberwiseConstruction", testMemberwiseConstruction),
        ("testInvalidConstruction", testInvalidConstruction),
        ("testErrorEmptyVersionString", testErrorEmptyVersionString),
        ("testErrorInvalidVersionFormat", testErrorInvalidVersionFormat),
        ("testErrorInvalidVersionIdentifier", testErrorInvalidVersionIdentifier)
    ]
}
