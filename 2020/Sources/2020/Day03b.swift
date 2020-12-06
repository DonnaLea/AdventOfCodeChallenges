struct Day03bMap {
    let values: [[Bool]]

    init(input: String) {
        values = input.split(separator: "\n").map{ row in
            row.map { char in
                char == "#"
            }
        }
    }

    func lookup(x: Int, y: Int) -> Bool {
        let row = values[y]
        let rowLength = row.count
        let xx = x % rowLength
        return values[y][xx]
    }
}

func day3bMultiply(map: Day03bMap, velocities: [(Int, Int)]) -> Int {
    var value = 1
    for velocity in velocities {
        let trees = day3bCalculate(map: map, velocityX: velocity.0, velocityY: velocity.1)
        value *=  trees
    }

    return value
}

func day3bCalculate(map: Day03bMap, velocityX: Int, velocityY: Int) -> Int {
    let rows = map.values.count

    var treesCount = 0

    var x = 0
    var y = 0

    while true {
        x += velocityX
        y += velocityY
        if y >= rows {
            break
        }
        if map.lookup(x: x, y: y) {
            treesCount += 1
        }
    }

    return treesCount
}