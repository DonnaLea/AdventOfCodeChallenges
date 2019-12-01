//: Advent of Code 2018: XX - Template (Part 1)
// https://adventofcode.com/2018/day/XX

import XCTest

struct SleepRecord {
  let date: String
  let guardId: Int
  var asleepMinutes = Array<Int>()
  var timeAsleep: Int {
    return asleepMinutes.count
  }
  
  init(date: String, guardId: Int) {
    self.date = date
    self.guardId = guardId
  }
  
  mutating func addSleepSession(start: Int, end: Int) {
    for minute in start...end {
      asleepMinutes.append(minute)
    }
  }
}

enum Info {
  case asleep
  case awake
  case guardId
}

func calculate(input: String) -> Int {
  var sleepRecords = Dictionary<Int, Array<SleepRecord>>()
  var currentGuardId: Int?
  var currentGuardSleepRecords = Array<SleepRecord>()
  var currentSleepRecord: SleepRecord? = nil
  var currentSleepStart: Int?
  
  for line in input.split(separator: "\n").sorted() {
    let info = splitIntoInfo(input: line)
    
    switch info.info {
    case .guardId:
      // New Guard
      // Save previous guard info
      if let guardId = currentGuardId, let currentSleepRecord = currentSleepRecord {
        currentGuardSleepRecords.append(currentSleepRecord)
        sleepRecords[guardId] = currentGuardSleepRecords
      }
      currentGuardId = info.guardId
      currentGuardSleepRecords = sleepRecords[currentGuardId!] ?? []
      currentSleepStart = nil
      currentSleepRecord = SleepRecord(date: info.date, guardId: currentGuardId!)
      
    case .asleep:
      currentSleepStart = info.minute
    case .awake:
      currentSleepRecord?.addSleepSession(start: currentSleepStart!, end: info.minute-1)
    }
    
    
  }
  
  let guardIdWithMostSleep = guardIDMostAsleep(sleepRecords: sleepRecords)
  let minuteMostLikelyAsleep = minuteMostAsleep(guardId: guardIdWithMostSleep, sleepRecords: sleepRecords)
  
  let value = guardIdWithMostSleep * minuteMostLikelyAsleep
  
  return value
}

func guardIDMostAsleep(sleepRecords: Dictionary<Int, Array<SleepRecord>>) -> Int {
  var sleepCounts = Dictionary<Int, Int>()
  var guardIdWithMaxSleep: Int? = nil
  var maxSleepCount = 0
  
  for guardId in sleepRecords.keys {
    var sleepCount = sleepCounts[guardId] ?? 0
    for sleepRecord in sleepRecords[guardId] ?? [] {
      sleepCount += sleepRecord.timeAsleep
    }
    sleepCounts[guardId] = sleepCount
    if sleepCount > maxSleepCount {
      maxSleepCount = sleepCount
      guardIdWithMaxSleep = guardId
    }
  }
  
  return guardIdWithMaxSleep!
}

func minuteMostAsleep(guardId: Int, sleepRecords: Dictionary<Int, Array<SleepRecord>>) -> Int {
  let sleepRecordsForGuard = sleepRecords[guardId]!
  
  var mostAsleepMinute = -1
  var mostAsleepMinuteCount = 0
  
  for minute in 0...59 {
    var sleepCount = 0
    for sleepRecord in sleepRecordsForGuard {
      if sleepRecord.asleepMinutes.contains(minute) {
        sleepCount += 1
      }
    }
    
    if sleepCount > mostAsleepMinuteCount {
      mostAsleepMinuteCount = sleepCount
      mostAsleepMinute = minute
    }
  }
  
  return mostAsleepMinute
}

func splitIntoInfo(input: String.SubSequence) -> (date: String, minute: Int, info: Info, guardId: Int?) {

  let dateBeginIndex = input.index(after: input.firstIndex(of: "[")!)
  let squareCloseIndex = input.firstIndex(of: "]")!
  let dateEndIndex = input.index(before: squareCloseIndex)
  let dateString = input[dateBeginIndex...dateEndIndex]
  let infoStringStartIndex = input.index(squareCloseIndex, offsetBy: 2)
  let infoString = input[infoStringStartIndex...]
  let colonIndex = input.firstIndex(of: ":")!
  let minuteStartIndex = input.index(after: colonIndex)
  let minuteEndIndex = input.index(before: squareCloseIndex)
  let minute = Int(input[minuteStartIndex...minuteEndIndex])!
  var guardId: Int? = nil
  var info: Info = .guardId
  if let hashIndex = infoString.firstIndex(of: "#") {
    let guardStartIndex = infoString.index(after: hashIndex)
    let guardEndIndex = infoString.index(before: infoString[guardStartIndex...].firstIndex(of: " ")!)
    guardId = Int(infoString[guardStartIndex...guardEndIndex])
    info = .guardId
  } else if infoString.contains("asleep") {
    info = .asleep
  } else if infoString.contains("wakes up") {
    info = .awake
  }
  
  let value = (date: String(dateString), minute: minute, info: info, guardId: guardId)
  
  return value
}

