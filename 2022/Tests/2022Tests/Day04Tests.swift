import XCTest
@testable import _022

@available(macOS 13.0, *)
final class Day04Tests: XCTestCase {
    func testInputDay4() {

        let input = day4TestInput
        let value = day4Calculate(input: input)
        print("day4 tests")
        XCTAssertEqual(value, 2)
    }
    
    func testDay4DonnaInput() {
        if let filepath = Bundle.module.path(forResource: "Resources/Day04Input", ofType: "txt") {
            let input = try! String(contentsOfFile: filepath)
            let value = day4Calculate(input: input)
            print("ranges contained within each other: \(value)")
            XCTAssertEqual(value, 550)
        }
    }
    
    func testInputDay4b() {
        let input = day4TestInput
        let value = day4bCalculate(input: input)
        print("day4 tests")
        XCTAssertEqual(value, 4)
    }
    
    func testDay4bDonnaInput() {
        if let filepath = Bundle.module.path(forResource: "Resources/Day04Input", ofType: "txt") {
            let input = try! String(contentsOfFile: filepath)
            let value = day4bCalculate(input: input)
            print("ranges overlapping: \(value)")
            XCTAssertEqual(value, 931)
        }
    }
    
    let day4TestInput = """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"""
}
