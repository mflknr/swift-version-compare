//
//  SemanticVersionComparableTests.swift
//  SwiftVersionCompareTests
//
//  Created by Marius Hötten-Löns on 01.01.21.
//

import XCTest
@testable import SwiftVersionCompare

final class SemanticVersionComparableTests: XCTestCase {
    func testEqualOperator() throws {
        let testData: [Version: Version] = [
            Version("15.287349.10"): Version("15.287349.10"),
            Version("0.1.0"): Version("0.1.0"),
            Version("1"): Version("1.0.0"),
            Version("15.2"): Version("15.2.0")
        ]

        testData.forEach { lhs, rhs in
            XCTAssertEqual(lhs, rhs, "Expected \(lhs) to be equal to \(rhs)")
            XCTAssertFalse(lhs > rhs)
            XCTAssertFalse(lhs < rhs)
        }
    }

    func testNonEqualOperators() throws {
        let testData: [Version: Version] = [
            Version("15.287349.9"): Version("15.287349.10"),
            Version("0.0.1"): Version("0.1.0"),
            Version("0"): Version("1.0.0"),
            Version("13.9182"): Version("15.2.0"),
            Version("13.9182.0-alpha"): Version("15.2.0"),
            Version("13.9182.1-alpha"): Version("13.9182.1")
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
        let versionAA = Version("1.0.0")
        let versionAB = Version("1.1.0")
        let versionAC = Version("1.1.1")
        let versionAD = Version("1.0.1")
        let versionAE = Version("1.6238746")
        let versionAF = Version("1")
        let versionAs = [versionAA, versionAB, versionAC, versionAD, versionAE, versionAF]

        let versionBA = Version("2.0.0")
        let versionBB = Version("2.1.0")
        let versionBC = Version("2.1.1")
        let versionBD = Version("2.0.1")
        let versionBE = Version("2.3875")
        let versionBF = Version("2")
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

    static var allTests = [
        ("testEqualOperator", testEqualOperator),
        ("testNonEqualOperators", testNonEqualOperators),
        ("testCompatibility", testCompatibility)
    ]
}
