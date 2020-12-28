import XCTest
@testable import SwiftVersionCheck

final class SwiftVersionCheckTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftVersionCheck().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
