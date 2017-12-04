//: Advent of Code 2017: 3 - Spiral Memory (Part 1)
//: https://adventofcode.com/2017/day/3

import UIKit
import XCTest

enum Direction {
  case right, up, left, down
}

func distanceToSquare1(from: Int) -> Int {
  var horizontalDistance = 0 // Track offset from square one horizontally.
  var verticalDistance = 0 // Track offset from square one vertically.
  var squaresPerDirection = 1 // Track the distance to travel in a direction.
  var squaresTravelled = 1
  var currentDirection = Direction.down

  while squaresTravelled < from {
    // Move horizontally.
    currentDirection = nextDirection(direction: currentDirection)
    squaresTravelled += squaresPerDirection
    horizontalDistance += squaresPerDirection * (currentDirection == .right ? 1 : -1)

    // Check if moving horizontally has completed the distance we need to travel.
    if squaresTravelled >= from {
      break
    }

    // Move vertically.
    currentDirection = nextDirection(direction: currentDirection)
    squaresTravelled += squaresPerDirection
    verticalDistance += squaresPerDirection * (currentDirection == .up ? 1 : -1)

    // Increment the distance we are travelling around the spiral.
    squaresPerDirection += 1
  }

  // Adjust for the overshoot.
  let overshoot = (squaresTravelled - from)
  squaresTravelled -= overshoot
  switch currentDirection {
  case .right:
    horizontalDistance -= overshoot
  case .left:
    horizontalDistance += overshoot
  case .up:
    verticalDistance -= overshoot
  case .down:
    verticalDistance += overshoot
  }

  let distance = abs(horizontalDistance) + abs(verticalDistance)
  return distance
}

distanceToSquare1(from: 361527)

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

class SpiralMemoryTests : XCTestCase {

  func testInput1() {
    let distance = distanceToSquare1(from: 1)
    XCTAssertEqual(distance, 0)
  }

  func testInput2() {
    let distance = distanceToSquare1(from: 12)
    XCTAssertEqual(distance, 3)
  }

  func testInput3() {
    let distance = distanceToSquare1(from: 23)
    XCTAssertEqual(distance, 2)
  }

  func testInput4() {
    let distance = distanceToSquare1(from: 1024)
    XCTAssertEqual(distance, 31)
  }

  func testInput5() {
    let distance = distanceToSquare1(from: 13)
    XCTAssertEqual(distance, 4)
  }
}

SpiralMemoryTests.defaultTestSuite.run()

