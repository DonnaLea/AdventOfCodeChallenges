//: Advent of Code 2018: 09 - Marble Mania (Part 1)
//: https://adventofcode.com/2018/day/9

import XCTest

struct Circle {
  var marbles: [Int] = [0]
  var current = 0
  
  func indexClockwise(by: Int = 1) -> Int {
    var index = current
    for _ in 0..<by {
      index += 1
      if index > marbles.count - 1 {
        index = 0
      }
    }
    
    if index == 0 {
      index = marbles.endIndex
    }
    
    return index
  }
  
  func indexCounterClockwise(by: Int = 1) -> Int {
    var index = current
    for _ in 0..<by {
      index -= 1
      if index < 0 {
        index = marbles.count - 1
      }
    }
    
    return index
  }
  
}

func calculateTopScore(numPlayers: Int, highestValueMarble: Int) -> Int {
  
  var circle = Circle()
  var scores = Array(repeating: 0, count: numPlayers+1) // add 1 because we're a 1 based player number
  var currentPlayer = 0
  
  for marble in 1...highestValueMarble {
    currentPlayer = increment(currentPlayer: currentPlayer, numPlayers: numPlayers)
    
    play(marble: marble, currentPlayer: currentPlayer, circle: &circle, scores: &scores)
//    print(circle)
  }
  
  var topScore: Int = -1
  var topScorePlayer: Int = -1
  
  for (index, score) in scores.enumerated() {
    if score > topScore {
      topScore = score
      topScorePlayer = index
    }
  }
  
  return topScore
}

func play(marble: Int, currentPlayer: Int, circle: inout Circle, scores: inout [Int]) {
  if marble % 23 == 0 {
    var score = scores[currentPlayer] + marble
    var indexToRemove = circle.indexCounterClockwise(by: 7)
    let marbleToScore = circle.marbles.remove(at: indexToRemove)
    score += marbleToScore
    scores[currentPlayer] = score
    if indexToRemove > circle.marbles.count - 1 {
      indexToRemove = 0
    }
    circle.current = indexToRemove
  } else {
    let insertAt = circle.indexClockwise(by: 2)
    circle.marbles.insert(marble, at: insertAt)
    circle.current = insertAt
  }
  
  if marble % 100000 == 0 {
    print("marble: \(marble), \(Date())")
  }
}

func increment(currentPlayer: Int, numPlayers: Int) -> Int {
  var nextPlayer = currentPlayer + 1
  if nextPlayer > numPlayers {
    nextPlayer = 1
  }
  
  return nextPlayer
}

//let input = "MyInputString"

let numPlayers = 441
let highestValueMarble = 71032
let score = calculateTopScore(numPlayers: numPlayers, highestValueMarble: highestValueMarble)
print(score)
// Incorrect Answer: 160901
// Correct Answer: 393229

class SequenceTests: XCTestCase {
  func testInput1() {
    let score = calculateTopScore(numPlayers: 10, highestValueMarble: 25)
    XCTAssertEqual(score, 32)
  }

  func testInput2() {
    let score = calculateTopScore(numPlayers: 10, highestValueMarble: 1618)
    XCTAssertEqual(score, 8317)
  }

  func testInput3() {
    let score = calculateTopScore(numPlayers: 13, highestValueMarble: 7999)
    XCTAssertEqual(score, 146373)
  }

  func testInput4() {
    let score = calculateTopScore(numPlayers: 17, highestValueMarble: 1104)
    XCTAssertEqual(score, 2764)
  }

  func testInput5() {
    let score = calculateTopScore(numPlayers: 21, highestValueMarble: 6111)
    XCTAssertEqual(score, 54718)
  }
  
  func testInput6() {
    let score = calculateTopScore(numPlayers: 30, highestValueMarble: 5807)
    XCTAssertEqual(score, 37305)
  }
  
  /*
  func testInputEmpty() {
    let value = calculate(input: "")
    XCTAssertEqual(value, 0)
  }
*/
}

SequenceTests.defaultTestSuite.run()
