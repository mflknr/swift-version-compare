//
//  SemanticVersionComparableTests.swift
//  VersionCompareTests
//
//  Created by Marius Felkner on 01.01.21.
//

import XCTest
@testable import VersionCompare

final class SemanticVersionComparableTests: XCTestCase {
    func testEqualOperator() throws {
        let testData: KeyValuePairs = [
            Version("15.287349.10"): Version("15.287349.10"),
            Version("0.1.0"): Version("0.1.0"),
            Version("1.0.0"): Version("1"),
            Version("15.2"): Version("15.2.0"),
            Version("1"): Version("1"),
            Version("123.0.0"): Version("123"),
            Version("1.2"): Version("1.2.0"),
            Version("1.9.0"): Version("1.9"),
            Version("1-alpha.1"): Version("1-alpha.1"),
            Version("24-beta+1"): Version("24-beta+1"),
            Version("1.6.2+exp.1"): Version("1.6.2+exp.1"),
            Version("2.0+500"): Version("2.0+500"),
            Version("300.0+master"): Version("300.0+develop"),
            Version(1, nil, nil, [.alpha]): Version(1, 0, 0, ["alpha"]),
            Version(1, nil, nil, [.beta]): Version(1, 0, 0, ["beta"]),
            Version(1, nil, nil, [.releaseCandidate]): Version(1, 0, 0, ["rc"]),
            Version(1, nil, nil, [.prerelease]): Version(1, 0, 0, ["prerelease"])
        ]

        testData.forEach { lhs, rhs in
            XCTAssertEqual(lhs, rhs, "Expected \(lhs) to be equal to \(rhs)")
            XCTAssertFalse(lhs > rhs, "Expected \(lhs) to be greater than \(rhs)")
            XCTAssertFalse(lhs < rhs, "Expected \(lhs) to be lesser than \(rhs)")
        }
    }

    func testStrictEqualOperator() throws {
        let validTestData: KeyValuePairs = [
            Version("15.287349.10"): Version("15.287349.10"),
            Version("0.1.0"): Version("0.1.0"),
            Version("1.0.0"): Version("1"),
            Version("15.2"): Version("15.2.0"),
            Version("1"): Version("1"),
            Version("123.0.0"): Version("123"),
            Version("1.2"): Version("1.2.0"),
            Version("1.9.0"): Version("1.9"),
            Version("1-alpha.1"): Version("1-alpha.1"),
            Version("24-beta+1"): Version("24-beta+1"),
            Version("1.6.2+exp.1"): Version("1.6.2+exp.1"),
            Version("2.0+500"): Version("2.0+500")
        ]

        let invalidTestData: [Version: Version] = [
            Version("300.0+master"): Version("300.0+develop")
        ]

        validTestData.forEach { lhs, rhs in
            XCTAssertTrue(lhs === rhs, "Expected \(lhs) to be equal to \(rhs)")
            XCTAssertFalse(lhs > rhs, "Expected \(lhs) to be greater than \(rhs)")
            XCTAssertFalse(lhs < rhs, "Expected \(lhs) to be lesser than \(rhs)")
        }

        invalidTestData.forEach { lhs, rhs in
            XCTAssertFalse(lhs === rhs, "Expected \(lhs) to be equal to \(rhs)")
        }
    }

    func testNonEqualOperators() throws {
        let testData: KeyValuePairs = [
            Version("15.287349.9"): Version("15.287349.10"),
            Version("0.0.1"): Version("0.1.0"),
            Version("0"): Version("1.0.0"),
            Version("13.6"): Version("15.2.0"),
            Version("2"): Version("25"),
            Version("777.8987"): Version("777.8988"),
            Version("13.9182.0"): Version("15.2.0"),
            Version("13.9182.1-alpha"): Version("13.9182.1"),
            Version("13.1.1-alpha"): Version("13.1.1-beta"),
            Version("5-h2o4hr"): Version("5"),
            Version("5-alpha.1"): Version("5-alpha.2"),
            Version("5-alpha.2"): Version("5-alpha.beta"),
            Version("5-alpha.23+500"): Version("5-alpha.beta+200")
        ]

        testData.forEach { lhs, rhs in
            // less
            XCTAssertTrue(lhs < rhs, "Expected \(lhs.absoluteString) to be less to \(rhs.absoluteString)!")
            XCTAssertTrue(lhs <= rhs, "Expected \(lhs.absoluteString) to be less or equal to \(rhs.absoluteString)!")
            XCTAssertTrue(lhs <= lhs)
            XCTAssertTrue(rhs <= rhs)

            XCTAssertFalse(rhs < lhs, "Expected \(rhs.absoluteString) to be less to \(lhs.absoluteString)!")
            XCTAssertFalse(lhs < lhs)
            XCTAssertFalse(rhs < rhs)

            // greater
            XCTAssertTrue(rhs > lhs, "Expected \(lhs.absoluteString) to be greater than \(rhs.absoluteString)!")
            XCTAssertTrue(
                rhs >= lhs,
                "Expected \(lhs.absoluteString) to be greater than or equal to \(rhs.absoluteString)!"
            )
            XCTAssertTrue(rhs >= rhs)
            XCTAssertTrue(lhs >= lhs)

            XCTAssertFalse(lhs > rhs, "Expected \(lhs.absoluteString) to be greater to \(rhs.absoluteString)!")
            XCTAssertFalse(rhs > rhs)
            XCTAssertFalse(lhs > lhs)
        }
    }

