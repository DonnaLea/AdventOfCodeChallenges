//: Advent of Code 2018: 07 - The Sum Of It's Parts (Part 2)
// https://adventofcode.com/2018/day/7

import XCTest

extension Character
{
  var unicodeScalarCodePoint: UInt32 {
    let characterString = String(self)
    let scalars = characterString.unicodeScalars
    
    return scalars[scalars.startIndex].value - 64
  }
}

extension String {
  var unicodeScalarCodePoint: UInt32 {
    return self.first?.unicodeScalarCodePoint ?? 0
  }
}

func calculate(input: String, numWorkers: Int, minTimePerStep: Int) -> Int {
  
  let instructions = process(input: input)
  
  var workers = [[String]]()
  for _ in 0..<numWorkers {
    let timeline = [String]()
    workers.append(timeline)
  }

  var stepsToCompleteForSteps = [String: [String]]()
  var completedSteps = Array<String>()
  var assignedSteps = Array<String>()
  
  for instruction in instructions {
    let step = instruction[1]
    var stepsToComplete = stepsToCompleteForSteps[step] ?? []
    stepsToComplete.append(instruction[0])
    stepsToCompleteForSteps[step] = stepsToComplete
  }
  
  var currentTime = 0
  while stepsToCompleteForSteps.count > 0 {
    var stepsAvailableUniq = Set<String>()
    for (step, steps) in stepsToCompleteForSteps {
      let filteredSteps = steps.filter { !completedSteps.contains($0) }
      if filteredSteps.count > 0 {
        for stepToTake in filteredSteps {
          if stepsToCompleteForSteps[stepToTake] == nil {
            stepsAvailableUniq.insert(stepToTake)
          }
        }
      } else {
        stepsAvailableUniq.insert(step)
      }
    }
    
    var stepsAvailable = stepsAvailableUniq.sorted()
    print("steps available: \(stepsAvailable)")
    for step in stepsAvailable {
      while !assignedSteps.contains(step) {
        if let workerIndex = availableWorkerAtTime(currentTime, workers: workers) {
          var worker = workers[workerIndex]
          print("workers before step: \(workers), currentTime: \(currentTime)")
          assignStepToWorker(step: step, worker: &worker, minTimePerStep: minTimePerStep, forTime: currentTime)
          workers[workerIndex] = worker
          print("workers after step: \(workers)")
          assignedSteps.append(step)
          stepsToCompleteForSteps.removeValue(forKey: step)
        } else {
          currentTime = nextStepCompletedAt(workers: workers, currentTime: currentTime)
          completeSteps(workers: workers, completedSteps: &completedSteps, currentTime: currentTime)
        }
      }
    }
    
    currentTime = nextStepCompletedAt(workers: workers, currentTime: currentTime)
    completeSteps(workers: workers, completedSteps: &completedSteps, currentTime: currentTime)
    
  }
  print(workers)
  busyWorkersUntilLastStepCompleted(workers: &workers)
  return nextTimeWorkerAvailable(workers: workers)
}

func completeSteps(workers: [[String]], completedSteps: inout [String], currentTime: Int) {
  for worker in workers {
    if worker.count <= currentTime {
      if let lastStep = worker.last, !completedSteps.contains(lastStep) {
        completedSteps.append(lastStep)
      }
    }
  }
}

func busyWorkersUntilLastStepCompleted(workers: inout [[String]]) {
  var lastStepTime = workers.first!.count
  
  for worker in workers {
    lastStepTime = max(lastStepTime, worker.count)
  }
  
  for (index, var worker) in workers.enumerated() {
    worker.append(contentsOf: repeatElement(".", count: lastStepTime - worker.count))
    workers[index] = worker
  }
}

func availableWorkerAtTime(_ time: Int, workers: [[String]]) -> Int? {
  for (index, worker) in workers.enumerated() {
    if worker.count <= time {
      return index
    }
  }
  
  return nil
}

func assignStepToWorker(step: String, worker: inout [String], minTimePerStep: Int, forTime: Int) {
  let time = timeForStep(step, minTimePerStep: minTimePerStep)
  if worker.count < forTime {
    worker.append(contentsOf: repeatElement(".", count: forTime-worker.count))
  }
  worker.append(contentsOf: repeatElement(step, count: time))
}

func nextStepCompletedAt(workers: [[String]], currentTime: Int) -> Int {
  var nextAvailableAt: Int?
  for worker in workers {
    if worker.count > currentTime {
      if let next = nextAvailableAt {
        nextAvailableAt = min(next, worker.count)
      } else {
        nextAvailableAt = worker.count
      }
    }
  }
  if let nextAvailableAt = nextAvailableAt {
    return nextAvailableAt
  } else {
    return currentTime
  }
}

func nextTimeWorkerAvailable(workers: [[String]]) -> Int {
  var nextTimeAvailable = workers.first!.count
  for worker in workers {
    nextTimeAvailable = min(nextTimeAvailable, worker.count)
  }
  
  return nextTimeAvailable
}

func timeForStep(_ step: String, minTimePerStep: Int) -> Int {
  return Int(step.unicodeScalarCodePoint) + minTimePerStep
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
    let input = """
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
"""
    let value = calculate(input: input, numWorkers: 2, minTimePerStep: 0)
    XCTAssertEqual(value, 15)
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

let value = calculate(input: input, numWorkers: 5, minTimePerStep: 60)
print(value)

// Correct Answer: 891
