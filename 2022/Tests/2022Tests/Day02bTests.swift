import XCTest
@testable import _022

@available(macOS 13.0, *)
final class Day02bTests: XCTestCase {
    func testInput1b() {

        let input = day2TestInput
        let value = day2bCalculate(input: input)
        XCTAssertEqual(value, 12)
    }

    func testDonnaInputb() {
        print("testing")
        if let filepath = Bundle.module.path(forResource: "Resources/Day02Input", ofType: "txt") {
            let input = try! String(contentsOfFile: filepath)
            let value = day2bCalculate(input: input)
            XCTAssertEqual(value, 11696)
        }
    }
    
    let day2TestInput = """
A Y
B X
C Z
"""
    
}
