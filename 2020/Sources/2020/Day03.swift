struct Day03Map {
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

func day3Calculate(input: String) -> Int {
    let map = Day03Map(input: input)
    let rows = map.values.count

    var treesCount = 0

    var x = 0
    var y = 0
    let vx = 3
    let vy = 1

    while true {
        x += vx
        y += vy
        if y >= rows {
            break
        }
        if map.lookup(x: x, y: y) {
            treesCount += 1
        }
    }

    return treesCount
}