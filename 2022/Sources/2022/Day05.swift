@available(macOS 13.0, *)
func day5Calculate(input: String) -> String {
    let inputs = input.split(separator: "\n\n").map { String($0) }
    var stacks = processStacks(input: inputs.first!)
    let instructions = parseInstructions(input: inputs.last!)
    process(instructions: instructions, stacks: &stacks)
    var topCrates = String()
    for stack in stacks {
        topCrates.append(stack.last!)
    }
    
    return topCrates
}

func processStacks(input: String) -> [[String]] {
    var stacks = [[String]]()
    
    let lines = input.split(separator: "\n")
    for index in lines.indices.dropLast() {
        let line = lines[index]
        let crateInput = line.split(separator: "]").map { String($0) }
        parseCrateInputLine(input: crateInput, stacks: &stacks)
    }
    
    for (index, stack) in stacks.enumerated() {
        stacks[index] = stack.reversed()
    }
    
    return stacks
}

func parseCrateInputLine(input: [String], stacks: inout [[String]]) {

    var previousStackIndex: Int?
    var usePreviousStackIndex = false
    for crate in input {
        var stackIndex = 0
        usePreviousStackIndex = false
        let index = crate.firstIndex(of: "[")!
        let numSpaces = crate.distance(from: crate.startIndex, to: index)
        if numSpaces == 1 {
            usePreviousStackIndex = true
            stackIndex = 1
        } else if numSpaces > 1 {
            stackIndex = numSpaces/4
            usePreviousStackIndex = true
            if previousStackIndex != nil {
                stackIndex += 1
            }
        }
        
        if let previousStackIndex = previousStackIndex, usePreviousStackIndex == true {
            stackIndex += previousStackIndex
        }
        previousStackIndex = stackIndex
        append(crate: String(crate.last!), stackIndex: stackIndex, stacks: &stacks)
    }
    
}

func append(crate: String, stackIndex: Int, stacks: inout [[String]]) {
    let numMissingStacks = (stackIndex + 1) - stacks.count
    if numMissingStacks > 0 {
        for _ in 0..<numMissingStacks {
            stacks.append([])
        }
    }
    
    var stack = stacks[stackIndex]
    stack.append(crate)
    stacks[stackIndex] = stack
}

func parseInstructions(input: String) -> [Instruction] {
    var instructions = [Instruction]()
    let moveAmountIndex = 1
    let fromStackIndex = 3
    let toStackIndex = 5
    
    let inputLines = input.split(separator: "\n")
    for inputLine in inputLines {
        let inputValue = inputLine.split(separator: " ")
        let move = Int(inputValue[moveAmountIndex])!
        let from = Int(inputValue[fromStackIndex])!
        let to = Int(inputValue[toStackIndex])!
        let instruction = Instruction(moveAmount: move, fromStack: from, toStack: to)
        instructions.append(instruction)
    }
    
    return instructions
}

func process(instructions: [Instruction], stacks: inout [[String]]) {
    for instruction in instructions {
        var fromStack = stacks[instruction.fromStack-1]
        var toStack = stacks[instruction.toStack-1]
        let amount = instruction.moveAmount
        for _ in 0..<amount {
            let removedCrate = fromStack.popLast()!
            toStack.append(removedCrate)
        }
        stacks[instruction.toStack-1] = toStack
        stacks[instruction.fromStack-1] = fromStack
    }
}

struct Instruction {
    let moveAmount: Int
    let fromStack: Int
    let toStack: Int
}

    
