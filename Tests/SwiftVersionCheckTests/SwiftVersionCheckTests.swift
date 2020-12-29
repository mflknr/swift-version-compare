import XCTest
@testable import SwiftVersionCheck

final class SwiftVersionCheckTests: XCTestCase {
    private let validVersionData: [(String, String, String?)] = [
        ("1.0.0", "1.0.0", nil) ,
        ("1.2.3-alpha.1", "1.2.3", "alpha.1"),
        ("1.0", "1.0.0" , nil),
        ("1", "1.0.0", nil),
        ("13434", "13434.0.0", nil)
    ]

    private let invalidVersionData: [String] = [
        ".0.",
        ".0",
        "1.0.x",
        "1.x.0",
        "x.0.0",
        "",
        "ofkn",
        "_`'*§!§",
        "da.a`sm-k132/89"
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

    static var allTests = [
        ("testValidConstruction", testValidConstruction),
        ("testInvalidConstruction", testInvalidConstruction),
    ]
}
