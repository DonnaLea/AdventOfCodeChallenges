//: Advent of Code 2019: 05 - Sunny With A Chance of Asteroids (Part 1)
// https://adventofcode.com/2019/day/5

import XCTest

func calculate(input: [Int], intInput: Int) -> [Int] {
  
  var values = input
  var instructionPointer = 0
  
  while instructionPointer < values.count {
    let opInstruction = values[instructionPointer]
//    print("opInstruction: \(opInstruction)")
    let opcode = opInstruction % 100
    var modes = opInstruction/100
    var modesArray = [Int]()
    while modes > 0 {
      let mode = modes % 10
      modes = modes / 10
      modesArray.append(mode)
    }
    
//    print("modesArray: \(modesArray)")
    
    if opcode == 99 {
      print("halt")
      break
    }
    
    if opcode == 1 || opcode == 2 {
//      print("step 1")
      let firstNumberPosition = values[instructionPointer+1]
      let secondNumberPosition = values[instructionPointer+2]
//      print("firstNumberPosition: \(firstNumberPosition)")
//      print("secondNumberPosition: \(secondNumberPosition)")
      let savePosition = values[instructionPointer+3]
      let firstNumber: Int
      let secondNumber: Int
      var mode = modesArray.first ?? 0
//      print("mode: \(mode)")
      modesArray = Array(modesArray.dropFirst())
//      print("step 2")
      if mode == 0 { // position mode
        firstNumber = values[firstNumberPosition]
      } else {
        firstNumber = firstNumberPosition
      }
//      print("firstNumber: \(firstNumber)")
      mode = modesArray.first ?? 0
//      print("mode: \(mode)")
      modesArray = Array(modesArray.dropFirst())
//      print("step 3")
      if mode == 0 {
        secondNumber = values[secondNumberPosition]
      } else {
        secondNumber = secondNumberPosition
      }
//      print("secondNumber: \(secondNumber)")
      mode = modesArray.first ?? 0
//      print("mode: \(mode)")
//      print("step 4")
      let result = (opcode == 1) ? (firstNumber + secondNumber) : (firstNumber * secondNumber)
//      print("result: \(result)")
      if mode == 0 {
//        print("saving result to position: \(savePosition)")
        values[savePosition] = result
      } else {
        print("third parameter: \(result)")
      }
      instructionPointer += 4
//      print("step 5")
    } else {
      let addressPointer = values[instructionPointer+1]
      if opcode == 3 {
        values[addressPointer] = intInput
      } else if opcode == 4 {
        let output = values[addressPointer]
//        print("instructionPointer: \(instructionPointer)")
//        print("addressPointer: \(addressPointer)")
        print("output: \(output)")
      }
      instructionPointer += 2
    }
    
  }
  
  return values
}

class SequenceTests: XCTestCase {
  func testInput1() {
    let input = [1002,4,3,4,33]
    let value = calculate(input: input, intInput: 1)
    XCTAssertEqual(value, [1002,4,3,4,99])
  }

}

//SequenceTests.defaultTestSuite.run()

var input = [3,225,1,225,6,6,1100,1,238,225,104,0,1101,91,67,225,1102,67,36,225,1102,21,90,225,2,13,48,224,101,-819,224,224,4,224,1002,223,8,223,101,7,224,224,1,223,224,223,1101,62,9,225,1,139,22,224,101,-166,224,224,4,224,1002,223,8,223,101,3,224,224,1,223,224,223,102,41,195,224,101,-2870,224,224,4,224,1002,223,8,223,101,1,224,224,1,224,223,223,1101,46,60,224,101,-106,224,224,4,224,1002,223,8,223,1001,224,2,224,1,224,223,223,1001,191,32,224,101,-87,224,224,4,224,102,8,223,223,1001,224,1,224,1,223,224,223,1101,76,90,225,1101,15,58,225,1102,45,42,224,101,-1890,224,224,4,224,1002,223,8,223,1001,224,5,224,1,224,223,223,101,62,143,224,101,-77,224,224,4,224,1002,223,8,223,1001,224,4,224,1,224,223,223,1101,55,54,225,1102,70,58,225,1002,17,80,224,101,-5360,224,224,4,224,102,8,223,223,1001,224,3,224,1,223,224,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1008,677,677,224,102,2,223,223,1005,224,329,1001,223,1,223,1108,677,226,224,1002,223,2,223,1006,224,344,101,1,223,223,107,677,226,224,1002,223,2,223,1006,224,359,101,1,223,223,108,677,677,224,1002,223,2,223,1006,224,374,1001,223,1,223,108,226,677,224,1002,223,2,223,1006,224,389,101,1,223,223,7,226,677,224,102,2,223,223,1006,224,404,1001,223,1,223,1108,677,677,224,1002,223,2,223,1005,224,419,101,1,223,223,1008,226,677,224,102,2,223,223,1006,224,434,101,1,223,223,107,226,226,224,102,2,223,223,1005,224,449,1001,223,1,223,1007,677,677,224,1002,223,2,223,1006,224,464,1001,223,1,223,1007,226,226,224,1002,223,2,223,1005,224,479,101,1,223,223,1008,226,226,224,102,2,223,223,1006,224,494,1001,223,1,223,8,226,226,224,102,2,223,223,1006,224,509,101,1,223,223,1107,677,677,224,102,2,223,223,1005,224,524,1001,223,1,223,1108,226,677,224,1002,223,2,223,1006,224,539,101,1,223,223,1107,677,226,224,1002,223,2,223,1006,224,554,101,1,223,223,1007,677,226,224,1002,223,2,223,1005,224,569,101,1,223,223,7,677,226,224,1002,223,2,223,1006,224,584,101,1,223,223,107,677,677,224,1002,223,2,223,1005,224,599,1001,223,1,223,8,226,677,224,1002,223,2,223,1005,224,614,101,1,223,223,7,677,677,224,1002,223,2,223,1006,224,629,1001,223,1,223,1107,226,677,224,1002,223,2,223,1006,224,644,101,1,223,223,108,226,226,224,102,2,223,223,1005,224,659,1001,223,1,223,8,677,226,224,1002,223,2,223,1005,224,674,101,1,223,223,4,223,99,226]

let value = calculate(input: input, intInput: 1)
print(value)
// Correct Answer: 15508323
