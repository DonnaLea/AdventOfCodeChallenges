//: Advent of Code 2018: 11 - Chronal Charge (Part 1)
//https://adventofcode.com/2018/day/11

import XCTest

struct Answer {
  var x: Int
  var y: Int
  var totalPower: Int
}

let square = 3

func calculate(input: Int) -> Answer {
  let serialNumber = input
  var grid = [[Int]]()
  
  for y in 1...300 {
    var row = [Int]()
    for x in 1...300 {
      let powerLevel = powerLevelFor(x: x, y: y, serialNumber: serialNumber)
      row.append(powerLevel)
    }
    grid.append(row)
  }
  
  var totalPowers = [Answer]()
  for y in 0..<grid.count-1-(square-1) {
    let row = grid[y]
    for x in 0..<row.count-1-(square-1) {
      let totalPower = totalPowerFor(x: x, y: y, grid: grid)
      totalPowers.append(totalPower)
    }
  }
  
  var highestPowerSquare = totalPowers.first!
  for totalPower in totalPowers {
    if totalPower.totalPower > highestPowerSquare.totalPower {
      highestPowerSquare = totalPower
    }
  }
  
  return highestPowerSquare
}

func totalPowerFor(x: Int, y: Int, grid: [[Int]]) -> Answer {
  var totalPower = 0
  
  for yi in 0..<square {
    for xi in 0..<square {
      totalPower += grid[y+yi][x+xi]
    }
  }
  
  return Answer(x: x+1, y: y+1, totalPower: totalPower)
}

func powerLevelFor(x: Int, y: Int, serialNumber: Int) -> Int {
  let rackID = x + 10
  var powerLevel = rackID * y
  powerLevel += serialNumber
  powerLevel *= rackID
  powerLevel = (abs(powerLevel)/100) % 10
  powerLevel -= 5
  
  return powerLevel
}

class SequenceTests: XCTestCase {
  func testInput1() {
    let value = powerLevelFor(x: 3, y: 5, serialNumber: 8)
    XCTAssertEqual(value, 4)
  }

  func testInput2() {
    let value = powerLevelFor(x: 122, y: 79, serialNumber: 57)
    XCTAssertEqual(value, -5)
  }

  func testInput3() {
    let value = powerLevelFor(x: 217, y: 196, serialNumber: 39)
    XCTAssertEqual(value, 0)
  }

  func testInput4() {
    let value = powerLevelFor(x: 101, y: 153, serialNumber: 71)
    XCTAssertEqual(value, 4)
  }

  func testInput5() {
    let input = 18
    let answer = calculate(input: input)
    XCTAssertEqual(answer.x, 33)
    XCTAssertEqual(answer.y, 45)
    XCTAssertEqual(answer.totalPower, 29)
  }

  func testInput6() {
    let input = 42
    let answer = calculate(input: input)
    XCTAssertEqual(answer.x, 21)
    XCTAssertEqual(answer.y, 61)
    XCTAssertEqual(answer.totalPower, 30)
  }
  
}

SequenceTests.defaultTestSuite.run()

let input = 8868
let value = calculate(input: input)
print(value)
// Correct Answer: 241,40
