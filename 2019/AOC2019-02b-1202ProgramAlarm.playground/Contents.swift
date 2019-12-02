//: Advent of Code 2019: 02 - Template (Part 1)
// https://adventofcode.com/2019/day/XX

import XCTest

func calculateNounVerb(for input: [Int], expectedOutput: Int) -> (Int, Int) {
  var values: [Int]
  var output: Int
    for noun in 0...99 {
      for verb in 0...99 {
        values = calculate(input: input, noun: noun, verb: verb)
        output = values[0]
        if output == expectedOutput {
          return (noun, verb)
        }
      }
    }
    values = input
    
//  } while values[0] != output
  
  return (0, 0)
}

func calculate(input: [Int], noun: Int, verb: Int) -> [Int] {
  
  var values = input
  values[1] = noun
  values[2] = verb
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
    let input = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,6,1,19,1,5,19,23,2,9,23,27,1,6,27,31,1,31,9,35,2,35,10,39,1,5,39,43,2,43,9,47,1,5,47,51,1,51,5,55,1,55,9,59,2,59,13,63,1,63,9,67,1,9,67,71,2,71,10,75,1,75,6,79,2,10,79,83,1,5,83,87,2,87,10,91,1,91,5,95,1,6,95,99,2,99,13,103,1,103,6,107,1,107,5,111,2,6,111,115,1,115,13,119,1,119,2,123,1,5,123,0,99,2,0,14,0]
    let value = calculate(input: input, noun: 12, verb: 2)
    XCTAssertEqual(value[0], 3101844)
  }
  
  func testInput2() {
    let input = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,6,1,19,1,5,19,23,2,9,23,27,1,6,27,31,1,31,9,35,2,35,10,39,1,5,39,43,2,43,9,47,1,5,47,51,1,51,5,55,1,55,9,59,2,59,13,63,1,63,9,67,1,9,67,71,2,71,10,75,1,75,6,79,2,10,79,83,1,5,83,87,2,87,10,91,1,91,5,95,1,6,95,99,2,99,13,103,1,103,6,107,1,107,5,111,2,6,111,115,1,115,13,119,1,119,2,123,1,5,123,0,99,2,0,14,0]
    let (noun, verb) = calculateNounVerb(for: input, expectedOutput: 3101844)
    XCTAssertEqual(noun, 12)
    XCTAssertEqual(verb, 2)
  }

}

SequenceTests.defaultTestSuite.run()

var input = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,6,1,19,1,5,19,23,2,9,23,27,1,6,27,31,1,31,9,35,2,35,10,39,1,5,39,43,2,43,9,47,1,5,47,51,1,51,5,55,1,55,9,59,2,59,13,63,1,63,9,67,1,9,67,71,2,71,10,75,1,75,6,79,2,10,79,83,1,5,83,87,2,87,10,91,1,91,5,95,1,6,95,99,2,99,13,103,1,103,6,107,1,107,5,111,2,6,111,115,1,115,13,119,1,119,2,123,1,5,123,0,99,2,0,14,0]
var output = 19690720

let (noun, verb) = calculateNounVerb(for: input, expectedOutput: output)
print("noun: \(noun), verb: \(verb)")
print("answer: \(100*noun + verb)")
// Correct Answer: 8478
