import XCTest
@testable import LinePlot

final class LinePlotTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LinePlot().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
