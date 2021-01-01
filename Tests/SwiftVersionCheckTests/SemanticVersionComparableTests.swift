//
//  SemanticVersionComparableTests.swift
//  SwiftVersionCheckTests
//
//  Created by Marius Hötten-Löns on 01.01.21.
//

import XCTest
@testable import SwiftVersionCheck

final class SemanticVersionComparableTests: XCTestCase {
    func testEqualOperator() throws {
        let testData: [Version: Version] = [
            try! Version("15.287349.10"): try! Version("15.287349.10"),
            try! Version("0.1.0"): try! Version("0.1.0"),
            try! Version("1"): try! Version("1.0.0"),
            try! Version("15.2"): try! Version("15.2.0")
        ]

        testData.forEach { lhs, rhs in
            XCTAssertEqual(lhs, rhs, "Expected \(lhs) to be equal to \(rhs)")
            XCTAssertFalse(lhs > rhs)
            XCTAssertFalse(lhs < rhs)
        }
    }

    func testOperators() throws {
        let testData: [Version: Version] = [
            try! Version("15.287349.9"): try! Version("15.287349.10"),
            try! Version("0.0.1"): try! Version("0.1.0"),
            try! Version("0"): try! Version("1.0.0"),
            try! Version("13.9182"): try! Version("15.2.0"),
            try! Version("13.9182.0-alpha"): try! Version("15.2.0"),
            try! Version("13.9182.1-alpha"): try! Version("13.9182.1")
        ]

        testData.forEach { lhs, rhs in
            // less
            XCTAssertTrue(lhs < rhs)
            XCTAssertTrue(lhs <= rhs)
            XCTAssertTrue(lhs <= lhs)
            XCTAssertTrue(rhs <= rhs)

            XCTAssertFalse(rhs < lhs)
            XCTAssertFalse(lhs < lhs)
            XCTAssertFalse(rhs < rhs)


            // greater
            XCTAssertTrue(rhs > lhs)
            XCTAssertTrue(rhs >= lhs)
            XCTAssertTrue(rhs >= rhs)
            XCTAssertTrue(lhs >= lhs)

            XCTAssertFalse(lhs > rhs)
            XCTAssertFalse(rhs > rhs)
            XCTAssertFalse(lhs > lhs)
        }
    }

    func testCompatibility() {
        let versionAA = try! Version("1.0.0")
        let versionAB = try! Version("1.1.0")
        let versionAC = try! Version("1.1.1")
        let versionAD = try! Version("1.0.1")
        let versionAE = try! Version("1.6238746")
        let versionAF = try! Version("1")
        let versionAs = [versionAA, versionAB, versionAC, versionAD, versionAE, versionAF]

        let versionBA = try! Version("2.0.0")
        let versionBB = try! Version("2.1.0")
        let versionBC = try! Version("2.1.1")
        let versionBD = try! Version("2.0.1")
        let versionBE = try! Version("2.3875")
        let versionBF = try! Version("2")
        let versionBs = [versionBA, versionBB, versionBC, versionBD, versionBE, versionBF]

        // compatible
        versionAs.forEach { first in
            versionAs.forEach { second in
                XCTAssertTrue(first.isCompatible(with: second))
            }
        }

        versionBs.forEach { first in
            versionBs.forEach { second in
                XCTAssertTrue(first.isCompatible(with: second))
            }
        }

        // incompatible
        versionAs.forEach { first in
            versionBs.forEach { second in
                XCTAssertFalse(first.isCompatible(with: second))
            }
        }

        versionBs.forEach { first in
            versionAs.forEach { second in
                XCTAssertFalse(first.isCompatible(with: second))
            }
        }
    }
}
