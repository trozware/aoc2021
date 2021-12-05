//  Day05.swift - AoC 2021

import Foundation

func day05(testData: [String], realData: [String]) {
  let expectedTestResults = [5, 12]

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
    var vents: [String: Int] = [:]
    var diagonals: [(Int, Int, Int, Int)] = []

    for line in data {
      let lineParts = line
        .replacingOccurrences(of: " -> ", with: ",")
        .components(separatedBy: ",")
      if lineParts.count != 4 { continue }

      let x1 = Int(lineParts[0]) ?? 0
      let y1 = Int(lineParts[1]) ?? 0
      let x2 = Int(lineParts[2]) ?? 0
      let y2 = Int(lineParts[3]) ?? 0

      if x1 == x2 {
        let startY = min(y1, y2)
        let endY = max(y1, y2)

        for y in startY ... endY {
          let ventId = "x\(x1)-y\(y)"
          if vents[ventId] != nil {
            vents[ventId]! += 1
          } else {
            vents[ventId] = 1
          }
        }
      } else if y1 == y2 {
        let startX = min(x1, x2)
        let endX = max(x1, x2)

        for x in startX ... endX {
          let ventId = "x\(x)-y\(y1)"
          if vents[ventId] != nil {
            vents[ventId]! += 1
          } else {
            vents[ventId] = 1
          }
        }
      } else if abs(x1 - x2) == abs(y1 - y2) {
        diagonals.append((x1, y1, x2, y2))
      }
    }

    var dangerousVents1 = 0
    for (_, count) in vents {
      if count >= 2 {
        dangerousVents1 += 1
      }
    }

    // Part 2

    for (x1, y1, x2, y2) in diagonals {
      let xChange = x1 > x2 ? -1 : 1
      let yChange = y1 > y2 ? -1 : 1

      var x = x1
      var y = y1

      while true {
        let ventId = "x\(x)-y\(y)"
        if vents[ventId] != nil {
          vents[ventId]! += 1
        } else {
          vents[ventId] = 1
        }

        if x == x2 {
          break
        }

        x += xChange
        y += yChange
      }
    }

    var dangerousVents2 = 0
    for (_, count) in vents {
      if count >= 2 {
        dangerousVents2 += 1
      }
    }

    return [dangerousVents1, dangerousVents2]
  }
}
