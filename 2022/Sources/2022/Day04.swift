@available(macOS 13.0, *)
func day4Calculate(input: String) -> Int {
    let pairs = input.split(separator: "\n").map{ elfPairs(input: String($0)) }
//    let elfTotalCalories = elvesInput.map{ $0.reduce(0, +) }
//    let maxSum = elfTotalCalories.max()!
    var numberOverlaps = 0
    for pair in pairs {
        let range1 = pair.first!
        let range2 = pair.last!
        print("ranges: \(range1) \(range2)")
        if range1.clamped(to: range2) == range1 {
            numberOverlaps += 1
            print("contained")
        } else if range2.clamped(to: range1) == range2 {
            numberOverlaps += 1
            print("contained")
        }
    }
    
    return numberOverlaps
}

func day4bCalculate(input: String) -> Int {
    let pairs = input.split(separator: "\n").map { elfPairs(input: String($0)) }
    var numberOverlaps = 0
    for pair in pairs {
        let range1 = pair.first!
        let range2 = pair.last!
        if range1.overlaps(range2) {
            numberOverlaps += 1
        }
    }
    
    return numberOverlaps
}

func elfPairs(input: String) -> [ClosedRange<Int>] {
    let pairs = input.split(separator: ",").map{ elfRange(input: String($0)) }
    
    return pairs
}

func elfRange(input: String) -> ClosedRange<Int> {
    let rangeBounds = input.split(separator: "-")
    let lower = Int(rangeBounds.first!)!
    let upper = Int(rangeBounds.last!)!
    let range = lower...upper //Range<Int>(uncheckedBounds: (lower: lower, upper: upper))
    
    return range
}


