//  Day08.swift - AoC 2021

import Foundation

func day08(testData: [String], realData: [String]) {
  let expectedTestResults = [26, 61229]

  let testResults = runCode(data: testData)
  if testResults != expectedTestResults {
    print("Error running tests")
    print("Expected:", expectedTestResults)
    print("Got:", testResults)
    return
  } else {
    print("Tests passed")
    print()
  }

  let realResults = runCode(data: realData)
  print("Results:", realResults)

  func runCode(data: [String]) -> [Int] {
    // 2 segments = 1
    // 3 segments = 7
    // 4 segments = 4
    // 5 segments = 2, 3, 5
    // 6 segments = 0, 6, 9
    // 7 segments = 8

    var counts = [1: 0, 4: 0, 7: 0, 8: 0]

    for line in data {
      let (_, outputs) = formatInput(lineData: line)

      for output in outputs {
        if output.count == 2 {
          counts[1]! += 1
        } else if output.count == 3 {
          counts[7]! += 1
        } else if output.count == 4 {
          counts[4]! += 1
        } else if output.count == 7 {
          counts[8]! += 1
        }
      }
    }

    var result1 = 0
    for (_, value) in counts {
      result1 += value
    }

    // let testData = ["acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"]

    var total = 0

    for line in data {
      let (patterns, outputs) = formatInput(lineData: line)

      let codes = analysePatterns(patterns)

      var result = ""
      for output in outputs {
        for (code, num) in codes {
          if lettersAreSame(code, output) {
            result += num
            break
          }
        }
      }

      total += Int(result) ?? 0
    }

    return [result1, total]
  }

  func formatInput(lineData: String) -> ([String], [String]){
    let parts = lineData.components(separatedBy: "|")
    let patterns = parts[0]
      .trimmingCharacters(in: .whitespaces)
      .components(separatedBy: .whitespaces)
    let outputs = parts[1]
      .trimmingCharacters(in: .whitespaces)
      .components(separatedBy: .whitespaces)
    return (patterns, outputs)
  }

  func analysePatterns(_ patterns: [String]) -> [String: String] {
    // 2 segments is TOP RIGHT & BOTTOM RIGHT
    // diff between 2 segments & 3 segments = TOP
    // 2 diffs between 4 segments & 2 segments = TOP LEFT & MID
    // unused 2 are BOTTOM & BOTTOM LEFT
    // 5 segments have 3 letters in common: TOP, MID, BOTTOM
    // We have TOP and 2 possibilites for MID, so can get MID & BOTTOM & TOP LEFT & BOTTOM LEFT
    // 6 segments:
    //    9 doesn't have BOTTOM LEFT
    //    0 has both the 2 segments
    //    6 is the other and has BOTTOM RIGHT, so can find TOP RIGHT
    // 5 segments:
    //    5 has TOP LEFT
    //    2 has BOTTOM LEFT
    //    3 is the other

    var segments = ["TOP": "", "TOP LEFT": "", "TOP RIGHT": "",
                    "MID": "", "BOTTOM LEFT": "", "BOTTOM RIGHT": "", "BOTTOM": ""]

    let seg2 = patterns.first { $0.count == 2 }!
    let seg3 = patterns.first { $0.count == 3 }!
    let seg4 = patterns.first { $0.count == 4 }!
    let seg7 = patterns.first { $0.count == 7 }!

    let topRightOrBottomRight = seg2

    let top = diffLetters(seg3, seg2)
    segments["TOP"] = top

    let topLeftOrMid = diffLetters(seg4, seg2)

    let usedSoFar = top + topRightOrBottomRight + topLeftOrMid
    let bottomOrBottomLeft = diffLetters(seg7, usedSoFar)

    let seg5s = patterns.filter { $0.count == 5 }
    let common5s = commonLetters(strs: seg5s)

    let midOrBottom = common5s.replacingOccurrences(of: top, with: "")
    for letter in topLeftOrMid {
      if midOrBottom.contains(letter) {
        let mid = String(letter)
        let bottom = midOrBottom.replacingOccurrences(of: mid, with: "")
        segments["MID"] = mid
        segments["BOTTOM"] = bottom
        segments["TOP LEFT"] = topLeftOrMid.replacingOccurrences(of: mid, with: "")
        segments["BOTTOM LEFT"] = bottomOrBottomLeft.replacingOccurrences(of: bottom, with: "")
        break
      }
    }

    // 6 segs: 0, 6, 9
    let seg6s = patterns.filter { $0.count == 6 }
    let num9 = seg6s.first { !$0.contains(segments["BOTTOM LEFT"]!) }!
    let num0 = seg6s.first { $0 != num9 && $0.contains(topRightOrBottomRight[0]) && $0.contains(topRightOrBottomRight[1]) }!
    let num6 = seg6s.first { $0 != num9 && $0 != num0 }!

    for letter in topRightOrBottomRight {
      if num6.contains(letter) {
        let br = String(letter)
        segments["BOTTOM RIGHT"] = br
        segments["TOP RIGHT"] = topRightOrBottomRight.replacingOccurrences(of: br, with: "")
      }
    }

    // 5 segs: 2, 3, 5
    let num5 = seg5s.first { $0.contains(segments["TOP LEFT"]!) }!
    let num2 = seg5s.first { $0 != num5 && $0.contains(segments["BOTTOM LEFT"]!) }!
    let num3 = seg5s.first { $0 != num5 && $0 != num2 }!

    let codes = [seg2: "1", seg3: "7", seg4: "4", seg7: "8", num9: "9",
                 num0: "0", num6: "6", num5: "5", num2: "2", num3: "3"]
    return codes
  }

  func diffLetters(_ str1: String, _ str2: String) -> String {
    let set1 = Set(str1)
    let set2 = Set(str2)
    let diff = str2.count > str1.count ? set2.subtracting(set1) : set1.subtracting(set2)
    return String(diff)
  }

  func commonLetters(strs: [String]) -> String {
    var set1 = Set(strs[0])

    for index in 1 ..< strs.count {
      let set2 = Set(strs[index])
      set1 = set1.intersection(set2)
    }

    return String(set1)
  }

  func lettersAreSame(_ str1: String, _ str2: String) -> Bool {
    let set1 = Set(str1)
    let set2 = Set(str2)
    let intersect = set1.intersection(set2)
    return intersect.count == set1.count && intersect.count == set2.count
  }
}
