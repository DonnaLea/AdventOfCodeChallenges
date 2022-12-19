@available(macOS 13.0, *)
func day6Calculate(input: String, numUnique: Int) -> Int {
    return firstUniqueCharactersLastIndex(input: Array(input), numUnique: numUnique)
}

func firstUniqueCharactersLastIndex(input: [Character], numUnique: Int) -> Int {
    for (index, _) in input.enumerated() {
        let lastIndex = index + numUnique
        let subarray = input[index..<lastIndex]
        let set = Set(subarray)
        if set.count == numUnique {
            return lastIndex
        }
    }

    return -1
}


    
