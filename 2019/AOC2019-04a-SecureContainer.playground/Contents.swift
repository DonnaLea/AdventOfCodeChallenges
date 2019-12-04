//: Advent of Code 2019: 04 - Secure Container (Part 1)
// https://adventofcode.com/2019/day/4

import XCTest

func calculate(startRange: Int, endRange: Int) -> Int {
  
  var numValidPasswords = 0
  for number in startRange...endRange {
    if isValidPassword(input: number) {
      numValidPasswords += 1
    }
  }
  
  return numValidPasswords
}

func isValidPassword(input: Int) -> Bool {
  
  let input = String(input)
  
  // check length
  if input.count != 6 {
    return false
  }
  
  // check there are double digits
  var doubleDigits = false
  for (index, char) in input.enumerated() {
    if index + 1 > input.count - 1 {
      break
    }
    
    let nextCharIndex = input.index(input.startIndex, offsetBy: index+1)
    let nextChar = input[nextCharIndex]
    if nextChar == char {
      doubleDigits = true
      break
    }
  }
  
  if !doubleDigits {
    // abort early if not valid
    return false
  }
  
  // check there are no decreasing digits
  for (index, char) in input.enumerated() {
    if index + 1 > input.count - 1 {
      break
    }
    
    let nextCharIndex = input.index(input.startIndex, offsetBy: index+1)
    let nextCharInt = Int(String(input[nextCharIndex]))!
    let currentCharInt = Int(String(char))!
    if nextCharInt < currentCharInt {
      return false
    }
  }
  
  return true
}

class SequenceTests: XCTestCase {
  func testInput1() {
    let input = 111111
    let value = isValidPassword(input: input)
    XCTAssertTrue(value)
  }

  func testInput2() {
    let input = 223450
    let value = isValidPassword(input: input)
    XCTAssertFalse(value)
  }

  func testInput3() {
    let input = 123789
    let value = isValidPassword(input: input)
    XCTAssertFalse(value)
  }

}

SequenceTests.defaultTestSuite.run()

let input = """
"""

let value = calculate(startRange: 356261, endRange: 846303)
print(value)
// Correct Answer: 544
