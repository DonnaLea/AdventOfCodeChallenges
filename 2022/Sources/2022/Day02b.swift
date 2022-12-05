
enum WinLoseDraw: Int {
    case lose = 0
    case draw = 3
    case win = 6
    
    init(input: String) {
        switch input {
        case "X":
            self = .lose
        case "Y":
            self = .draw
        case "Z":
            self = .win
        default:
            print("invalid input: \(input)")
            self = .draw
        }
    }
}

enum RockPaperScissors: Int {
    case rock = 1
    case paper
    case scissors
    
    init(input: String) {
        switch input {
        case "A":
            self = .rock
        case "B":
            self = .paper
        case "C":
            self = .scissors
        default:
            print("invalid input: \(input)")
            self = .rock
        }
    }
    
    func calculateScore(opponent: RockPaperScissors) -> Int {
        let outcome = calculateOutcome(opponent: opponent)
        let score = outcome.rawValue + self.rawValue
        
        return score
    }
    
    static func calculatePlay(opponent: RockPaperScissors, neededOutcome: WinLoseDraw) -> RockPaperScissors {
        switch(opponent) {
        case .rock:
            switch(neededOutcome) {
            case .win:
                return .paper
            case .draw:
                return opponent
            case .lose:
                return scissors
            }
            
        case .paper:
            switch(neededOutcome) {
            case .win:
                return .scissors
            case .draw:
                return opponent
            case .lose:
                return .rock
            }
            
        case .scissors:
            switch(neededOutcome) {
            case .win:
                return .rock
            case .draw:
                return opponent
            case .lose:
                return .paper
            }
        }
    }
    
    func calculateOutcome(opponent: RockPaperScissors) -> WinLoseDraw {
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
func day2bCalculate(input: String) -> Int {
    let rounds = input.split(separator: "\n")//.map{ elfCalories(input: String($0)) }
    var totalScore = 0
    for round in rounds {
        let inputs = round.split(separator: " ") //.map{ RockPaperScissors(input: String($0)) }
        let opponent = RockPaperScissors(input: String(inputs[0]))
        let expectedOutcome = WinLoseDraw(input: String(inputs[1]))
        let you = RockPaperScissors.calculatePlay(opponent: opponent, neededOutcome: expectedOutcome)
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

