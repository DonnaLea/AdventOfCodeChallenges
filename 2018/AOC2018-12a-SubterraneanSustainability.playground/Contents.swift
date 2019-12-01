//: Advent of Code 2018: XX - Subterranean Sustainability (Part 1)
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
  
  print(plants.map{$0.containsPlant ? "#" : "."})

  for generation in 1...numberGenerations {
    print("generation: \(generation)")
    var willContainPlantNextGenerationArray = Array<Bool>()
    for (index, plant) in plants.enumerated() {
      var willContainPlantNextGeneration = false
      var leftPotsContainPlants = Array<Bool>()
      var rightPotsContainPlants = Array<Bool>()
      for i in index - 2..<index {
        leftPotsContainPlants.append(plants[safe: i]?.containsPlant ?? false)
      }
      for i in index+1...index+2 {
        rightPotsContainPlants.append(plants[safe: i]?.containsPlant ?? false)
      }
      for rule in rules {
        willContainPlantNextGeneration = willContainPlantNextGeneration || plant.evaluateRule(rule, leftPotsContainPlants: leftPotsContainPlants, rightPotsContainPlants: rightPotsContainPlants)
      }
      willContainPlantNextGenerationArray.append(willContainPlantNextGeneration)
    }
    for (index, var plant) in plants.enumerated() {
      plant.containsPlant = willContainPlantNextGenerationArray[index]
      plants[index] = plant
    }
    print(plants.map{$0.containsPlant ? "#" : "."})
    if plants.first!.containsPlant {
      plants.insert(Pot(containsPlant: false, number: plants.first!.number-1), at: 0)
    }
    if plants.last!.containsPlant {
      plants.append(Pot(containsPlant: false, number: plants.last!.number+1))
    }
  }
  
  
  let sum = plants.reduce(0) { result, pot in
    if pot.containsPlant {
      return result+pot.number
    } else {
      return result
    }
  }
  
  return sum
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

let value = calculate(input: input, initialState: initialState, numberGenerations: 20)
print(value)
// Correct Answer: 2823
