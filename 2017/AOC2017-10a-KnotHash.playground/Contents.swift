//: Advent of Code 2017 - Day 10 -
// https://adventofcode.com/2017/day/10

import Foundation
import XCTest

func process(input: String, maxNumber: Int = 255) -> [Int] {
  let lengths = input.components(separatedBy: ",").map {
    Int($0)!
  }
  var numbers = [Int]()
  var position = 0
  var skipSize = 0

  for i in 0...maxNumber {
    numbers.append(i)
  }

  for length in lengths {
    let overflow = position+length - numbers.count
    if overflow > 0 {
      let endFirstRange = min(position+length, numbers.count)
      var firstSection = numbers[position..<endFirstRange]
      let endSecondRange = overflow
      var secondSection = numbers[0..<endSecondRange]
      let section = firstSection + secondSection
      let reversed = Array(section.reversed())
      firstSection = reversed[0..<reversed.count-overflow]
      secondSection = reversed[reversed.count-overflow..<reversed.count]
      numbers[position..<endFirstRange] = firstSection
      numbers[0..<endSecondRange] = secondSection
    } else {
      let endRange = position+length
      let section = numbers[position..<endRange]
      let reversed = section.reversed()
      numbers.replaceSubrange(position..<endRange, with: reversed)
    }

    position += (length + skipSize)
    while position >= numbers.count {
      position = position - numbers.count
    }
    skipSize += 1
  }

  return numbers
}

func checkProcess(numbers: [Int]) -> Int? {
  guard numbers.count >= 2 else {
    return nil
  }

  let firstNumber = numbers[0]
  let secondNumber = numbers[1]

  return firstNumber * secondNumber
}

class Tests : XCTestCase {

  func testInput1() {
    let input = "3,4,1,5"
    let processed = process(input: input, maxNumber: 4)
    let check = checkProcess(numbers: processed)
    XCTAssertEqual(check, 12)
  }

  func test() {
    let input = "102,255,99,252,200,24,219,57,103,2,226,254,1,0,69,216"
    let processed = process(input: input)
    let check = checkProcess(numbers: processed)
    print("check: \(check)")
  }
}

Tests.defaultTestSuite.run()
