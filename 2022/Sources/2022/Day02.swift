
enum WinLoseDrawA: Int {
    case lose = 0
    case draw = 3
    case win = 6
}

enum RockPaperScissorsA: Int {
    case rock = 1
    case paper
    case scissors
    
    init(input: String) {
        switch input {
        case "A", "X":
            self = .rock
        case "B", "Y":
            self = .paper
        case "C", "Z":
            self = .scissors
        default:
            print("invalid input: \(input)")
            self = .rock
        }
    }
    
    func calculateScore(opponent: RockPaperScissorsA) -> Int {
        let outcome = calculateOutcome(opponent: opponent)
        let score = outcome.rawValue + self.rawValue
        
        return score
    }
    
    func calculateOutcome(opponent: RockPaperScissorsA) -> WinLoseDrawA {
        switch(self) {
        case .rock:
            switch(opponent) {
            case .rock:
                return .draw
            case .paper:
                return .lose
            case .scissors:
                return .win
            }
        case .paper:
            switch(opponent) {
            case .rock:
                return .win
            case .paper:
                return .draw
            case .scissors:
                return .lose
            }
        case .scissors:
            switch(opponent) {
            case .rock:
                return .lose
            case .paper:
                return .win
            case .scissors:
                return .draw
            }
        }
    }
}

@available(macOS 13.0, *)
func day2Calculate(input: String) -> Int {
    let rounds = input.split(separator: "\n")//.map{ elfCalories(input: String($0)) }
    var totalScore = 0
    for round in rounds {
        let inputs = round.split(separator: " ").map{ RockPaperScissorsA(input: String($0)) }
        let opponent = inputs[0]
        let you = inputs[1]
        let roundScore = you.calculateScore(opponent: opponent)
        totalScore += roundScore
    }
    
    return totalScore
}

//func calculateScore(opponent: RockPaperScissors, you: RockPaperScissors) -> Int {
//
//
//    return 0
//}