let input = """
  [1518-11-22 00:00] Guard #1231 begins shift
  [1518-04-13 00:00] falls asleep
  [1518-09-09 00:02] falls asleep
  [1518-04-06 00:58] wakes up
  [1518-04-28 00:19] falls asleep
  [1518-03-25 00:52] wakes up
  [1518-04-12 00:56] falls asleep
  [1518-10-25 00:09] falls asleep
  [1518-09-07 00:00] Guard #2383 begins shift
  [1518-08-20 00:17] falls asleep
  [1518-05-09 00:58] wakes up
  [1518-05-16 00:16] falls asleep
  [1518-08-25 23:57] Guard #3499 begins shift
  [1518-10-09 00:51] falls asleep
  [1518-10-04 00:53] wakes up
  [1518-04-09 00:57] wakes up
  [1518-09-09 00:37] wakes up
  [1518-05-30 00:58] wakes up
  [1518-04-23 00:43] wakes up
  [1518-05-16 00:58] wakes up
  [1518-05-02 23:56] Guard #3371 begins shift
  [1518-07-06 00:48] wakes up
  [1518-06-14 00:24] falls asleep
  [1518-10-22 00:30] falls asleep
  [1518-07-09 00:57] wakes up
  [1518-09-13 23:58] Guard #283 begins shift
  [1518-05-04 00:54] wakes up
  [1518-03-24 00:58] wakes up
  [1518-09-15 00:26] falls asleep
  [1518-10-17 00:02] Guard #1171 begins shift
  [1518-05-04 00:40] wakes up
  [1518-10-13 00:42] falls asleep
  [1518-11-22 00:54] wakes up
  [1518-06-25 00:24] falls asleep
  [1518-03-01 23:59] Guard #1033 begins shift
  [1518-06-13 00:20] falls asleep
  [1518-10-18 00:36] falls asleep
  [1518-03-11 00:20] wakes up
  [1518-07-24 00:01] Guard #2729 begins shift
  [1518-02-28 23:57] Guard #2729 begins shift
  [1518-07-04 00:03] Guard #3533 begins shift
  [1518-07-02 00:04] Guard #1171 begins shift
  [1518-07-10 00:18] falls asleep
  [1518-04-12 00:49] wakes up
  [1518-04-29 00:49] falls asleep
  [1518-05-24 00:13] wakes up
  [1518-04-09 00:36] wakes up
  [1518-07-02 23:48] Guard #1033 begins shift
  [1518-10-20 00:46] falls asleep
  [1518-09-20 00:50] wakes up
  [1518-06-16 00:36] wakes up
  [1518-06-29 00:00] Guard #1021 begins shift
  [1518-02-27 00:25] wakes up
  [1518-04-22 00:41] falls asleep
  [1518-05-10 00:58] wakes up
  [1518-07-27 00:12] falls asleep
  [1518-09-04 00:58] wakes up
  [1518-09-29 00:50] falls asleep
  [1518-09-02 00:02] Guard #3371 begins shift
  [1518-08-29 00:54] wakes up
  [1518-04-23 00:00] falls asleep
  [1518-10-31 00:40] wakes up
  [1518-03-17 00:02] wakes up
  [1518-05-21 00:32] falls asleep
  [1518-04-24 00:46] wakes up
  [1518-02-20 00:57] wakes up
  [1518-02-18 00:43] wakes up
  [1518-09-19 00:21] wakes up
  [1518-08-30 00:59] wakes up
  [1518-06-04 00:51] wakes up
  [1518-06-30 00:50] falls asleep
  [1518-07-02 00:14] falls asleep
  [1518-08-11 00:35] wakes up
  [1518-04-12 00:00] Guard #419 begins shift
  [1518-02-25 00:02] falls asleep
  [1518-11-22 00:25] wakes up
  [1518-07-07 00:21] falls asleep
  [1518-11-06 23:56] Guard #1033 begins shift
  [1518-09-21 00:16] wakes up
  [1518-04-29 00:50] wakes up
  [1518-06-16 00:08] falls asleep
  [1518-09-01 00:46] falls asleep
  [1518-04-18 00:54] wakes up
  [1518-07-14 23:58] Guard #2383 begins shift
  [1518-04-20 00:48] wakes up
  [1518-05-30 00:26] falls asleep
  [1518-10-27 00:53] wakes up
  [1518-10-04 00:51] falls asleep
  [1518-08-18 00:34] falls asleep
  [1518-07-29 23:57] Guard #1553 begins shift
  [1518-09-09 00:05] wakes up
  [1518-06-26 00:58] wakes up
  [1518-05-07 00:54] wakes up
  [1518-10-30 00:49] falls asleep
  [1518-03-24 00:24] falls asleep
  [1518-06-18 00:54] falls asleep
  [1518-09-03 00:14] falls asleep
  [1518-02-17 00:24] falls asleep
  [1518-08-04 00:27] falls asleep
  [1518-02-19 00:46] wakes up
  [1518-10-28 00:56] wakes up
  [1518-02-17 23:56] Guard #1297 begins shift
  [1518-09-07 23:58] Guard #1297 begins shift
  [1518-03-09 00:56] wakes up
  [1518-03-13 00:07] falls asleep
  [1518-11-06 00:56] wakes up
  [1518-07-03 00:50] wakes up
  [1518-08-07 00:01] Guard #1723 begins shift
  [1518-08-22 00:12] falls asleep
  [1518-04-20 00:02] Guard #1193 begins shift
  [1518-03-23 00:33] wakes up
  [1518-06-27 00:33] wakes up
  [1518-08-21 23:58] Guard #1231 begins shift
  [1518-04-03 00:50] falls asleep
  [1518-07-24 00:22] falls asleep
  [1518-08-06 00:23] falls asleep
  [1518-08-10 00:02] Guard #2729 begins shift
  [1518-08-27 00:59] wakes up
  [1518-05-10 00:57] falls asleep
  [1518-08-02 00:33] falls asleep
  [1518-03-14 00:45] wakes up
  [1518-08-14 00:00] Guard #283 begins shift
  [1518-05-08 00:53] wakes up
  [1518-03-31 00:04] wakes up
  [1518-05-03 00:48] wakes up
  [1518-06-13 00:24] wakes up
  [1518-10-10 00:08] wakes up
  [1518-06-13 00:02] wakes up
  [1518-10-18 00:21] wakes up
  [1518-08-16 00:01] Guard #1033 begins shift
  [1518-10-01 00:07] falls asleep
  [1518-02-18 00:52] wakes up
  [1518-09-24 00:45] falls asleep
  [1518-03-28 00:47] falls asleep
  [1518-02-25 00:13] wakes up
  [1518-09-28 00:38] falls asleep
  [1518-08-13 00:26] wakes up
  [1518-10-31 00:58] wakes up
  [1518-11-22 00:39] falls asleep
  [1518-07-11 00:57] wakes up
  [1518-09-02 00:49] wakes up
  [1518-07-10 00:41] falls asleep
  [1518-09-11 00:42] wakes up
  [1518-03-15 00:11] falls asleep
  [1518-04-24 00:20] falls asleep
  [1518-11-16 00:49] wakes up
  [1518-07-05 00:38] wakes up
  [1518-09-25 00:00] Guard #3533 begins shift
  [1518-07-02 00:46] falls asleep
  [1518-07-28 00:22] falls asleep
  [1518-10-20 00:57] wakes up
  [1518-06-02 00:44] falls asleep
  [1518-05-28 00:35] falls asleep
  [1518-06-29 00:09] falls asleep
  [1518-05-21 00:04] Guard #1193 begins shift
  [1518-08-05 00:57] wakes up
  [1518-08-29 00:47] falls asleep
  [1518-10-19 23:51] Guard #2729 begins shift
  [1518-06-12 00:25] wakes up
  [1518-08-27 23:51] Guard #419 begins shift
  [1518-07-08 00:32] wakes up
  [1518-04-19 00:26] falls asleep
  [1518-05-14 00:16] falls asleep
  [1518-10-26 00:51] falls asleep
  [1518-05-25 23:57] Guard #3533 begins shift
  [1518-11-14 00:02] falls asleep
  [1518-06-03 23:58] Guard #1033 begins shift
  [1518-10-11 00:53] wakes up
  [1518-08-30 00:03] Guard #1901 begins shift
  [1518-08-13 00:49] wakes up
  [1518-07-20 23:56] Guard #1021 begins shift
  [1518-04-21 00:45] falls asleep
  [1518-05-01 00:45] falls asleep
  [1518-03-05 00:48] wakes up
  [1518-06-07 00:03] Guard #3371 begins shift
  [1518-06-09 00:24] falls asleep
  [1518-06-23 00:00] falls asleep
  [1518-06-11 00:02] falls asleep
  [1518-06-29 23:50] Guard #2129 begins shift
  [1518-04-17 00:52] wakes up
  [1518-03-25 23:49] Guard #1171 begins shift
  [1518-07-02 00:32] wakes up
  [1518-08-20 00:28] wakes up
  [1518-10-17 00:10] falls asleep
  [1518-04-01 00:00] Guard #3371 begins shift
  [1518-03-31 00:10] falls asleep
  [1518-07-11 00:03] falls asleep
  [1518-04-29 00:44] wakes up
  [1518-07-01 00:45] wakes up
  [1518-05-11 00:57] wakes up
  [1518-06-08 00:17] wakes up
  [1518-09-10 00:59] wakes up
  [1518-10-09 00:43] wakes up
  [1518-10-12 00:59] wakes up
  [1518-04-14 00:28] falls asleep
  [1518-03-28 00:44] wakes up
  [1518-06-11 00:51] falls asleep
  [1518-04-07 00:01] Guard #2707 begins shift
  [1518-08-03 23:59] Guard #1553 begins shift
  [1518-06-16 23:58] Guard #2447 begins shift
  [1518-08-08 00:41] wakes up
  [1518-11-03 00:06] falls asleep
  [1518-10-05 00:52] wakes up
  [1518-08-17 00:44] wakes up
  [1518-08-26 00:27] wakes up
  [1518-04-24 23:58] Guard #1033 begins shift
  [1518-11-11 00:52] falls asleep
  [1518-06-22 23:54] Guard #1021 begins shift
  [1518-06-17 23:58] Guard #2707 begins shift
  [1518-04-20 00:24] wakes up
  [1518-03-17 00:01] falls asleep
  [1518-08-20 00:43] wakes up
  [1518-05-01 00:27] wakes up
  [1518-09-27 23:58] Guard #2447 begins shift
  [1518-08-19 00:03] Guard #2707 begins shift
  [1518-07-22 00:44] falls asleep
  [1518-03-25 00:00] falls asleep
  [1518-05-22 00:32] falls asleep
  [1518-06-19 00:19] falls asleep
  [1518-06-02 00:54] falls asleep
  [1518-08-23 00:52] wakes up
  [1518-05-13 00:42] wakes up
  [1518-05-21 23:57] Guard #2383 begins shift
  [1518-03-01 00:47] wakes up
  [1518-10-16 00:40] wakes up
  [1518-07-17 23:50] Guard #2383 begins shift
  [1518-06-03 00:51] wakes up
  [1518-05-15 00:42] falls asleep
  [1518-03-08 00:33] falls asleep
  [1518-07-05 00:50] wakes up
  [1518-06-11 00:56] wakes up
  [1518-02-28 00:18] falls asleep
  [1518-05-29 00:44] wakes up
  [1518-07-07 00:31] wakes up
  [1518-07-13 00:03] Guard #2539 begins shift
  [1518-10-20 00:00] falls asleep
  [1518-03-29 00:16] falls asleep
  [1518-02-13 00:02] Guard #1021 begins shift
  [1518-11-04 00:03] Guard #1553 begins shift
  [1518-02-14 00:30] falls asleep
  [1518-04-26 00:19] falls asleep
  [1518-03-27 00:02] Guard #2129 begins shift
  [1518-09-27 00:50] wakes up
  [1518-07-31 00:25] wakes up
  [1518-05-12 00:59] wakes up
  [1518-04-22 00:07] falls asleep
  [1518-04-12 00:58] wakes up
  [1518-06-10 00:54] wakes up
  [1518-05-25 00:59] wakes up
  [1518-06-26 00:03] Guard #3371 begins shift
  [1518-10-30 00:04] Guard #1993 begins shift
  [1518-02-15 00:28] wakes up
  [1518-08-03 00:22] falls asleep
  [1518-07-29 00:58] wakes up
  [1518-10-06 00:00] Guard #1193 begins shift
  [1518-09-06 00:08] falls asleep
  [1518-05-18 23:57] Guard #3119 begins shift
  [1518-09-22 00:12] wakes up
  [1518-11-05 00:41] falls asleep
  [1518-11-10 00:55] wakes up
  [1518-08-15 00:28] wakes up
  [1518-05-10 00:52] wakes up
  [1518-08-08 23:57] Guard #1193 begins shift
  [1518-08-30 00:46] falls asleep
  [1518-11-08 23:59] Guard #1193 begins shift
  [1518-11-14 23:57] Guard #1033 begins shift
  [1518-04-13 00:42] wakes up
  [1518-11-02 00:56] wakes up
  [1518-10-06 00:56] wakes up
  [1518-10-01 00:45] falls asleep
  [1518-11-23 00:11] falls asleep
  [1518-08-15 00:00] Guard #1553 begins shift
  [1518-11-10 00:04] Guard #1993 begins shift
  [1518-05-27 00:11] falls asleep
  [1518-06-02 00:57] wakes up
  [1518-07-12 00:37] wakes up
  [1518-05-04 00:14] wakes up
  [1518-07-21 23:59] Guard #2129 begins shift
  [1518-09-03 00:43] wakes up
  [1518-11-12 00:08] wakes up
  [1518-09-30 23:56] Guard #2129 begins shift
  [1518-02-20 00:53] falls asleep
  [1518-10-19 00:03] Guard #1231 begins shift
  [1518-05-18 00:36] wakes up
  [1518-03-30 00:58] wakes up
  [1518-10-21 00:00] falls asleep
  [1518-08-03 00:50] wakes up
  [1518-04-12 00:08] falls asleep
  [1518-07-20 00:06] wakes up
  [1518-09-08 00:44] falls asleep
  [1518-09-06 00:53] wakes up
  [1518-11-11 00:02] falls asleep
  [1518-08-12 00:38] wakes up
  [1518-07-06 00:04] Guard #1553 begins shift
  [1518-03-18 00:02] Guard #2707 begins shift
  [1518-03-05 00:00] Guard #2729 begins shift
  [1518-10-26 00:55] falls asleep
  [1518-02-22 00:59] wakes up
  [1518-10-29 00:16] falls asleep
  [1518-05-01 23:57] Guard #283 begins shift
  [1518-09-28 00:48] wakes up
  [1518-09-17 00:36] falls asleep
  [1518-10-22 00:26] wakes up
  [1518-09-15 23:56] Guard #2447 begins shift
  [1518-09-03 00:36] wakes up
  [1518-06-12 00:01] Guard #1901 begins shift
  [1518-09-16 00:17] falls asleep
  [1518-07-17 00:02] Guard #2729 begins shift
  [1518-03-13 23:58] Guard #419 begins shift
  [1518-08-15 00:39] falls asleep
  [1518-05-23 00:01] Guard #3371 begins shift
  [1518-08-30 00:34] wakes up
  [1518-02-23 23:56] Guard #2129 begins shift
  [1518-03-30 23:49] Guard #3119 begins shift
  [1518-02-12 00:22] falls asleep
  [1518-09-24 00:07] falls asleep
  [1518-10-13 00:50] wakes up
  [1518-02-19 00:29] falls asleep
  [1518-02-17 00:37] wakes up
  [1518-09-12 23:51] Guard #3119 begins shift
  [1518-07-22 23:58] Guard #1033 begins shift
  [1518-08-01 00:23] wakes up
  [1518-03-21 00:35] falls asleep
  [1518-10-14 00:32] falls asleep
  [1518-11-23 00:43] wakes up
  [1518-05-29 00:12] falls asleep
  [1518-08-11 00:01] Guard #1171 begins shift
  [1518-04-09 00:02] Guard #2707 begins shift
  [1518-03-30 00:56] falls asleep
  [1518-02-15 00:50] falls asleep
  [1518-03-02 00:53] wakes up
  [1518-04-09 00:50] falls asleep
  [1518-07-25 00:54] wakes up
  [1518-07-27 00:45] falls asleep
  [1518-10-20 23:53] Guard #1021 begins shift
  [1518-02-11 00:05] falls asleep
  [1518-04-25 00:40] falls asleep
  [1518-08-18 00:57] falls asleep
  [1518-09-26 23:58] Guard #1033 begins shift
  [1518-04-30 00:41] wakes up
  [1518-10-05 00:51] falls asleep
  [1518-03-11 00:28] wakes up
  [1518-10-22 23:57] Guard #2447 begins shift
  [1518-11-12 00:04] Guard #1193 begins shift
  [1518-04-26 00:15] wakes up
  [1518-10-29 00:35] falls asleep
  [1518-06-25 00:04] Guard #3119 begins shift
  [1518-06-12 00:48] falls asleep
  [1518-11-07 00:48] falls asleep
  [1518-04-26 00:55] wakes up
  [1518-04-25 23:54] Guard #2963 begins shift
  [1518-08-20 00:42] falls asleep
  [1518-04-29 00:07] falls asleep
  [1518-05-28 00:02] Guard #2729 begins shift
  [1518-07-01 00:00] Guard #2539 begins shift
  [1518-04-03 00:52] wakes up
  [1518-07-27 00:00] Guard #1993 begins shift
  [1518-02-27 00:07] falls asleep
  [1518-11-19 23:59] Guard #3371 begins shift
  [1518-07-20 00:00] falls asleep
  [1518-04-17 00:36] falls asleep
  [1518-10-17 00:56] wakes up
  [1518-11-18 00:56] falls asleep
  [1518-08-09 00:33] falls asleep
  [1518-09-21 00:53] wakes up
  [1518-08-04 00:48] wakes up
  [1518-04-22 23:53] Guard #2963 begins shift
  [1518-03-01 00:14] falls asleep
  [1518-06-02 00:03] Guard #1553 begins shift
  [1518-03-20 00:01] falls asleep
  [1518-08-18 00:02] Guard #1993 begins shift
  [1518-05-11 00:24] falls asleep
  [1518-08-11 00:13] falls asleep
  [1518-07-14 00:04] Guard #2447 begins shift
  [1518-05-28 00:52] falls asleep
  [1518-03-12 00:01] Guard #3119 begins shift
  [1518-10-18 00:02] falls asleep
  [1518-07-16 00:31] wakes up
  [1518-02-14 00:47] wakes up
  [1518-07-30 23:59] Guard #1021 begins shift
  [1518-06-28 00:48] falls asleep
  [1518-10-23 00:09] falls asleep
  [1518-03-28 00:58] wakes up
  [1518-08-30 00:21] falls asleep
  [1518-04-21 00:09] falls asleep
  [1518-11-09 00:48] wakes up
  [1518-05-07 23:54] Guard #1033 begins shift
  [1518-06-20 00:00] Guard #419 begins shift
  [1518-09-29 00:55] wakes up
  [1518-05-12 00:00] Guard #2129 begins shift
  [1518-06-22 00:59] wakes up
  [1518-02-18 00:09] falls asleep
  [1518-06-24 00:01] Guard #283 begins shift
  [1518-07-31 00:23] falls asleep
  [1518-06-27 00:04] Guard #1021 begins shift
  [1518-10-16 00:20] falls asleep
  [1518-07-14 00:47] wakes up
  [1518-08-28 00:00] falls asleep
  [1518-05-04 23:50] Guard #3371 begins shift
  [1518-04-21 00:25] falls asleep
  [1518-10-02 00:00] Guard #1231 begins shift
  [1518-07-06 00:39] falls asleep
  [1518-03-08 00:53] wakes up
  [1518-05-10 00:42] falls asleep
  [1518-07-20 00:44] falls asleep
  [1518-06-10 00:25] wakes up
  [1518-05-19 00:54] falls asleep
  [1518-08-24 00:05] falls asleep
  [1518-09-02 00:39] falls asleep
  [1518-06-07 00:06] falls asleep
  [1518-05-24 00:51] wakes up
  [1518-03-21 00:00] Guard #1171 begins shift
  [1518-08-19 00:49] wakes up
  [1518-05-18 00:40] falls asleep
  [1518-04-05 23:59] Guard #2539 begins shift
  [1518-04-09 00:20] falls asleep
  [1518-05-21 00:42] falls asleep
  [1518-07-10 00:20] wakes up
  [1518-03-02 23:56] Guard #419 begins shift
  [1518-08-12 00:23] falls asleep
  [1518-03-31 00:44] falls asleep
  [1518-08-25 00:43] falls asleep
  [1518-06-09 00:01] Guard #1171 begins shift
  [1518-06-30 00:59] wakes up
  [1518-03-14 00:30] falls asleep
  [1518-03-23 00:49] falls asleep
  [1518-09-08 23:49] Guard #2383 begins shift
  [1518-09-04 00:01] Guard #3371 begins shift
  [1518-05-01 00:14] falls asleep
  [1518-06-19 00:24] wakes up
  [1518-10-29 00:02] Guard #2447 begins shift
  [1518-11-18 00:04] Guard #2729 begins shift
  [1518-09-04 00:08] falls asleep
  [1518-09-29 23:58] Guard #2707 begins shift
  [1518-10-02 00:47] wakes up
  [1518-10-31 00:27] wakes up
  [1518-08-27 00:00] Guard #1297 begins shift
  [1518-11-09 00:21] falls asleep
  [1518-04-20 00:45] falls asleep
  [1518-07-17 00:56] falls asleep
  [1518-10-25 00:24] wakes up
  [1518-10-15 00:54] wakes up
  [1518-11-04 00:21] wakes up
  [1518-02-13 23:56] Guard #2447 begins shift
  [1518-07-30 00:53] falls asleep
  [1518-07-05 00:41] falls asleep
  [1518-11-11 00:39] wakes up
  [1518-07-31 00:29] falls asleep
  [1518-08-18 00:36] wakes up
  [1518-03-31 00:41] wakes up
  [1518-06-27 23:57] Guard #1033 begins shift
  [1518-07-25 00:37] wakes up
  [1518-11-20 00:55] wakes up
  [1518-06-30 00:14] wakes up
  [1518-06-21 00:30] falls asleep
  [1518-11-13 00:38] wakes up
  [1518-05-18 00:09] falls asleep
  [1518-07-08 00:37] falls asleep
  [1518-06-08 00:03] falls asleep
  [1518-09-18 00:14] wakes up
  [1518-11-09 00:53] falls asleep
  [1518-05-08 00:27] wakes up
  [1518-04-16 23:57] Guard #3499 begins shift
  [1518-09-13 00:22] wakes up
  [1518-03-29 23:57] Guard #1193 begins shift
  [1518-05-20 00:57] wakes up
  [1518-05-15 00:55] wakes up
  [1518-08-30 23:54] Guard #1553 begins shift
  [1518-03-03 00:41] wakes up
  [1518-10-01 00:34] wakes up
  [1518-03-30 00:42] falls asleep
  [1518-04-22 00:59] wakes up
  [1518-03-06 00:36] wakes up
  [1518-11-18 00:52] falls asleep
  [1518-05-16 00:34] wakes up
  [1518-02-13 00:37] wakes up
  [1518-02-22 00:30] wakes up
  [1518-09-23 23:56] Guard #1993 begins shift
  [1518-11-08 00:35] falls asleep
  [1518-04-18 00:23] falls asleep
  [1518-06-16 00:01] Guard #1171 begins shift
  [1518-06-01 00:10] falls asleep
  [1518-11-16 00:55] falls asleep
  [1518-04-28 00:40] wakes up
  [1518-08-24 00:44] wakes up
  [1518-07-07 00:00] Guard #1993 begins shift
  [1518-05-16 00:01] Guard #1171 begins shift
  [1518-11-16 23:58] Guard #1297 begins shift
  [1518-11-14 00:09] wakes up
  [1518-10-10 00:34] falls asleep
  [1518-10-28 00:18] falls asleep
  [1518-06-07 00:47] wakes up
  [1518-11-23 00:37] falls asleep
  [1518-08-03 00:00] Guard #2447 begins shift
  [1518-10-03 23:57] Guard #1297 begins shift
  [1518-07-10 00:02] Guard #1171 begins shift
  [1518-04-01 00:53] wakes up
  [1518-05-17 00:35] falls asleep
  [1518-06-25 00:51] wakes up
  [1518-06-09 00:48] wakes up
  [1518-05-03 00:26] falls asleep
  [1518-09-07 00:15] falls asleep
  [1518-03-06 23:58] Guard #1901 begins shift
  [1518-03-22 23:57] Guard #1901 begins shift
  [1518-06-26 00:32] falls asleep
  [1518-02-17 00:04] Guard #1193 begins shift
  [1518-04-06 00:52] falls asleep
  [1518-03-11 00:53] wakes up
  [1518-02-12 00:50] falls asleep
  [1518-04-03 23:59] Guard #2707 begins shift
  [1518-04-14 23:57] Guard #3533 begins shift
  [1518-10-07 23:50] Guard #3371 begins shift
  [1518-03-15 00:56] falls asleep
  [1518-10-19 00:57] falls asleep
  [1518-09-24 00:36] wakes up
  [1518-08-21 00:47] wakes up
  [1518-02-22 00:46] falls asleep
  [1518-11-15 00:30] wakes up
  [1518-02-21 23:59] Guard #2729 begins shift
  [1518-03-11 00:48] falls asleep
  [1518-11-04 00:17] falls asleep
  [1518-07-18 00:00] falls asleep
  [1518-06-18 23:59] Guard #3371 begins shift
  [1518-04-18 00:53] falls asleep
  [1518-10-08 00:33] wakes up
  [1518-02-25 00:24] falls asleep
  [1518-04-21 00:39] wakes up
  [1518-06-04 00:30] wakes up
  [1518-11-21 00:09] falls asleep
  [1518-06-13 00:35] falls asleep
  [1518-09-30 00:34] falls asleep
  [1518-11-09 00:33] wakes up
  [1518-07-03 00:02] falls asleep
  [1518-03-31 00:50] wakes up
  [1518-05-08 00:51] falls asleep
  [1518-08-16 00:57] wakes up
  [1518-10-23 23:58] Guard #3119 begins shift
  [1518-09-15 00:03] Guard #1297 begins shift
  [1518-05-20 00:48] falls asleep
  [1518-10-01 00:49] wakes up
  [1518-11-08 00:00] Guard #1021 begins shift
  [1518-05-20 00:01] falls asleep
  [1518-07-29 00:02] Guard #1231 begins shift
  [1518-09-17 00:51] wakes up
  [1518-02-23 00:22] falls asleep
  [1518-02-26 00:41] wakes up
  [1518-02-26 00:13] falls asleep
  [1518-04-02 00:38] falls asleep
  [1518-05-06 23:51] Guard #1033 begins shift
  [1518-06-18 00:59] wakes up
  [1518-06-28 00:50] wakes up
  [1518-02-24 00:28] wakes up
  [1518-08-21 00:14] falls asleep
  [1518-03-10 00:31] falls asleep
  [1518-05-06 00:03] falls asleep
  [1518-11-13 00:21] falls asleep
  [1518-09-19 00:01] Guard #1901 begins shift
  [1518-03-12 00:12] falls asleep
  [1518-10-22 00:48] wakes up
  [1518-08-17 00:03] falls asleep
  [1518-04-06 00:47] wakes up
  [1518-07-16 00:18] falls asleep
  [1518-06-02 00:46] wakes up
  [1518-04-23 00:17] wakes up
  [1518-11-18 00:53] wakes up
  [1518-10-09 00:57] falls asleep
  [1518-03-06 00:02] falls asleep
  [1518-10-30 00:28] falls asleep
  [1518-11-16 00:03] Guard #2129 begins shift
  [1518-02-20 23:57] Guard #1193 begins shift
  [1518-06-14 00:30] wakes up
  [1518-05-04 00:26] falls asleep
  [1518-06-30 00:46] wakes up
  [1518-07-27 00:39] wakes up
  [1518-06-05 00:36] wakes up
  [1518-03-15 00:57] wakes up
  [1518-10-21 23:56] Guard #1193 begins shift
  [1518-04-04 00:32] falls asleep
  [1518-08-22 23:51] Guard #1993 begins shift
  [1518-05-12 00:11] falls asleep
  [1518-10-18 00:50] wakes up
  [1518-08-27 00:51] falls asleep
  [1518-10-17 23:49] Guard #3119 begins shift
  [1518-09-24 00:49] wakes up
  [1518-04-25 00:59] wakes up
  [1518-03-23 00:27] falls asleep
  [1518-05-27 00:01] Guard #1171 begins shift
  [1518-10-24 00:55] wakes up
  [1518-06-30 00:03] falls asleep
  [1518-10-11 00:50] falls asleep
  [1518-09-05 00:53] falls asleep
  [1518-08-23 00:00] falls asleep
  [1518-06-29 00:27] falls asleep
  [1518-03-05 00:06] falls asleep
  [1518-03-09 00:14] falls asleep
  [1518-09-22 00:04] falls asleep
  [1518-10-27 23:59] Guard #1021 begins shift
  [1518-10-30 00:52] wakes up
  [1518-09-18 00:58] wakes up
  [1518-06-18 00:32] wakes up
  [1518-11-01 00:31] falls asleep
  [1518-04-08 00:54] wakes up
  [1518-03-13 00:52] wakes up
  [1518-07-08 00:47] falls asleep
  [1518-05-09 00:50] falls asleep
  [1518-10-31 00:33] falls asleep
  [1518-03-20 00:51] wakes up
  [1518-09-11 00:02] Guard #3119 begins shift
  [1518-09-12 00:58] wakes up
  [1518-10-26 23:46] Guard #3499 begins shift
  [1518-07-26 00:13] falls asleep
  [1518-03-27 00:31] wakes up
  [1518-09-20 00:30] falls asleep
  [1518-07-27 00:47] wakes up
  [1518-11-19 00:17] falls asleep
  [1518-07-29 00:28] falls asleep
  [1518-07-30 00:59] wakes up
  [1518-05-03 23:53] Guard #1297 begins shift
  [1518-08-11 23:58] Guard #1297 begins shift
  [1518-05-14 23:48] Guard #3119 begins shift
  [1518-07-26 00:00] Guard #1171 begins shift
  [1518-03-18 00:15] falls asleep
  [1518-06-14 00:09] falls asleep
  [1518-03-24 23:54] Guard #1553 begins shift
  [1518-04-07 00:54] wakes up
  [1518-05-04 00:01] falls asleep
  [1518-02-15 00:55] wakes up
  [1518-04-20 00:11] falls asleep
  [1518-07-12 00:10] falls asleep
  [1518-03-15 00:46] wakes up
  [1518-06-20 00:26] wakes up
  [1518-05-30 00:34] falls asleep
  [1518-03-07 23:58] Guard #2539 begins shift
  [1518-04-23 00:42] falls asleep
  [1518-08-06 00:37] wakes up
  [1518-09-26 00:47] falls asleep
  [1518-05-10 23:59] Guard #2447 begins shift
  [1518-06-04 00:12] falls asleep
  [1518-06-23 00:44] wakes up
  [1518-02-16 00:17] falls asleep
  [1518-02-18 00:49] falls asleep
  [1518-05-25 00:45] falls asleep
  [1518-06-02 23:59] Guard #2963 begins shift
  [1518-03-10 00:00] Guard #2963 begins shift
  [1518-11-08 00:50] wakes up
  [1518-10-24 00:29] falls asleep
  [1518-06-09 00:51] falls asleep
  [1518-11-20 23:56] Guard #1901 begins shift
  [1518-02-12 00:04] Guard #1901 begins shift
  [1518-02-27 23:58] Guard #1021 begins shift
  [1518-11-22 00:13] falls asleep
  [1518-09-20 00:48] falls asleep
  [1518-06-15 00:05] falls asleep
  [1518-04-26 23:58] Guard #1901 begins shift
  [1518-10-14 00:37] wakes up
  [1518-10-04 00:19] falls asleep
  [1518-03-13 00:02] Guard #1033 begins shift
  [1518-06-13 00:00] falls asleep
  [1518-04-03 00:02] Guard #1033 begins shift
  [1518-06-14 23:52] Guard #1553 begins shift
  [1518-09-27 00:36] falls asleep
  [1518-02-24 00:25] falls asleep
  [1518-02-21 00:35] wakes up
  [1518-10-21 00:42] wakes up
  [1518-08-16 00:25] falls asleep
  [1518-07-14 00:28] falls asleep
  [1518-10-03 00:01] falls asleep
  [1518-05-15 00:02] falls asleep
  [1518-09-02 00:27] wakes up
  [1518-03-11 00:18] falls asleep
  [1518-07-28 00:48] wakes up
  [1518-09-13 00:53] falls asleep
  [1518-09-18 00:04] Guard #1021 begins shift
  [1518-07-23 00:41] wakes up
  [1518-10-14 00:40] falls asleep
  [1518-11-03 00:30] falls asleep
  [1518-03-10 00:41] wakes up
  [1518-10-11 00:44] wakes up
  [1518-05-07 00:38] wakes up
  [1518-07-19 23:50] Guard #1993 begins shift
  [1518-08-01 00:17] falls asleep
  [1518-05-28 00:47] wakes up
  [1518-04-06 00:29] falls asleep
  [1518-10-18 00:13] falls asleep
  [1518-11-03 00:51] wakes up
  [1518-07-19 00:03] Guard #3119 begins shift
  [1518-09-21 00:14] falls asleep
  [1518-08-31 00:04] falls asleep
  [1518-06-10 00:52] falls asleep
  [1518-07-17 00:58] wakes up
  [1518-08-08 00:31] falls asleep
  [1518-09-22 00:41] wakes up
  [1518-05-04 00:52] falls asleep
  [1518-02-12 00:52] wakes up
  [1518-11-23 00:20] wakes up
  [1518-08-25 00:54] wakes up
  [1518-02-11 00:43] falls asleep
  [1518-06-30 00:35] falls asleep
  [1518-10-29 00:59] wakes up
  [1518-10-14 00:02] Guard #1297 begins shift
  [1518-08-02 00:00] Guard #2707 begins shift
  [1518-07-12 00:01] Guard #2963 begins shift
  [1518-08-20 00:54] wakes up
  [1518-10-17 00:53] falls asleep
  [1518-07-31 00:56] wakes up
  [1518-05-05 00:50] wakes up
  [1518-08-10 00:31] falls asleep
  [1518-09-20 00:35] wakes up
  [1518-11-16 00:44] falls asleep
  [1518-07-11 00:12] wakes up
  [1518-11-11 00:58] wakes up
  [1518-05-19 23:50] Guard #1901 begins shift
  [1518-11-07 00:14] falls asleep
  [1518-11-21 00:58] wakes up
  [1518-09-10 00:00] Guard #2129 begins shift
  [1518-09-11 00:21] falls asleep
  [1518-04-09 23:56] Guard #2729 begins shift
  [1518-08-24 00:12] wakes up
  [1518-11-17 00:26] wakes up
  [1518-10-08 00:54] wakes up
  [1518-11-16 00:58] wakes up
  [1518-07-19 00:20] falls asleep
  [1518-04-21 00:49] wakes up
  [1518-09-13 00:57] wakes up
  [1518-03-12 00:39] wakes up
  [1518-03-28 00:03] Guard #3499 begins shift
  [1518-11-18 00:19] falls asleep
  [1518-08-10 00:50] wakes up
  [1518-03-21 00:39] wakes up
  [1518-03-13 00:51] falls asleep
  [1518-03-02 00:16] falls asleep
  [1518-02-19 00:00] Guard #3499 begins shift
  [1518-04-04 00:53] wakes up
  [1518-07-09 00:03] falls asleep
  [1518-04-11 00:50] wakes up
  [1518-08-13 00:37] falls asleep
  [1518-05-11 00:55] falls asleep
  [1518-09-26 00:02] Guard #1901 begins shift
  [1518-08-24 00:24] falls asleep
  [1518-07-16 00:26] falls asleep
  [1518-08-19 00:19] falls asleep
  [1518-10-20 00:34] wakes up
  [1518-03-28 00:07] falls asleep
  [1518-04-08 00:10] falls asleep
  [1518-04-01 00:14] falls asleep
  [1518-06-09 23:50] Guard #1033 begins shift
  [1518-10-13 00:01] Guard #3119 begins shift
  [1518-07-24 00:46] wakes up
  [1518-10-13 00:10] falls asleep
  [1518-08-26 00:25] falls asleep
  [1518-09-02 00:13] falls asleep
  [1518-05-30 23:58] Guard #1723 begins shift
  [1518-11-05 00:54] wakes up
  [1518-11-18 00:57] wakes up
  [1518-07-22 00:53] wakes up
  [1518-02-15 23:57] Guard #2383 begins shift
  [1518-09-10 00:30] falls asleep
  [1518-11-17 00:08] falls asleep
  [1518-11-06 00:25] falls asleep
  [1518-08-15 00:42] wakes up
  [1518-08-22 00:29] wakes up
  [1518-06-15 00:30] wakes up
  [1518-08-18 00:59] wakes up
  [1518-06-06 00:20] falls asleep
  [1518-11-07 00:32] wakes up
  [1518-05-29 00:03] Guard #1193 begins shift
  [1518-06-13 00:55] wakes up
  [1518-11-03 00:04] Guard #3371 begins shift
  [1518-06-21 00:58] wakes up
  [1518-06-19 00:47] falls asleep
  [1518-10-09 00:54] wakes up
  [1518-03-22 00:39] falls asleep
  [1518-10-09 23:48] Guard #1993 begins shift
  [1518-08-15 00:22] falls asleep
  [1518-04-24 00:02] Guard #1193 begins shift
  [1518-05-27 00:35] wakes up
  [1518-10-13 00:39] wakes up
  [1518-08-28 00:22] wakes up
  [1518-09-01 00:23] falls asleep
  [1518-08-09 00:47] wakes up
  [1518-11-15 00:27] falls asleep
  [1518-03-28 23:59] Guard #3371 begins shift
  [1518-10-26 00:59] wakes up
  [1518-02-27 00:01] Guard #1021 begins shift
  [1518-03-04 00:23] wakes up
  [1518-04-19 00:54] wakes up
  [1518-06-12 00:41] wakes up
  [1518-03-18 00:52] wakes up
  [1518-10-11 23:57] Guard #2729 begins shift
  [1518-08-09 00:12] falls asleep
  [1518-04-27 23:56] Guard #1193 begins shift
  [1518-07-25 00:51] falls asleep
  [1518-04-28 00:57] wakes up
  [1518-03-23 00:52] wakes up
  [1518-11-12 00:57] wakes up
  [1518-02-26 00:03] Guard #1993 begins shift
  [1518-07-13 00:45] wakes up
  [1518-10-22 00:14] falls asleep
  [1518-10-31 00:43] falls asleep
  [1518-04-02 00:50] wakes up
  [1518-08-16 23:50] Guard #2729 begins shift
  [1518-03-03 00:08] falls asleep
  [1518-05-01 00:04] Guard #1231 begins shift
  [1518-03-24 00:56] falls asleep
  [1518-08-24 23:57] Guard #3119 begins shift
  [1518-10-30 00:46] wakes up
  [1518-06-09 00:59] wakes up
  [1518-11-10 23:48] Guard #1021 begins shift
  [1518-11-05 23:58] Guard #2729 begins shift
  [1518-08-13 00:04] Guard #1171 begins shift
  [1518-06-07 23:54] Guard #2383 begins shift
  [1518-02-12 00:38] wakes up
  [1518-05-18 00:55] wakes up
  [1518-10-17 00:45] wakes up
  [1518-06-14 00:14] wakes up
  [1518-09-16 23:59] Guard #1193 begins shift
  [1518-07-29 00:52] wakes up
  [1518-03-05 23:50] Guard #1231 begins shift
  [1518-03-19 23:46] Guard #2707 begins shift
  [1518-03-04 00:59] wakes up
  [1518-10-09 00:59] wakes up
  [1518-09-26 00:52] wakes up
  [1518-07-23 00:19] falls asleep
  [1518-03-15 00:04] Guard #2383 begins shift
  [1518-04-16 00:01] Guard #283 begins shift
  [1518-06-14 00:01] Guard #2963 begins shift
  [1518-11-05 00:01] Guard #2447 begins shift
  [1518-07-08 00:57] wakes up
  [1518-07-08 23:51] Guard #1171 begins shift
  [1518-04-18 00:42] wakes up
  [1518-07-29 00:57] falls asleep
  [1518-09-21 00:26] falls asleep
  [1518-04-12 23:53] Guard #1231 begins shift
  [1518-08-05 00:03] Guard #3499 begins shift
  [1518-02-28 00:52] wakes up
  [1518-03-29 00:57] wakes up
  [1518-10-11 00:07] falls asleep
  [1518-09-18 00:12] falls asleep
  [1518-02-27 00:13] wakes up
  [1518-06-22 00:25] falls asleep
  [1518-06-01 00:01] Guard #2729 begins shift
  [1518-10-27 00:05] falls asleep
  [1518-10-04 23:59] Guard #3119 begins shift
  [1518-06-10 23:53] Guard #1901 begins shift
  [1518-03-19 00:56] wakes up
  [1518-04-21 23:58] Guard #2707 begins shift
  [1518-06-05 00:33] falls asleep
  [1518-10-19 00:54] wakes up
  [1518-05-12 23:59] Guard #3371 begins shift
  [1518-05-15 00:05] wakes up
  [1518-05-03 00:57] wakes up
  [1518-05-05 00:01] falls asleep
  [1518-05-30 00:00] Guard #3499 begins shift
  [1518-07-15 00:31] wakes up
  [1518-10-08 00:36] falls asleep
  [1518-09-03 00:02] Guard #1993 begins shift
  [1518-06-03 00:39] falls asleep
  [1518-05-13 23:57] Guard #419 begins shift
  [1518-10-02 23:53] Guard #1231 begins shift
  [1518-07-26 00:52] wakes up
  [1518-05-07 00:03] falls asleep
  [1518-06-01 00:55] wakes up
  [1518-07-25 00:14] falls asleep
  [1518-09-23 00:41] wakes up
  [1518-08-02 00:57] wakes up
  [1518-11-01 00:56] wakes up
  [1518-10-18 00:03] wakes up
  [1518-04-11 00:04] Guard #1297 begins shift
  [1518-03-11 00:26] falls asleep
  [1518-09-26 00:55] falls asleep
  [1518-05-21 00:34] wakes up
  [1518-10-19 00:20] falls asleep
  [1518-06-12 00:18] falls asleep
  [1518-06-02 00:51] wakes up
  [1518-04-13 23:59] Guard #1193 begins shift
  [1518-03-27 00:39] wakes up
  [1518-03-31 00:00] falls asleep
  [1518-07-05 00:37] falls asleep
  [1518-05-28 00:59] wakes up
  [1518-08-27 00:44] wakes up
  [1518-04-21 00:22] wakes up
  [1518-11-13 23:53] Guard #2963 begins shift
  [1518-05-23 00:50] wakes up
  [1518-10-14 00:53] wakes up
  [1518-04-27 00:53] wakes up
  [1518-11-12 23:58] Guard #1193 begins shift
  [1518-11-01 00:00] Guard #2129 begins shift
  [1518-07-01 00:10] falls asleep
  [1518-08-31 00:20] wakes up
  [1518-10-09 00:04] Guard #2129 begins shift
  [1518-09-13 00:04] falls asleep
  [1518-09-16 00:57] wakes up
  [1518-10-15 00:00] Guard #1901 begins shift
  [1518-08-29 00:03] Guard #2707 begins shift
  [1518-09-01 00:04] Guard #2707 begins shift
  [1518-09-23 00:02] Guard #3499 begins shift
  [1518-05-19 00:55] wakes up
  [1518-06-20 00:09] falls asleep
  [1518-04-20 23:57] Guard #1231 begins shift
  [1518-06-05 00:04] Guard #3371 begins shift
  [1518-10-26 00:48] wakes up
  [1518-02-11 00:28] wakes up
  [1518-05-06 00:57] wakes up
  [1518-04-10 00:36] falls asleep
  [1518-04-28 00:47] falls asleep
  [1518-09-01 00:51] wakes up
  [1518-02-22 00:20] falls asleep
  [1518-03-23 23:56] Guard #1297 begins shift
  [1518-03-15 23:46] Guard #2729 begins shift
  [1518-07-16 00:49] wakes up
  [1518-07-24 23:57] Guard #1553 begins shift
  [1518-09-03 00:40] falls asleep
  [1518-04-10 00:45] wakes up
  [1518-03-19 00:00] Guard #1901 begins shift
  [1518-07-08 00:41] wakes up
  [1518-08-27 00:43] falls asleep
  [1518-11-19 00:01] Guard #1231 begins shift
  [1518-05-17 00:49] wakes up
  [1518-02-11 00:52] wakes up
  [1518-10-09 00:33] falls asleep
  [1518-04-30 00:04] falls asleep
  [1518-07-18 00:41] wakes up
  [1518-06-05 23:59] Guard #2539 begins shift
  [1518-10-04 00:44] wakes up
  [1518-03-26 00:14] wakes up
  [1518-09-12 00:27] falls asleep
  [1518-10-26 00:03] Guard #1901 begins shift
  [1518-06-12 00:28] falls asleep
  [1518-03-30 00:48] wakes up
  [1518-03-28 00:43] falls asleep
  [1518-11-03 00:26] wakes up
  [1518-05-05 23:52] Guard #2129 begins shift
  [1518-03-21 23:59] Guard #1193 begins shift
  [1518-09-22 00:23] falls asleep
  [1518-06-09 00:44] falls asleep
  [1518-07-21 00:09] falls asleep
  [1518-05-16 00:43] falls asleep
  [1518-05-01 00:51] wakes up
  [1518-03-09 00:01] Guard #2729 begins shift
  [1518-07-07 23:56] Guard #419 begins shift
  [1518-05-10 00:03] Guard #2539 begins shift
  [1518-08-19 23:57] Guard #1171 begins shift
  [1518-06-17 00:16] falls asleep
  [1518-09-19 00:20] falls asleep
  [1518-06-26 00:49] falls asleep
  [1518-03-27 00:37] falls asleep
  [1518-07-16 00:41] falls asleep
  [1518-02-21 00:11] falls asleep
  [1518-08-06 00:01] Guard #3119 begins shift
  [1518-09-21 23:50] Guard #1171 begins shift
  [1518-10-03 00:49] wakes up
  [1518-09-07 00:30] wakes up
  [1518-04-07 00:41] falls asleep
  [1518-02-16 00:35] wakes up
  [1518-05-20 00:34] wakes up
  [1518-10-06 00:36] falls asleep
  [1518-02-23 00:02] Guard #1901 begins shift
  [1518-06-10 00:02] falls asleep
  [1518-06-27 00:29] falls asleep
  [1518-09-18 00:17] falls asleep
  [1518-02-24 23:47] Guard #419 begins shift
  [1518-04-10 00:39] wakes up
  [1518-03-22 00:57] wakes up
  [1518-09-03 00:46] falls asleep
  [1518-02-13 00:11] falls asleep
  [1518-07-05 00:02] Guard #1553 begins shift
  [1518-03-07 00:16] falls asleep
  [1518-02-25 00:49] wakes up
  [1518-09-03 00:47] wakes up
  [1518-11-02 00:02] Guard #2729 begins shift
  [1518-06-04 00:40] falls asleep
  [1518-05-03 00:55] falls asleep
  [1518-09-26 00:58] wakes up
  [1518-11-07 00:58] wakes up
  [1518-09-30 00:55] wakes up
  [1518-02-27 00:22] falls asleep
  [1518-10-12 00:35] falls asleep
  [1518-06-21 00:01] Guard #1033 begins shift
  [1518-09-05 00:59] wakes up
  [1518-07-19 00:40] wakes up
  [1518-04-05 00:42] wakes up
  [1518-11-22 23:56] Guard #2447 begins shift
  [1518-05-22 00:47] wakes up
  [1518-05-24 00:01] falls asleep
  [1518-05-23 00:15] falls asleep
  [1518-06-17 00:50] wakes up
  [1518-06-26 00:34] wakes up
  [1518-10-10 00:05] falls asleep
  [1518-06-19 00:58] wakes up
  [1518-05-13 00:18] falls asleep
  [1518-09-23 00:17] falls asleep
  [1518-09-20 23:57] Guard #1901 begins shift
  [1518-08-07 23:58] Guard #3119 begins shift
  [1518-05-21 00:59] wakes up
  [1518-06-18 00:31] falls asleep
  [1518-05-24 00:25] falls asleep
  [1518-06-09 00:26] wakes up
  [1518-04-22 00:34] wakes up
  [1518-09-05 00:00] Guard #2539 begins shift
  [1518-05-14 00:50] wakes up
  [1518-11-09 00:56] wakes up
  [1518-10-26 00:26] falls asleep
  [1518-02-15 00:14] falls asleep
  [1518-07-13 00:44] falls asleep
  [1518-03-03 23:59] Guard #2447 begins shift
  [1518-07-27 23:57] Guard #1231 begins shift
  [1518-02-23 00:56] wakes up
  [1518-02-20 00:02] Guard #1231 begins shift
  [1518-10-10 23:56] Guard #1901 begins shift
  [1518-10-24 23:59] Guard #2383 begins shift
  [1518-03-19 00:51] falls asleep
  [1518-10-10 00:41] wakes up
  [1518-03-16 00:00] falls asleep
  [1518-08-13 00:24] falls asleep
  [1518-11-12 00:28] falls asleep
  [1518-09-15 00:54] wakes up
  [1518-07-11 00:34] falls asleep
  [1518-02-15 00:00] Guard #1033 begins shift
  [1518-05-23 23:51] Guard #1297 begins shift
  [1518-05-25 00:01] Guard #1231 begins shift
  [1518-04-14 00:42] wakes up
  [1518-06-11 00:38] wakes up
  [1518-02-10 23:47] Guard #1033 begins shift
  [1518-07-10 00:58] wakes up
  [1518-05-15 00:09] falls asleep
  [1518-07-20 00:56] wakes up
  [1518-08-01 00:04] Guard #2729 begins shift
  [1518-03-24 00:52] wakes up
  [1518-04-02 00:03] Guard #2447 begins shift
  [1518-09-06 00:00] Guard #1193 begins shift
  [1518-03-04 00:20] falls asleep
  [1518-08-01 00:39] falls asleep
  [1518-04-26 00:00] falls asleep
  [1518-08-20 00:48] falls asleep
  [1518-06-12 00:57] wakes up
  [1518-07-16 00:01] Guard #1021 begins shift
  [1518-08-21 00:00] Guard #3119 begins shift
  [1518-03-07 00:53] wakes up
  [1518-07-21 00:49] wakes up
  [1518-06-29 00:47] wakes up
  [1518-10-31 00:14] falls asleep
  [1518-05-08 23:58] Guard #1993 begins shift
  [1518-09-19 23:59] Guard #1297 begins shift
  [1518-08-23 23:48] Guard #419 begins shift
  [1518-06-29 00:21] wakes up
  [1518-04-17 23:57] Guard #3371 begins shift
  [1518-11-20 00:08] falls asleep
  [1518-04-05 00:23] falls asleep
  [1518-06-22 00:03] Guard #1901 begins shift
  [1518-09-04 00:39] falls asleep
  [1518-03-16 00:02] wakes up
  [1518-11-19 00:50] wakes up
  [1518-06-12 23:50] Guard #1033 begins shift
  [1518-10-16 00:00] Guard #1021 begins shift
  [1518-03-11 00:03] Guard #1231 begins shift
  [1518-03-16 23:46] Guard #2707 begins shift
  [1518-05-25 00:11] falls asleep
  [1518-04-04 23:57] Guard #1021 begins shift
  [1518-05-07 00:42] falls asleep
  [1518-05-30 00:28] wakes up
  [1518-10-07 00:01] Guard #283 begins shift
  [1518-09-28 23:58] Guard #1901 begins shift
  [1518-11-18 00:49] wakes up
  [1518-07-15 00:13] falls asleep
  [1518-09-12 00:01] Guard #2539 begins shift
  [1518-05-04 00:38] falls asleep
  [1518-04-11 00:33] falls asleep
  [1518-08-05 00:51] falls asleep
  [1518-04-18 23:59] Guard #2729 begins shift
  [1518-03-26 00:05] falls asleep
  [1518-10-29 00:24] wakes up
  [1518-07-02 00:53] wakes up
  [1518-05-17 23:56] Guard #1297 begins shift
  [1518-05-25 00:20] wakes up
  [1518-10-15 00:49] falls asleep
  [1518-11-02 00:41] falls asleep
  [1518-08-01 00:48] wakes up
  [1518-04-29 23:50] Guard #3119 begins shift
  [1518-11-12 00:07] falls asleep
  [1518-09-01 00:27] wakes up
  [1518-05-17 00:03] Guard #3119 begins shift
  [1518-04-08 00:02] Guard #1901 begins shift
  [1518-06-02 00:49] falls asleep
  [1518-05-08 00:03] falls asleep
  [1518-11-09 00:40] falls asleep
  [1518-10-08 00:04] falls asleep
  [1518-10-19 00:58] wakes up
  [1518-09-04 00:18] wakes up
  [1518-10-26 00:52] wakes up
  [1518-03-13 00:19] wakes up
  [1518-06-06 00:47] wakes up
  [1518-08-09 00:25] wakes up
  [1518-10-23 00:31] wakes up
  [1518-10-02 00:18] falls asleep
  [1518-03-27 00:17] falls asleep
  [1518-07-08 00:11] falls asleep
  [1518-05-11 00:45] wakes up
  [1518-07-10 23:51] Guard #1171 begins shift
  [1518-03-04 00:43] falls asleep
  [1518-04-10 00:43] falls asleep
  [1518-05-15 00:15] wakes up
  [1518-09-08 00:51] wakes up
  [1518-11-10 00:22] falls asleep
  [1518-09-09 00:30] falls asleep
  [1518-07-16 00:22] wakes up
  [1518-10-30 23:58] Guard #3371 begins shift
  [1518-04-27 00:48] falls asleep
  [1518-03-28 00:38] wakes up
  [1518-05-04 00:29] wakes up
  [1518-04-28 23:59] Guard #1021 begins shift
  """

let value = calculate(input: input)
print(value)
// Correct Answer: 131469

class SequenceTests: XCTestCase {
  func testInput1() {
    let input = """
      [1518-11-01 00:00] Guard #10 begins shift
      [1518-11-01 00:05] falls asleep
      [1518-11-01 00:25] wakes up
      [1518-11-01 00:30] falls asleep
      [1518-11-01 00:55] wakes up
      [1518-11-01 23:58] Guard #99 begins shift
      [1518-11-02 00:40] falls asleep
      [1518-11-02 00:50] wakes up
      [1518-11-03 00:05] Guard #10 begins shift
      [1518-11-03 00:24] falls asleep
      [1518-11-03 00:29] wakes up
      [1518-11-04 00:02] Guard #99 begins shift
      [1518-11-04 00:36] falls asleep
      [1518-11-04 00:46] wakes up
      [1518-11-05 00:03] Guard #99 begins shift
      [1518-11-05 00:45] falls asleep
      [1518-11-05 00:55] wakes up
      """
    let value = calculate(input: input)
    XCTAssertEqual(value, 240)
  }

}

SequenceTests.defaultTestSuite.run()
