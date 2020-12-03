import Foundation

struct PolicyPassword {
    let password: String
    let policy: Policy

    init(input: String) {
        let values = input.components(separatedBy: ": ")
        policy = Policy(input: values.first!)
        password = values.last! 
    }

    func isValid() -> Bool {
        var count = 0
        for c in password {
            if c == policy.character {
                count+=1
            }
        }
        return count >= policy.range.min && count <= policy.range.max
    }
}

struct Policy {
    let range: OccurrenceRange
    let character: Character

    init(input: String) {
        let values = input.split(separator: " ")
        range = OccurrenceRange(input: String(values.first!))
        character = values.last!.first!
    }
}

struct OccurrenceRange {
    let min: Int
    let max: Int

    init(input: String) {
        let values = input.split(separator: "-")
        min = Int(values.first!)!
        max = Int(values.last!)!
    }
}

func day2Calculate(input: String) -> Int {
    let lines = input.split(separator: "\n")
    let policyPasswords = lines.map { PolicyPassword(input: String($0)) }

    var count = 0
    for pp in policyPasswords {
        if pp.isValid() {
            count+=1
        }
    }

    return count
}