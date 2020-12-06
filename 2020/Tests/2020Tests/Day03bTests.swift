import XCTest
import Foundation

@testable import _020

final class Day03bTests: XCTestCase {

    func prepMap() -> Day03bMap {
        let input = """
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
"""
        return Day03bMap(input: input)
    }

    func testInput0() {
        let map = prepMap()
        let value = day3bCalculate(map: map,  velocityX: 1, velocityY: 1)
        XCTAssertEqual(value, 2)
    }
    
    func testInput1() {
        let map = prepMap()
        let value = day3bCalculate(map: map,  velocityX: 3, velocityY: 1)
        XCTAssertEqual(value, 7)
    }

    func testInput2() {
        let map = prepMap()
        let value = day3bCalculate(map: map,  velocityX: 5, velocityY: 1)
        XCTAssertEqual(value, 3)
    }

    func testInput3() {
        let map = prepMap()
        let value = day3bCalculate(map: map,  velocityX: 7, velocityY: 1)
        XCTAssertEqual(value, 4)
    }

    func testInput4() {
        let map = prepMap()
        let value = day3bCalculate(map: map,  velocityX: 1, velocityY: 2)
        XCTAssertEqual(value, 2)
    }

    func testInputMultiply() {
        let map = prepMap()
        let value = day3bMultiply(map: map, velocities: [(1,1),(3,1),(5,1),(7,1),(1,2)])
        XCTAssertEqual(value, 336)
    }
 
    func testDonnaInput() {
        if let filepath = Bundle.module.path(forResource: "Day03InputDonna", ofType: "txt") {
            let input = try! String(contentsOfFile: filepath)
            let map = Day03bMap(input: input)
            let value = day3bMultiply(map: map, velocities: [(1,1),(3,1),(5,1),(7,1),(1,2)])
            XCTAssertEqual(value, 2122848000)
        }
    }

    func testLeighInput() {
        if let filepath = Bundle.module.path(forResource: "Day03InputLeigh", ofType: "txt") {
            let input = try! String(contentsOfFile: filepath)
            let map = Day03bMap(input: input)
            let value = day3bMultiply(map: map, velocities: [(1,1),(3,1),(5,1),(7,1),(1,2)])
            XCTAssertEqual(value, 3952146825)
        }
    }
}
