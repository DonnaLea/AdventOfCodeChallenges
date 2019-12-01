//: Advent of Code 2017 - Day 6 - Memory Reallocation (Part 1 & 2)
// https://adventofcode.com/2017/day/6

import Foundation
import XCTest

func cyclesToRedistributeBeforeInfiniteLoop(input: String) -> (Int, Int) {
  var cycles = 0
  var memoryBanks = input.components(separatedBy: "  ").map {
    Int($0)!
  }
  var key = memoryBankString(input: memoryBanks)
  var history = [String: Int]()

  while history[key] == nil {
    history[key] = cycles
    redistribute(memoryBanks: &memoryBanks)
    key = memoryBankString(input: memoryBanks)
    cycles += 1
  }

  let savedCycles = history[key]!
  let loopSize = cycles-savedCycles

  return (cycles, loopSize)
}

func redistribute(memoryBanks: inout [Int]) {
  var indexToRedistribute = 0

  for index in 1...memoryBanks.count-1 {
    if memoryBanks[index] > memoryBanks[indexToRedistribute] {
      indexToRedistribute = index
    }
  }

  var values = memoryBanks[indexToRedistribute]
  memoryBanks[indexToRedistribute] = 0

  var index = indexToRedistribute
  while values > 0 {
    index += 1
    if index >= memoryBanks.count {
      index = 0
    }

    memoryBanks[index] += 1
    values -= 1
  }
}

func memoryBankString(input: [Int]) -> String {
  let formattedArray = input.map {
    String($0)
  }.joined(separator: ",")

  return formattedArray
}

class MemoryTests : XCTestCase {
  func testInput1() {
    let (cycles, loopSize) = cyclesToRedistributeBeforeInfiniteLoop(input: "0  2  7  0")
    XCTAssertEqual(cycles, 5)
    XCTAssertEqual(loopSize, 4)
  }

  func test() {
    let cycles = cyclesToRedistributeBeforeInfiniteLoop(input: "2  8  8  5  4  2  3  1  5  5  1  2  15  13  5  14")
    print("cycles: \(cycles)")
  }
}

MemoryTests.defaultTestSuite.run()
