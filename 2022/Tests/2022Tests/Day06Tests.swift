import XCTest
@testable import _022

@available(macOS 13.0, *)
class Day06Tests: XCTestCase {
    
    let packetMarkerSize = 4
    let startOfMessageMarkerSize = 14
    
    func testInputDay6() {
        var input = day6TestInput1
        var value = day6Calculate(input: input, numUnique: packetMarkerSize)
        XCTAssertEqual(value, 7)
        input = day6TestInput2
        value = day6Calculate(input: input, numUnique: packetMarkerSize)
        XCTAssertEqual(value, 5)
        input = day6TestInput3
        value = day6Calculate(input: input, numUnique: packetMarkerSize)
        XCTAssertEqual(value, 6)
        input = day6TestInput4
        value = day6Calculate(input: input, numUnique: packetMarkerSize)
        XCTAssertEqual(value, 10)
        input = day6TestInput5
        value = day6Calculate(input: input, numUnique: packetMarkerSize)
        XCTAssertEqual(value, 11)
    }
    
    func testInputDay6b() {
        var input = day6TestInput1
        var value = day6Calculate(input: input, numUnique: startOfMessageMarkerSize)
        XCTAssertEqual(value, 19)
        input = day6TestInput2
        value = day6Calculate(input: input, numUnique: startOfMessageMarkerSize)
        XCTAssertEqual(value, 23)
        input = day6TestInput3
        value = day6Calculate(input: input, numUnique: startOfMessageMarkerSize)
        XCTAssertEqual(value, 23)
        input = day6TestInput4
        value = day6Calculate(input: input, numUnique: startOfMessageMarkerSize)
        XCTAssertEqual(value, 29)
        input = day6TestInput5
        value = day6Calculate(input: input, numUnique: startOfMessageMarkerSize)
        XCTAssertEqual(value, 26)
    }
    
    func testDonnaInput() {
        if let filepath = Bundle.module.path(forResource: "Resources/Day06Input", ofType: "txt") {
            let input = try! String(contentsOfFile: filepath)
            let values = day6Calculate(input: input, numUnique: packetMarkerSize)
            XCTAssertEqual(values, 1848)
        }
    }
    
    func testDonnaInputB() {
        if let filepath = Bundle.module.path(forResource: "Resources/Day06Input", ofType: "txt") {
            let input = try! String(contentsOfFile: filepath)
            let values = day6Calculate(input: input, numUnique: startOfMessageMarkerSize)
            XCTAssertEqual(values, 2308)
        }
    }
    
    
    
    let day6TestInput1 = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
    let day6TestInput2 = "bvwbjplbgvbhsrlpgdmjqwftvncz"
    let day6TestInput3 = "nppdvjthqldpwncqszvftbrmjlhg"
    let day6TestInput4 = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
    let day6TestInput5 = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"


}
