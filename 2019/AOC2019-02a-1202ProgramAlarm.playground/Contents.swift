//: Advent of Code 2019: 02 - Template (Part 2)
// https://adventofcode.com/2019/day/2

import XCTest

func calculate(input: [Int]) -> [Int] {
  
  var values = input
  let opcodePositions = stride(from: 0, to: values.count, by: 4)
  
  for opcodePosition in opcodePositions {
    let opcode = values[opcodePosition]
    
    if opcode == 99 {
      break
    }
    
    let firstNumberPosition = values[opcodePosition+1]
    let secondNumberPosition = values[opcodePosition+2]
    let savePosition = values[opcodePosition+3]
    let firstNumber = values[firstNumberPosition]
    let secondNumber = values[secondNumberPosition]
    let result = (opcode == 1) ? (firstNumber + secondNumber) : (firstNumber * secondNumber)
    values[savePosition] = result
  }
  
  return values
}

class SequenceTests: XCTestCase {
  func testInput1() {
    let input = [1,9,10,3,2,3,11,0,99,30,40,50]
    let value = calculate(input: input)
    XCTAssertEqual(value, [3500,9,10,70,2,3,11,0,99,30,40,50])
  }
  
  func testInput2() {
    let input = [1,0,0,0,99]
    let value = calculate(input: input)
    XCTAssertEqual(value, [2,0,0,0,99])
  }
  
  func testInput3() {
    let input = [2,3,0,3,99]
    let value = calculate(input: input)
    XCTAssertEqual(value, [2,3,0,6,99])
  }
  
  func testInput4() {
    let input = [2,4,4,5,99,0]
    let value = calculate(input: input)
    XCTAssertEqual(value, [2,4,4,5,99,9801])
  }
  
  func testInput5() {
    let input = [1,1,1,4,99,5,6,0,99]
    let value = calculate(input: input)
    XCTAssertEqual(value, [30,1,1,4,2,5,6,0,99])
  }

}

SequenceTests.defaultTestSuite.run()

var input = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,6,1,19,1,5,19,23,2,9,23,27,1,6,27,31,1,31,9,35,2,35,10,39,1,5,39,43,2,43,9,47,1,5,47,51,1,51,5,55,1,55,9,59,2,59,13,63,1,63,9,67,1,9,67,71,2,71,10,75,1,75,6,79,2,10,79,83,1,5,83,87,2,87,10,91,1,91,5,95,1,6,95,99,2,99,13,103,1,103,6,107,1,107,5,111,2,6,111,115,1,115,13,119,1,119,2,123,1,5,123,0,99,2,0,14,0]

input[1] = 12
input[2] = 2
let value = calculate(input: input)
print(value)
// Correct Answer: 3101844
