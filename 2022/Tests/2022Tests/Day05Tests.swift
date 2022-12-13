import XCTest
@testable import _022

@available(macOS 13.0, *)
class Day05Tests: XCTestCase {
    
    func testInputDay5() {
        let input = day5TestInput
        let values = day5Calculate(input: input)
        XCTAssertEqual(values, "CMZ")
    }
    
    func testDonnaInput() {
        if let filepath = Bundle.module.path(forResource: "Resources/Day05Input", ofType: "txt") {
            let input = try! String(contentsOfFile: filepath)
            let values = day5Calculate(input: input)
            XCTAssertEqual(values, "SHQWSRBDL")
        }
    }
    
    let day5TestInput = """
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"""
}
