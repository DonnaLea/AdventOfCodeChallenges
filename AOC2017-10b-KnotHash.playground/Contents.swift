//: Advent of Code 2017 - Day 10 - Knot Hash
// https://adventofcode.com/2017/day/10

import Foundation
import XCTest

var position = 0
var skipSize = 0

func process(lengths: [Int], numbers: [Int]) -> [Int] {
  var numbers = numbers

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

func sparseHash(lengths: [Int], numbers: [Int]) -> [Int] {
  var numbers = numbers

  for _ in 1...64 {
    numbers = process(lengths: lengths, numbers: numbers)
  }

  return numbers
}

func denseHash(lengths: [Int], numbers: [Int]) -> [Int] {
  let numbers = sparseHash(lengths: lengths, numbers: numbers)
  var index = 0
  let length = 16
  var denseNumbers = [Int]()


  while index+length <= numbers.count {
    let slice = numbers[index..<index+length]
    let value = slice.reduce(0, ^)
    denseNumbers.append(value)
    index += length
  }

  return denseNumbers
}

func knotHash(lengths: [Int], numbers: [Int]) -> String {
  var hash = ""
  let hashArray = denseHash(lengths: lengths, numbers: numbers)

  for number in hashArray {
    let hex = String(format:"%02x", number)
    hash.append(hex)
  }

  return hash
}

func generateNumbers(maxNumber: Int) -> [Int] {
  var numbers = [Int]()
  for i in 0...maxNumber {
    numbers.append(i)
  }

  return numbers
}

func convertLengths(input: String) -> [Int] {
  let lengths = input.unicodeScalars.filter{$0.isASCII}.map{Int($0.value)}
  let suffixLengths = [17, 31, 73, 47, 23]

  return lengths + suffixLengths
}

class Tests : XCTestCase {

  override func tearDown() {
    position = 0
    skipSize = 0
  }

  func testConvertLengths1() {
    let input = ""
    let lengths = convertLengths(input: input)

    XCTAssertEqual(lengths, [17, 31, 73, 47, 23])
  }

  func testConvertLengths2() {
    let input = "1,2,3"
    let lengths = convertLengths(input: input)

    XCTAssertEqual(lengths, [49, 44, 50, 44, 51, 17, 31, 73, 47, 23])
  }

  func testInput1() {
    let input = ""
    let lengths = convertLengths(input: input)
    let numbers = generateNumbers(maxNumber: 255)
    let hash = knotHash(lengths: lengths, numbers: numbers)

    XCTAssertEqual(hash, "a2582a3a0e66e6e86e3812dcb672a272")
  }

  func testInput2() {
    let input = "AoC 2017"
    let lengths = convertLengths(input: input)
    let numbers = generateNumbers(maxNumber: 255)
    let hash = knotHash(lengths: lengths, numbers: numbers)

    XCTAssertEqual(hash, "33efeb34ea91902bb2f59c9920caa6cd")
  }

  func testInput3() {
    let input = "1,2,3"
    let lengths = convertLengths(input: input)
    let numbers = generateNumbers(maxNumber: 255)
    let hash = knotHash(lengths: lengths, numbers: numbers)

    XCTAssertEqual(hash, "3efbe78a8d82f29979031a4aa0b16a9d")
  }

  func testInput4() {
    let input = "1,2,4"
    let lengths = convertLengths(input: input)
    let numbers = generateNumbers(maxNumber: 255)
    let hash = knotHash(lengths: lengths, numbers: numbers)

    XCTAssertEqual(hash, "63960835bcdc130f0b66d7ff4f6a5a8e")
  }

  func test() {
    let input = "102,255,99,252,200,24,219,57,103,2,226,254,1,0,69,216"
    let lengths = convertLengths(input: input)
    let numbers = generateNumbers(maxNumber: 255)
    let hash = knotHash(lengths: lengths, numbers: numbers)
    print("hash: \(hash)")
  }
}

Tests.defaultTestSuite.run()
