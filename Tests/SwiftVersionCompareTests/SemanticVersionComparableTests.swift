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
            Version("1.0.0"): Version("1"),
            Version("15.2"): Version("15.2.0"),
            Version("1"): Version("1"),
            Version("123.0.0"): Version("123"),
            Version("1.2"): Version("1.2.0"),
            Version("1.9.0"): Version("1.9")
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
            Version("2"): Version("25"),
            Version("777.8987"): Version("777.8988"),
            Version("13.9182.0-alpha"): Version("15.2.0"),
            Version("13.9182.1-alpha"): Version("13.9182.1")
        ]

        testData.forEach { lhs, rhs in
            // less
            XCTAssertTrue(lhs < rhs, "Expected \(lhs) to be less to \(rhs)!")
            XCTAssertTrue(lhs <= rhs, "Expected \(lhs) to be less or equal to \(rhs)!")
            XCTAssertTrue(lhs <= lhs)
            XCTAssertTrue(rhs <= rhs)

            XCTAssertFalse(rhs < lhs)
            XCTAssertFalse(lhs < lhs)
            XCTAssertFalse(rhs < rhs)


            // greater
            XCTAssertTrue(rhs > lhs, "Expected \(lhs) to be greater than \(rhs)!")
            XCTAssertTrue(rhs >= lhs, "Expected \(lhs) to be greater than or equal to \(rhs)!")
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

    func testCompare() {
        let testData: [(Version, Version, UpdateSeverity)] = [
            (Version("1"), Version("2"), UpdateSeverity.major),
            (Version("600.123.4"), Version("601.0.1"), UpdateSeverity.major),
            (Version("1.3"), Version("1.5"), UpdateSeverity.minor),
            (Version("3.230.13"), Version("3.235.1"), UpdateSeverity.minor),
            (Version("565.1.123"), Version("565.1.124"), UpdateSeverity.patch),
            (Version("1.2"), Version("1.2-alpha"), UpdateSeverity.extension),
            (Version("2.235234.1"), Version("1.8967596758.4"), UpdateSeverity.noUpdate),
            (Version("2.0.0"), Version("2"), UpdateSeverity.noUpdate)
        ]

        testData.forEach { data in
            let versionOne = data.0
            let versionTwo = data.1
            let compareResult = versionOne.compare(with: versionTwo)
            XCTAssertTrue(compareResult == data.2, "Expected result from comparing \(data.0) and \(data.1) to be \(data.2) but is \(compareResult)!")
        }
    }

    static var allTests = [
        ("testEqualOperator", testEqualOperator),
        ("testNonEqualOperators", testNonEqualOperators),
        ("testCompatibility", testCompatibility),
        ("testCompare", testCompare)
    ]
}
