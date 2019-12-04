//: Advent of Code 2019: 04 - Secure Container (Part 2)
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
  var lastChar: Character?
  for (index, char) in input.enumerated() {
    if index + 1 > input.count - 1 {
      break
    }
    
    // mark sure we're not evaluating the same char as last iteration
    if char == lastChar {
      continue
    }
    
    let nextCharIndex = input.index(input.startIndex, offsetBy: index+1)
    let nextChar = input[nextCharIndex]
    if nextChar == char {
      // confirm there isn't a 3rd char
      if index + 2 < input.count {
        let nextNextCharIndex = input.index(input.startIndex, offsetBy: index+2)
        let nextNextChar = input[nextNextCharIndex]
        if nextNextChar == char {
          // can't have 3 in a row
          lastChar = char
          continue
        }
      }
      doubleDigits = true
      break
    }
    lastChar = char
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
    XCTAssertFalse(value)
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
  
  func testInput4() {
    let input = 112233
    let value = isValidPassword(input: input)
    XCTAssertTrue(value)
  }

  func testInput5() {
    let input = 123444
    let value = isValidPassword(input: input)
    XCTAssertFalse(value)
  }

  func testInput6() {
    let input = 111122
    let value = isValidPassword(input: input)
    XCTAssertTrue(value)
  }

}

SequenceTests.defaultTestSuite.run()

let input = """
"""

let value = calculate(startRange: 356261, endRange: 846303)
print(value)
// Correct Answer: 544
