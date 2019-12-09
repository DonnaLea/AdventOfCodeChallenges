//: Advent of Code 2019: 07a - Amplification Circuit (Part 1)
// https://adventofcode.com/2019/day/7

import XCTest

extension Array {
    func chopped() -> (Element, [Element])? {
        guard let x = self.first else { return nil }
        return (x, Array(self.suffix(from: 1)))
    }
}

extension Array {
    func interleaved(_ element: Element) -> [[Element]] {
        guard let (head, rest) = self.chopped() else { return [[element]] }
        return [[element] + self] + rest.interleaved(element).map { [head] + $0 }
    }
}

extension Array {
    var permutations: [[Element]] {
        guard let (head, rest) = self.chopped() else { return [[]] }
        return rest.permutations.flatMap { $0.interleaved(head) }
    }
}

func permutate(input: [Int]) -> [[Int]] {
  
  if input.count > 2 {
    let permutationLastDigits = permutate(input: Array(input[1...input.count-1]))
    return permutationLastDigits.map {
      var array = $0
      array.append(input.first!)
      return array
    }
  } else {
    return [[input.first!, input.last!], [input.last!, input.first!]]
  }
  
}

func compute(input: [Int], phaseSettings: [Int]) -> Int {
  var output = 0
  
  for i in 0...4 {
    let phaseSetting = phaseSettings[i]
    output = intCode(input: input, intInput: output, phaseSetting: phaseSetting)
  }
  
  return output
}


func calculate(input: [Int]) -> Int {
  var phaseSettings = [0, 1, 2, 3, 4]

  let permutations = phaseSettings.permutations
  var highestOutput = 0
  
  for permutation in permutations {
    let output = compute(input: input, phaseSettings: permutation)
    if output > highestOutput {
      highestOutput = output
    }
  }
  
  return highestOutput
}

func intCode(input: [Int], intInput: Int, phaseSetting: Int) -> Int {
  
  var values = input
  var instructionPointer = 0
  var usedPhaseSetting = false
  
  while instructionPointer < values.count {
    let opInstruction = values[instructionPointer]
    let opcode = opInstruction % 100
    var modes = opInstruction/100
    var modesArray = [Int]()
    while modes > 0 {
      let mode = modes % 10
      modes = modes / 10
      modesArray.append(mode)
    }
    
    if opcode == 99 {
      print("halt")
      break
    }
    
    if opcode == 1 || opcode == 2 || opcode == 7 || opcode == 8 {
      let firstNumberPosition = values[instructionPointer+1]
      let secondNumberPosition = values[instructionPointer+2]
      let savePosition = values[instructionPointer+3]
      let firstNumber: Int
      let secondNumber: Int
      var mode = modesArray.first ?? 0
      modesArray = Array(modesArray.dropFirst())
      firstNumber = (mode == 0) ? values[firstNumberPosition] : firstNumberPosition
      mode = modesArray.first ?? 0
      modesArray = Array(modesArray.dropFirst())
      secondNumber = (mode == 0) ? values[secondNumberPosition] : secondNumberPosition
      mode = modesArray.first ?? 0
      var result = 0
      if opcode == 1 {
        result = (firstNumber + secondNumber)
      } else if opcode == 2 {
        result = (firstNumber * secondNumber)
      } else if opcode == 7 {
        result = (firstNumber < secondNumber) ? 1 : 0
      } else if opcode == 8 {
        result = (firstNumber == secondNumber) ? 1 : 0
      }
      
      if mode == 0 {
        values[savePosition] = result
      }
      instructionPointer += 4
    } else if opcode == 3 || opcode == 4 {
      let addressPointer = values[instructionPointer+1]
      if opcode == 3 {
        let input = usedPhaseSetting ? intInput : phaseSetting
//        print("using input/phaseSetting: \(usedPhaseSetting) \(input)")
        usedPhaseSetting = true
        values[addressPointer] = input
      } else if opcode == 4 {
        let mode = modesArray.first ?? 0
        let output: Int
        if mode == 0 {
          output = values[addressPointer]
        } else {
          output = addressPointer
        }
        print("output: \(output)")
        return output
      }
      instructionPointer += 2
    } else if opcode == 5 || opcode == 6 {
      let firstNumberPosition = values[instructionPointer+1]
      let secondNumberPosition = values[instructionPointer+2]
      var mode = modesArray.first ?? 0
      let firstNumber = (mode == 0) ? values[firstNumberPosition] : firstNumberPosition
      modesArray = Array(modesArray.dropFirst())
      mode = modesArray.first ?? 0
      let secondNumber = (mode == 0) ? values[secondNumberPosition] : secondNumberPosition
      if opcode == 5 {
        if firstNumber != 0 {
          instructionPointer = secondNumber
        } else {
          instructionPointer += 3
        }
      } else if opcode == 6 {
        if firstNumber == 0 {
          instructionPointer = secondNumber
        } else {
          instructionPointer += 3
        }
      }
    }
    
//    print("values: \(values)")
//    print("instructionPointer: \(instructionPointer)")
    
  }
  
  return 0
}

class SequenceTests: XCTestCase {

  func testInput1() {
    let input = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
    let value = compute(input: input, phaseSettings: [4,3,2,1,0])
    XCTAssertEqual(value, 43210)
  }

  func testInput2() {
    let input = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
    let value = compute(input: input, phaseSettings: [0,1,2,3,4])
    XCTAssertEqual(value, 54321)
  }
  
  func testInput3() {
    let input = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
    let value = compute(input: input, phaseSettings: [1,0,4,3,2])
    XCTAssertEqual(value, 65210)
  }
  
  func testInput4() {
    let input = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
    let value = calculate(input: input)
    XCTAssertEqual(value, 43210)
  }

  func testInput5() {
    let input = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
    let value = calculate(input: input)
    XCTAssertEqual(value, 54321)
  }
  
  func testInput6() {
    let input = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
    let value = calculate(input: input)
    XCTAssertEqual(value, 65210)
  }
  
}

//SequenceTests.defaultTestSuite.run()

var input = [3,8,1001,8,10,8,105,1,0,0,21,30,51,76,101,118,199,280,361,442,99999,3,9,102,5,9,9,4,9,99,3,9,102,4,9,9,1001,9,3,9,102,2,9,9,101,2,9,9,4,9,99,3,9,1002,9,3,9,1001,9,4,9,102,5,9,9,101,3,9,9,1002,9,3,9,4,9,99,3,9,101,5,9,9,102,4,9,9,1001,9,3,9,1002,9,2,9,101,4,9,9,4,9,99,3,9,1002,9,2,9,1001,9,3,9,102,5,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,99]

let value = calculate(input: input)
print(value)
// Correct Answer: 9006327
