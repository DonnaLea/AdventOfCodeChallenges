//: Advent of Code 2017 - Day 14 - Part 2
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

func numGroups(input: String) -> Int {
  var groups = 0
  var hashKeys = [String](repeating: input, count: 128)
  for (index, hashKey) in hashKeys.enumerated() {
    let key = "\(hashKey)-\(index)"
    hashKeys[index] = key
  }

  var binaries = [[Character]]()
  for key in hashKeys {
    let hash = knotHash(input: key)
    let binary = convertToBinaryArray(input: hash)
    binaries.append(binary)
  }

  for y in 0...binaries.count-1 {
    let binary = binaries[y]
    for x in 0...binary.count-1 {
      let char = binaries[y][x]
      if char == "1" {
        groups += 1
        removeGroupAt(location: (x, y), binaries: &binaries)
      }
    }
  }

  return groups
}

typealias Location = (x: Int, y: Int)

func removeGroupAt(location: Location, binaries: inout [[Character]], previous: Location? = nil) {
  guard location.y < binaries.count, location.y >= 0, location.x < binaries[location.y].count, location.x >= 0 else {
    // Out of range.
    return
  }



  // For each neighbouring location, set 1's to 0's
  let value = binaries[location.y][location.x]
  if value == "1" {
    binaries[location.y][location.x] = "0"
    let up = Location(location.x, location.y-1)
    let down = Location(location.x, location.y+1)
    let left = Location(location.x-1, location.y)
    let right = Location(location.x+1, location.y)
    let directions = [up, down, left, right]
    for direction in directions {
      if let previous = previous, direction == previous {
        continue
      }
      removeGroupAt(location: direction, binaries: &binaries, previous: location)
    }
  }
}

func convertToBinaryArray(input: String) -> [Character] {
  var binary = [Character]()

  for hashChar in input {
    let hashCharString = String(hashChar)
    let binaryInt = Int(hashCharString, radix: 16)!
    let binaryString = String(binaryInt, radix: 2)
    let padding = String(repeating: "0", count: 4 - binaryString.count)
    let paddedBinaryString = padding + binaryString
    binary += Array(paddedBinaryString)
  }

  return binary
}

class Tests : XCTestCase {

  func testInput1() {
    let input = "flqrgnkx"
    let answer = numGroups(input: input)
    XCTAssertEqual(answer, 1242)
  }

  func test() {
    let input = "xlqgujun"
    let answer = numGroups(input: input)
    XCTAssertEqual(answer, 1089) // Correct answer
  }
}

Tests.defaultTestSuite.run()
