//: Advent of Code 2019: 01 - The Tyranny of the Rocket Equation (Part 2)
// https://adventofcode.com/2019/day/1

import XCTest

func totalFuel(input: String) -> Int {
  let lines = input.split(separator: "\n")
  let inputs = lines.map { Int($0) }
  
  var total = 0
  
  for input in inputs {
    if let input = input {
      total += calculateTotal(input: input)
    }
  }
  
  return total
}

func calculateTotal(input: Int) -> Int {
  var total = 0
  
  var value = 0
  var input = input
  repeat {
    value = calculate(input: input)
    total += value
    input = value
  } while value > 0
  
  return total
}

func calculate(input: Int) -> Int {
  let input = Double(input)
  let value = (input / 3).rounded(.down) - 2
  
  if value < 0 {
    return 0
  } else {
    return Int(value)
  }
}

class SequenceTests: XCTestCase {
  func testInput1() {
    let input = 12
    let value = calculate(input: input)
    XCTAssertEqual(value, 2)
  }

  func testInput2() {
    let input = 14
    let value = calculate(input: input)
    XCTAssertEqual(value, 2)
  }

  func testInput3() {
    let input = 1969
    let value = calculate(input: input)
    XCTAssertEqual(value, 654)
  }

  func testInput4() {
    let input = 100756
    let value = calculate(input: input)
    XCTAssertEqual(value, 33583)
  }

  func testInput5() {
    let input = 2
    let value = calculate(input: input)
    XCTAssertEqual(value, 0)
  }

  func testInput6() {
    let input = 14
    let value = calculate(input: input)
    XCTAssertEqual(value, 2)
  }
  
  func testInput7() {
    let input = 1969
    let value = calculateTotal(input: input)
    XCTAssertEqual(value, 966)
  }
  
  func testInput8() {
    let input = 100756
    let value = calculateTotal(input: input)
    XCTAssertEqual(value, 50346)
  }
}

SequenceTests.defaultTestSuite.run()

let input = """
118997
63756
124972
141795
111429
53536
50522
143985
62669
77518
60164
72698
123145
57693
87138
82831
53289
60110
115660
51217
117781
81556
103963
89000
109330
100487
136562
145020
140554
102425
93333
75265
55764
70093
73800
81349
141055
56441
141696
89544
106152
98674
100882
137932
88008
149027
92767
113740
79971
85741
126630
75626
125042
69237
147069
60786
63751
144363
81873
107230
90789
81655
144004
74536
126675
147470
123359
68081
136423
94629
58263
122420
143933
148528
129120
78391
74289
106795
143640
59108
64462
78216
56113
64708
82372
115231
74229
130979
83590
76666
93156
138450
71077
128048
65476
85804
145692
106836
70016
113158
"""

let value = totalFuel(input: input)
print(value)
// (1)Correct Answer: 3256114
// (2)Correct Answer: 4881302
