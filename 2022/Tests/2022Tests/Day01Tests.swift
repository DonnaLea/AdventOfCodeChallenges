import XCTest
@testable import _022

@available(macOS 13.0, *)
final class Day01Tests: XCTestCase {
    func testInput1() {

        let input = day1TestInput
        let value = day1Calculate(input: input)
        XCTAssertEqual(value, 24000)
    }
    
    func testInput1b() {
        let input = day1TestInput
        let value = day1bCalculate(input: input)
        XCTAssertEqual(value, 45000)
    }

    func testDonnaInput() {
        if let filepath = Bundle.module.path(forResource: "Resources/Day01Input", ofType: "txt") {
            let input = try! String(contentsOfFile: filepath)
            let value = day1Calculate(input: input)
            print("Max calories held by an elf: \(value)")
            XCTAssertEqual(value, 66616)
        }
    }
    
    func testDonnaInput1b() {
        if let filepath = Bundle.module.path(forResource: "Resources/Day01Input", ofType: "txt") {
            let input = try! String(contentsOfFile: filepath)
            let value = day1bCalculate(input: input)
            print("Max 3 snack calories sum: \(value)")
            XCTAssertEqual(value, 199172)
        }
    }
}

let day1TestInput = """
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"""
