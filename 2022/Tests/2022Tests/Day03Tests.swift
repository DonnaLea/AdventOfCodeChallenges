import XCTest
@testable import _022

@available(macOS 13.0, *)
final class Day03Tests: XCTestCase {
    
    func testInput1() {
        let input = day3TestInput
        let value = day3Calculate(input: input)
        
        XCTAssertEqual(value, 157)
    }
    
    func testDonnaInput() {
        if let filepath = Bundle.module.path(forResource: "Resources/Day03Input", ofType: "txt") {
            let input = try! String(contentsOfFile: filepath)
            let value = day3Calculate(input: input)
            XCTAssertEqual(value, 7795)
        }
    }
    
    func testInput1b() {
        let input = day3TestInput
        let value = day3bCalculate(input: input)
        
        XCTAssertEqual(value, 70)
    }
    
    func testDonnaInputb() {
        if let filepath = Bundle.module.path(forResource: "Resources/Day03Input", ofType: "txt") {
            let input = try! String(contentsOfFile: filepath)
            let value = day3bCalculate(input: input)
            XCTAssertEqual(value, 2703)
        }
    }
}

let day3TestInput = """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"""
