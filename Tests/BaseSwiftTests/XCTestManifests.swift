import XCTest

#if !canImport(ObjectiveC)

public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AsyncSequenceExtensionTests.allTests),
        testCase(AtomicPropertyTests.allTests),
        testCase(JsonTests.allTests),
        testCase(OptionalExtensionTests.allTests),
        testCase(URLRequestExtensionTests.allTests),
    ]
}

#endif
