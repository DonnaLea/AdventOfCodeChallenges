enum RucksackItem: String {
    
    private static let asciiA = Character("A").asciiValue!
    private static let asciiZ = Character("Z").asciiValue!
    private static let asciia = Character("a").asciiValue!
    private static let asciiz = Character("z").asciiValue!
    private static let asciiUppercaseOffset = RucksackItem.asciiA - 1 - 26
    private static let asciiLowervaseOffset = RucksackItem.asciia - 1
    
    case a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z
    case A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z
    
    func priority() -> Int {
        if let ascii = Character(self.rawValue).asciiValue {
            if ascii >= RucksackItem.asciiA && ascii <= RucksackItem.asciiZ {
                return Int(ascii - RucksackItem.asciiUppercaseOffset)
            } else if ascii >= RucksackItem.asciia && ascii <= RucksackItem.asciiz {
                return Int(ascii - RucksackItem.asciiLowervaseOffset)
            } else {
                print("unexpected ascii: \(ascii)")
                return 0
            }
        } else {
            print("unexpected case: \(self)")
            return 0
        }
    }
}

@available(macOS 13.0, *)
func day3Calculate(input: String) -> Int {
    let rucksacks = input.split(separator: "\n")
    var prioritySum = 0
    for rucksack in rucksacks {
        let sharedItem = sharedItem(input: String(rucksack))
        print("sharedItem: \(sharedItem), priority: \(sharedItem.priority())")
        prioritySum += sharedItem.priority()
    }
    
    return prioritySum
}

func sharedItem(input: String) -> RucksackItem {
    let length = input.count
    let halfLength = length/2
    let compartment1 = Set(input.prefix(halfLength))
    let compartment2 = Set(input.suffix(halfLength))
    print("compartment1: \(compartment1)")
    print("compartment2: \(compartment2)")
    let common = compartment1.intersection(compartment2)
    
    return RucksackItem(rawValue: String(common.first!))!
}

func day3bCalculate(input: String) -> Int {
    let rucksacks = input.split(separator: "\n")
    var prioritySum = 0
    let groupSize = 3
    for index in stride(from: 0, to: rucksacks.count, by: groupSize) {
        let groupRucksacks = rucksacks[index...(index+groupSize-1)]
        let sharedItem = sharedItem(rucksacks: groupRucksacks.map{ String($0) })
        prioritySum += sharedItem.priority()
    }
    
    return prioritySum
}

func sharedItem(rucksacks: [String]) -> RucksackItem {
    var common = Set(rucksacks.first!)
    for index in rucksacks.indices.dropFirst() {
        let rucksack = rucksacks[index]
        let rucksackSet = Set(rucksack)
        common = common.intersection(rucksackSet)
    }
    print("common: \(common)")
    
    return RucksackItem(rawValue: String(common.first!))!
}
