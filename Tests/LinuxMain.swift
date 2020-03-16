import XCTest

import PersistenceKit_Test

var testCaseEntrySet: [XCTestCaseEntry] {
    var result = [XCTestCaseEntry]()
    result.append(contentsOf: PersistenceKit_Test.testCaseEntrySet)
    return result
}

XCTMain(testCaseEntrySet)
