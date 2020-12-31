import XCTest
@testable import SwiftVersionCheck

final class SwiftVersionCheckTests: XCTestCase {
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
        "-alpha"
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
    }

    func testInvalidConstruction() {
        invalidVersionData.forEach {
            XCTAssertNil(try? Version($0), "Expected object from string `\($0)` to be nil!")
        }
    }

    func testOperations() {
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

    static var allTests = [
        ("testValidConstruction", testValidConstruction),
        ("testInvalidConstruction", testInvalidConstruction),
    ]
}
