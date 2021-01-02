import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SemanticVersionComparableTests.allTests),
        testCase(VersionTests.allTests)
    ]
}
#endif
