//: Advent of Code 2017 - Day 14 - Disk Defragmentation
// https://adventofcode.com/2017/day/14

import Foundation
import XCTest

// MARK: - Day 10

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

func knotHash(input: String) -> String {
  let lengths = convertLengths(input: input)
  let numbers = generateNumbers(maxNumber: 255)
  let hash = knotHash(lengths: lengths, numbers: numbers)

  return hash
}

func knotHash(lengths: [Int], numbers: [Int]) -> String {
  position = 0
  skipSize = 0
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

// MARK: - Day 14

func usedSquares(input: String) -> Int {
  var usedSquares = 0
  var hashKeys = [String](repeating: input, count: 128)
  for (index, hashKey) in hashKeys.enumerated() {
    let key = "\(hashKey)-\(index)"
    hashKeys[index] = key
  }

  for key in hashKeys {
    let hash = knotHash(input: key)
    let _ = convertToBinaryString(input: hash, count: &usedSquares)
  }

  return usedSquares
}

func convertToBinaryString(input: String, count: inout Int) -> String {
  var fullBinaryString = ""

  for hashChar in input {
    let hashCharString = String(hashChar)
    let binaryInt = Int(hashCharString, radix: 16)!
    let binaryString = String(binaryInt, radix: 2)
    fullBinaryString += binaryString
    for char in binaryString {
      if char == "1" {
        count += 1
      }
    }
  }

  return fullBinaryString
}

class Tests : XCTestCase {

  func testInput1() {
    let input = "flqrgnkx"
    let answer = usedSquares(input: input)
    XCTAssertEqual(answer, 8108)
  }

  func test() {
    let input = "xlqgujun"
    let answer = usedSquares(input: input)
    print(answer)
    XCTAssertEqual(answer, 8204) // Correct answer
  }
}

Tests.defaultTestSuite.run()
