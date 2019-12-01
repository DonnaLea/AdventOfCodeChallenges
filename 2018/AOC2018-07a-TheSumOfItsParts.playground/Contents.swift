//: Advent of Code 2018: 07 - The Sum Of It's Parts (Part 1)
// https://adventofcode.com/2018/day/7

import XCTest

func calculate(input: String) -> String {
  
  let instructions = process(input: input)
  
//  print(instructions)
  
  var stepsToCompleteForSteps = [String: [String]]()
  var completedSteps = Array<String>()
  
  for instruction in instructions {
    let step = instruction[1]
    var stepsToComplete = stepsToCompleteForSteps[step] ?? []
    stepsToComplete.append(instruction[0])
    stepsToCompleteForSteps[step] = stepsToComplete
  }
  
//  print(stepsToCompleteForSteps)
  
  while stepsToCompleteForSteps.count > 0 {
    var stepsAvailable = Array<String>()
    for (step, steps) in stepsToCompleteForSteps {
      let filteredSteps = steps.filter { !completedSteps.contains($0) }
      if filteredSteps.count > 0 {
        for stepToTake in filteredSteps {
          if stepsToCompleteForSteps[stepToTake] == nil {
            stepsAvailable.append(stepToTake)
          }
        }
      } else {
        stepsAvailable.append(step)
      }
    }
    
    stepsAvailable.sort()
    if let step = stepsAvailable.first {
      completedSteps.append(step)
      stepsToCompleteForSteps.removeValue(forKey: step)
    }
  }
  
  return completedSteps.joined()
}

func process(input: String) -> [[String]] {
  let lines = input.split(separator: "\n")
  let instructions = lines.map { (line) -> [String] in
    let words = line.split(separator: " ")
    
    return [String(words[1]), String(words[7])]
  }
  
  return instructions
}

class SequenceTests: XCTestCase {
  func testInput1() {
    let value = calculate(input: """
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
""")
    print(value)
    XCTAssertEqual(value, "CABDFE")
  }
}

SequenceTests.defaultTestSuite.run()

let input = """
Step Y must be finished before step J can begin.
Step C must be finished before step L can begin.
Step L must be finished before step X can begin.
Step H must be finished before step R can begin.
Step R must be finished before step X can begin.
Step I must be finished before step B can begin.
Step N must be finished before step Q can begin.
Step F must be finished before step X can begin.
Step K must be finished before step G can begin.
Step G must be finished before step P can begin.
Step A must be finished before step S can begin.
Step O must be finished before step D can begin.
Step M must be finished before step W can begin.
Step Q must be finished before step J can begin.
Step X must be finished before step E can begin.
Step U must be finished before step V can begin.
Step Z must be finished before step D can begin.
Step P must be finished before step W can begin.
Step S must be finished before step J can begin.
Step J must be finished before step T can begin.
Step W must be finished before step T can begin.
Step V must be finished before step B can begin.
Step B must be finished before step T can begin.
Step D must be finished before step T can begin.
Step E must be finished before step T can begin.
Step I must be finished before step Z can begin.
Step X must be finished before step D can begin.
Step Q must be finished before step D can begin.
Step S must be finished before step T can begin.
Step R must be finished before step W can begin.
Step O must be finished before step V can begin.
Step C must be finished before step Q can begin.
Step C must be finished before step S can begin.
Step S must be finished before step E can begin.
Step A must be finished before step D can begin.
Step V must be finished before step T can begin.
Step K must be finished before step B can begin.
Step B must be finished before step D can begin.
Step V must be finished before step E can begin.
Step N must be finished before step M can begin.
Step Z must be finished before step T can begin.
Step L must be finished before step A can begin.
Step K must be finished before step Z can begin.
Step F must be finished before step J can begin.
Step M must be finished before step U can begin.
Step Z must be finished before step P can begin.
Step R must be finished before step E can begin.
Step M must be finished before step X can begin.
Step O must be finished before step E can begin.
Step K must be finished before step V can begin.
Step U must be finished before step D can begin.
Step K must be finished before step T can begin.
Step F must be finished before step W can begin.
Step I must be finished before step U can begin.
Step Z must be finished before step S can begin.
Step H must be finished before step D can begin.
Step O must be finished before step P can begin.
Step B must be finished before step E can begin.
Step X must be finished before step U can begin.
Step A must be finished before step J can begin.
Step Y must be finished before step V can begin.
Step U must be finished before step T can begin.
Step G must be finished before step B can begin.
Step U must be finished before step W can begin.
Step H must be finished before step W can begin.
Step G must be finished before step J can begin.
Step X must be finished before step Z can begin.
Step L must be finished before step R can begin.
Step Q must be finished before step X can begin.
Step I must be finished before step O can begin.
Step J must be finished before step E can begin.
Step N must be finished before step D can begin.
Step C must be finished before step B can begin.
Step I must be finished before step W can begin.
Step P must be finished before step J can begin.
Step D must be finished before step E can begin.
Step L must be finished before step J can begin.
Step R must be finished before step J can begin.
Step N must be finished before step A can begin.
Step F must be finished before step O can begin.
Step Y must be finished before step Q can begin.
Step L must be finished before step F can begin.
Step Q must be finished before step U can begin.
Step O must be finished before step T can begin.
Step Z must be finished before step E can begin.
Step Y must be finished before step K can begin.
Step G must be finished before step A can begin.
Step Q must be finished before step E can begin.
Step V must be finished before step D can begin.
Step F must be finished before step K can begin.
Step C must be finished before step E can begin.
Step F must be finished before step A can begin.
Step X must be finished before step B can begin.
Step G must be finished before step U can begin.
Step C must be finished before step H can begin.
Step Y must be finished before step W can begin.
Step R must be finished before step Z can begin.
Step W must be finished before step D can begin.
Step C must be finished before step T can begin.
Step H must be finished before step M can begin.
Step O must be finished before step Q can begin.
"""

let value = calculate(input: input)
print(value)

// Correct Answer: ???
