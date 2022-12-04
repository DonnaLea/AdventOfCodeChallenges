@available(macOS 13.0, *)
func day1Calculate(input: String) -> Int {
    let elvesInput = input.split(separator: "\n\n").map{ elfCalories(input: String($0)) }
    let elfTotalCalories = elvesInput.map{ $0.reduce(0, +) }
    let maxSum = elfTotalCalories.max()!
    
    return maxSum
}

func elfCalories(input: String) -> [Int] {
    let values = input.split(separator: "\n").map { Int($0)! }
    
    return values
}

@available(macOS 13.0, *)
func day1bCalculate(input: String) -> Int {
    let elvesInput = input.split(separator: "\n\n").map{ elfCalories(input: String($0)) }
    var elfTotalCalories = elvesInput.map{ $0.reduce(0, +) }
    var top3TotalCaloriesSum = 0
    
    for _ in 0..<3 {
        let maxSum = elfTotalCalories.max()!
        let indexMaxSum = elfTotalCalories.firstIndex(of: maxSum)!
        print("maxSum: \(maxSum)")
        elfTotalCalories.remove(at: indexMaxSum)
        top3TotalCaloriesSum += maxSum
    }
    
    return top3TotalCaloriesSum
}