    func testCompatibility() {
        let versionAA: Version = Version("1.0.0")
        let versionAB: Version = Version("1.1.0")
        let versionAC: Version = Version("1.1.1")
        let versionAD: Version = Version("1.0.1")
        let versionAE: Version = Version("1.6238746")
        let versionAF: Version = Version("1")
        let versionAs: [Version] = [versionAA, versionAB, versionAC, versionAD, versionAE, versionAF]

        let versionBA: Version = Version("2.0.0")
        let versionBB: Version = Version("2.1.0")
        let versionBC: Version = Version("2.1.1")
        let versionBD: Version = Version("2.0.1")
        let versionBE: Version = Version("2.3875")
        let versionBF: Version = Version("2")
        let versionBs: [Version] = [versionBA, versionBB, versionBC, versionBD, versionBE, versionBF]

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
        // swiftlint:disable:next large_tuple
        let testData: [(Version, Version, VersionCompareResult)] = [
            (Version("1"), Version("2"), VersionCompareResult.major),
            (Version("600.123.4"), Version("601.0.1"), VersionCompareResult.major),
            (Version("1.3"), Version("1.5"), VersionCompareResult.minor),
            (Version("3.230.13"), Version("3.235.1"), VersionCompareResult.minor),
            (Version("565.1.123"), Version("565.1.124"), VersionCompareResult.patch),
            (Version("1.2-alpha"), Version("1.2-beta"), VersionCompareResult.prerelease),
            (Version("1.34523"), Version("1.34523+100"), VersionCompareResult.build),
            (Version("2.235234.1"), Version("1.8967596758.4"), VersionCompareResult.noUpdate),
            (Version("2.0.0"), Version("2"), VersionCompareResult.noUpdate),
            (Version("2.0.0"), Version("2+1"), VersionCompareResult.build),
            (Version("2.0"), Version("2-alpha.beta.1"), VersionCompareResult.noUpdate),
            (Version("2.0-alpha.beta.1"), Version("2"), VersionCompareResult.prerelease),
            (Version("2.0-alpha.beta.1"), Version("2+exp.1"), VersionCompareResult.prerelease),
            (Version("2.0-alpha.beta.1"), Version("2-alpha.beta.1+exp.1"), VersionCompareResult.build),
            (Version("2.0-alpha.beta.1"), Version("2.0.0-alpha.beta.1+exp.1"), VersionCompareResult.build),
            (Version("2-alpha.beta.1"), Version("2.0-alpha.beta.1+exp.1"), VersionCompareResult.build),
            (Version("2-alpha.beta.1"), Version("2-alpha.beta.1+exp.1"), VersionCompareResult.build),
            (Version("2-alpha.beta.1+1"), Version("2-alpha.beta.1+exp.1"), VersionCompareResult.build),
            (Version("1.0.0-alpha"), Version("1.0.0+1"), VersionCompareResult.prerelease),
            (Version("1.0.0+234"), Version("1.0.0-alpha"), VersionCompareResult.noUpdate),
            (Version("1.0.0-alpha+1"), Version("1.0.0"), VersionCompareResult.prerelease)
        ]

        testData.forEach { data in
            let versionOne: Version = data.0
            let versionTwo: Version = data.1
            let compareResult: VersionCompareResult = versionOne.compare(with: versionTwo)
            XCTAssertEqual(
                compareResult,
                data.2,
                "Expected result from comparing to be \(data.2) but is \(compareResult)!"
            )
        }
    }
}
