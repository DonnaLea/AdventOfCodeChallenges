//: Advent of Code 2018: XX - Subterranean Sustainability (Part 2)
//: https://adventofcode.com/2018/day/12

import XCTest

extension Collection {
  
  /// Returns the element at the specified index if it is within bounds, otherwise nil.
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

struct Pot {
  var containsPlant: Bool
  var number: Int
  
  func evaluateRule(_ rule: Rule, leftPotsContainPlants: Array<Bool>, rightPotsContainPlants: Array<Bool>) -> Bool {
    var plants = Array<Bool>()
    
    
    plants.append(contentsOf: leftPotsContainPlants)
    plants.append(containsPlant)
    plants.append(contentsOf: rightPotsContainPlants)
    
    if number == 4 {
//      print(plants.map{$0 ? "#" : "."})
    }
    
    let evaluation = rule.potsContainingPlants == plants ? rule.willContainPlant : false
    if number == 4 {
//      print("evaluation: \(evaluation)")
    }
    return evaluation
//
//    if rule.potsContainingPlants == plants {
//      if number == 4 {
//        print(rule.willContainPlant)
//      }
//      return rule.willContainPlant
//    } else {
//      if number == 4 {
//        print(false)
//      }
//      return false
//    }
  }
}

struct Rule {
  var potsContainingPlants: Array<Bool>
  
  var willContainPlant: Bool
  
  init(input: String) {
    potsContainingPlants = []
    let plants = input[input.startIndex...input.index(input.startIndex, offsetBy: 4)]
    for character in plants {
      potsContainingPlants.append(character == "#")
    }
    
    willContainPlant = (input.last! == "#")
  }
  
  func evaluateWithPlants(_ plantsToCheck: Array<Bool>) -> Bool {
    let evaluation = potsContainingPlants == plantsToCheck ? willContainPlant : false

    return evaluation
  }
}

func printPlants(_ plants: Array<Pot>) {
  print(plants.reduce("") { result, pot in
    result+(pot.containsPlant ? "\(pot.number):#" : ".")
//    result+(pot.containsPlant ? "#" : ".")
  })
}

func sumOfPlants(_ plants: Array<Pot>) -> Int {
  let sum = plants.reduce(0) { result, pot in
    if pot.containsPlant {
      return result+pot.number
    } else {
      return result
    }
  }
  
  return sum
}

func calculate(input: String, initialState: String, numberGenerations: Int) -> Int {
  
  var plants = Array<Pot>()
  var rules = Array<Rule>()
  plants.append(Pot(containsPlant: false, number: -1))
  
  for (index, character) in initialState.enumerated() {
    let containsPlant = character == "#"
    let pot = Pot(containsPlant: containsPlant, number: index)
    plants.append(pot)
  }
  plants.append(Pot(containsPlant: false, number: initialState.count))
  
  for line in input.split(separator: "\n") {
    let rule = Rule(input: String(line.trimmingCharacters(in: .whitespaces)))
    if rule.willContainPlant {
      rules.append(rule)
    }
  }
  
//  printPlants(plants)

  var count = 0
  var lastGenerationPlants = Array<Bool>()
  for generation in 1...numberGenerations {
    if generation % 100 == 0 {
      count += 1
      print("count: \(count), generation: \(generation), time: \(Date())")
      printPlants(plants)
      print("sum: \(sumOfPlants(plants))")
    }
    var plantsToCheck = [false, false, false]
    plantsToCheck.append(contentsOf: plants[0..<2].map{$0.containsPlant})
    var willContainPlantNextGenerationArray = Array<Bool>()
    var firstPlantIndex = -1
    var lastPlantIndex = 0
    for (index, _) in plants.enumerated() {
      var willContainPlantNextGeneration = false
      plantsToCheck.removeFirst()
      plantsToCheck.append(plants[safe: index+2]?.containsPlant ?? false)

      for rule in rules {
        willContainPlantNextGeneration = willContainPlantNextGeneration || rule.evaluateWithPlants(plantsToCheck) //plant.evaluateRule(rule, leftPotsContainPlants: leftPotsContainPlants, rightPotsContainPlants: rightPotsContainPlants)
        if willContainPlantNextGeneration {
          if firstPlantIndex == -1 {
            firstPlantIndex = index
          }
          lastPlantIndex = index
          break
        }
      }
      willContainPlantNextGenerationArray.append(willContainPlantNextGeneration)
    }
    for (index, var plant) in plants.enumerated() {
      plant.containsPlant = willContainPlantNextGenerationArray[index]
      plants[index] = plant
    }
    // trim empty pots for processing
    plants = Array(plants[firstPlantIndex...lastPlantIndex])
    if plants.first!.containsPlant {
      plants.insert(Pot(containsPlant: false, number: plants.first!.number-1), at: 0)
    }
    if plants.last!.containsPlant {
      plants.append(Pot(containsPlant: false, number: plants.last!.number+1))
    }
    
    let thisGenerationPlants = plants.map{$0.containsPlant}
    if generation > 0 {
      if thisGenerationPlants == lastGenerationPlants {
        print("bingo: generation \(generation)")
        printPlants(plants)
        let remainingGenerations = numberGenerations - generation
        for (index, var plant) in plants.enumerated() {
          plant.number += remainingGenerations
          plants[index] = plant
        }
        break
      }
    }
    lastGenerationPlants = thisGenerationPlants
  }

  printPlants(plants)
  return sumOfPlants(plants)
}

class SequenceTests: XCTestCase {
  func testInput1() {
    let initialState = "#..#.#..##......###...###"
    let input = """
...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #
"""
    let value = calculate(input: input, initialState: initialState, numberGenerations: 20)
    XCTAssertEqual(value, 325)
  }

}

SequenceTests.defaultTestSuite.run()

let initialState = ".##..##..####..#.#.#.###....#...#..#.#.#..#...#....##.#.#.#.#.#..######.##....##.###....##..#.####.#"
let input = """
.#... => #
#.... => .
#.### => .
#.##. => .
#...# => .
...#. => .
.#..# => #
.#### => #
.###. => .
###.. => #
##### => .
....# => .
.#.## => #
####. => .
##.#. => #
#.#.# => #
..#.# => .
.#.#. => #
###.# => #
##.## => .
..#.. => .
..... => .
..### => #
#..## => #
##... => #
...## => #
##..# => .
.##.. => #
#..#. => .
#.#.. => #
.##.# => .
..##. => .
"""

let value = calculate(input: input, initialState: initialState, numberGenerations: 50000000000)
print(value)
// Correct Answer: 2900000001856
