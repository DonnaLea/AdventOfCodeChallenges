//: Advent of Code 2019: XX - Template (Part 1)
// https://adventofcode.com/2019/day/XX

import XCTest

extension String {

  var length: Int {
    return count
  }

  subscript (i: Int) -> String {
    return self[i ..< i + 1]
  }

  func substring(fromIndex: Int) -> String {
    return self[min(fromIndex, length) ..< length]
  }

  func substring(toIndex: Int) -> String {
    return self[0 ..< max(0, toIndex)]
  }

  subscript (r: Range<Int>) -> String {
    let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                        upper: min(length, max(0, r.upperBound))))
    let start = index(startIndex, offsetBy: range.lowerBound)
    let end = index(start, offsetBy: range.upperBound - range.lowerBound)
    return String(self[start ..< end])
  }

}

// ----------------------------------------------------------------------------------

func calculate(input: String) -> Int {
  
  return 0
}

class SequenceTests: XCTestCase {
  func testInput1() {
    let input = "testInputString"
    let value = calculate(input: input)
    XCTAssertEqual(value, 0)
  }

  func testInput2() {
    let input = "testInputString"
    let value = calculate(input: input)
    XCTAssertEqual(value, 0)
  }

  func testInput3() {
    let input = "testInputString"
    let value = calculate(input: input)
    XCTAssertEqual(value, 0)
  }

  func testInput4() {
    let input = "testInputString"
    let value = calculate(input: input)
    XCTAssertEqual(value, 0)
  }

  func testInputEmpty() {
    let input = "testInputString"
    let value = calculate(input: input)
    XCTAssertEqual(value, 0)
  }

}

SequenceTests.defaultTestSuite.run()

let input = """
"""

//let value = calculate(input: input)
//print(value)
// Correct Answer: ???


