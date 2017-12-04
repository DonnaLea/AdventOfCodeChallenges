//: Advent of Code 2017: 3 - Spiral Memory (Part 2)
//: https://adventofcode.com/2017/day/3

import UIKit
import XCTest

enum Direction {
  case right, up, left, down
}

func firstStressValueLargerThan(maxStressValue: Int) -> Int {
  var horizontalDistance = 0 // Track offset from square one horizontally.
  var verticalDistance = 0 // Track offset from square one vertically.
  var squaresPerDirection = 1 // Track the distance to travel in a direction.
  var squaresTravelled = 1
  var currentDirection = Direction.down
  var stressTestValues = [String : Int]()

  var currentMaxStressValue = stressTestValue(horizontal: horizontalDistance, vertical: verticalDistance, stressTestValues: &stressTestValues)

  outer: while currentMaxStressValue <= maxStressValue {
    // Move horizontally.
    currentDirection = nextDirection(direction: currentDirection)

    for _ in 1...squaresPerDirection {
      squaresTravelled += 1
      horizontalDistance += (currentDirection == .right ? 1 : -1)
      currentMaxStressValue = stressTestValue(horizontal: horizontalDistance, vertical: verticalDistance, stressTestValues: &stressTestValues)
      if currentMaxStressValue > maxStressValue {
        break outer
      }
    }

    // Move vertically.
    currentDirection = nextDirection(direction: currentDirection)
    for _ in 1...squaresPerDirection {
      squaresTravelled += 1
      verticalDistance += (currentDirection == .up ? 1 : -1)
      currentMaxStressValue = stressTestValue(horizontal: horizontalDistance, vertical: verticalDistance, stressTestValues: &stressTestValues)
      if currentMaxStressValue > maxStressValue {
        break outer
      }
    }

    // Increment the distance we are travelling around the spiral.
    squaresPerDirection += 1
  }

  let key = generateKey(horizontal: horizontalDistance, vertical: verticalDistance)
  let value = stressTestValues[key] ?? 1
  return value
}

firstStressValueLargerThan(maxStressValue: 361527)

func nextDirection(direction: Direction) -> Direction {
  let nextDirection: Direction

  switch direction {
  case .right:
    nextDirection = .up
  case .up:
    nextDirection = .left
  case .left:
    nextDirection = .down
  case .down:
    nextDirection = .right
  }

  return nextDirection
}

func stressTestValue(horizontal: Int, vertical: Int, stressTestValues: inout [String : Int]) -> Int {
  var stressTestValue = 0

  for x in -1...1 {
    for y in -1...1 {
      if x == 0 && y == 0 {
        continue
      }
      let key = generateKey(horizontal: horizontal+x, vertical: vertical+y)
      if let neighbourValue = stressTestValues[key] {
        stressTestValue += neighbourValue
      }
    }
  }

  if stressTestValue == 0 {
    stressTestValue = 1
  }
  let key = generateKey(horizontal: horizontal, vertical: vertical)
  stressTestValues[key] = stressTestValue

  return stressTestValue
}

func generateKey(horizontal: Int, vertical: Int) -> String {
  return "h\(horizontal)v\(vertical)"
}

class SpiralMemoryTests : XCTestCase {
  func testStressValueInput1() {
    let value = firstStressValueLargerThan(maxStressValue: 1)
    XCTAssertEqual(value, 2)
  }

  func testStressValueInput2() {
    let value = firstStressValueLargerThan(maxStressValue: 2)
    XCTAssertEqual(value, 4)
  }

  func testStressValueInput3() {
    let value = firstStressValueLargerThan(maxStressValue: 3)
    XCTAssertEqual(value, 4)
  }

  func testStressValueInput4() {
    let value = firstStressValueLargerThan(maxStressValue: 4)
    XCTAssertEqual(value, 5)
  }

  func testStressValueInput5() {
    let value = firstStressValueLargerThan(maxStressValue: 5)
    XCTAssertEqual(value, 10)
  }

}

SpiralMemoryTests.defaultTestSuite.run()

