func day1bCalculate(input: String) -> Int {
    let values = input.split(separator: "\n").map{ Int($0)! }

    for (index, value) in values.enumerated() {
        for (index2, value2) in values[(index+1)...].enumerated() {
            for (_, value3) in values[(index2+1)...].enumerated() {
                let sum = value + value2 + value3
                if sum == 2020 {
                    return value * value2 * value3
                }
            }
        }
    }

    return 0
}