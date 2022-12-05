import XCTest
@testable import _022

@available(macOS 13.0, *)
final class Day02Tests: XCTestCase {
    func testInput1() {

        let input = day2TestInput
        let value = day2Calculate(input: input)
        XCTAssertEqual(value, 15)
    }

    func testDonnaInput() {
        if let filepath = Bundle.module.path(forResource: "Resources/Day02Input", ofType: "txt") {
            let input = try! String(contentsOfFile: filepath)
            let value = day2Calculate(input: input)
            XCTAssertEqual(value, 15337)
        }
    }
    
    let day2TestInput = """
A Y
B X
C Z
"""
    
}
