import Foundation

struct Day02bPolicyPassword {
    let password: String
    let policy: Day02bPolicy

    init(input: String) {
        let values = input.components(separatedBy: ": ")
        policy = Day02bPolicy(input: values.first!)
        password = values.last! 
    }

    func isValid() -> Bool {
        var count = 0
        if password[String.Index(encodedOffset: policy.positions.pos1-1)] == policy.character {
            count += 1
        }
        if password[String.Index(encodedOffset: policy.positions.pos2-1)] == policy.character {
            count += 1
        }

        return count == 1
    }
}

struct Day02bPolicy {
    let positions: Day02bOccurrencePositions
    let character: Character

    init(input: String) {
        let values = input.split(separator: " ")
        positions = Day02bOccurrencePositions(input: String(values.first!))
        character = values.last!.first!
    }
}

struct Day02bOccurrencePositions {
    let pos1: Int
    let pos2: Int

    init(input: String) {
        let values = input.split(separator: "-")
        pos1 = Int(values.first!)!
        pos2 = Int(values.last!)!
    }
}

func day2bCalculate(input: String) -> Int {
    let lines = input.split(separator: "\n")
    let policyPasswords = lines.map { Day02bPolicyPassword(input: String($0)) }

    var count = 0
    for pp in policyPasswords {
        if pp.isValid() {
            count+=1
        }
    }

    return count
}