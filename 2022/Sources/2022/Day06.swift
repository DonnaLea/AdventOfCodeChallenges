@available(macOS 13.0, *)
func day6Calculate(input: String) -> Int {
    return firstFourUniqueCharactersLastIndex(input: Array(input))
}

let packetMarkerSize = 4

func firstFourUniqueCharactersLastIndex(input: [Character]) -> Int {
    for (index, _) in input.enumerated() {
        let lastIndex = index + packetMarkerSize
        let subarray = input[index..<lastIndex]
        let set = Set(subarray)
        if set.count == 4 {
            return lastIndex
        }
    }

    return -1
}


    
