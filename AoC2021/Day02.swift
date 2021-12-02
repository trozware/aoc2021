//  Day02.swift - AoC 2021

import Foundation

func day02(testData: [String], realData: [String]) {
  let expectedTestResults = [150, 900]

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
    var horiz = 0
    var depth = 0

    for instruction in data {
      let parts = instruction.components(separatedBy: .whitespaces)
      if parts.count != 2 { continue }
      let change = Int(parts[1]) ?? 0

      switch parts[0] {
      case "forward":
        horiz += change
      case "up":
        depth -= change
      case "down":
        depth += change
      default:
        break
      }
    }

    let result1 = horiz * depth

    horiz = 0
    depth = 0
    var aim = 0

    for instruction in data {
      let parts = instruction.components(separatedBy: .whitespaces)
      if parts.count != 2 { continue }
      let change = Int(parts[1]) ?? 0

      switch parts[0] {
      case "forward":
        horiz += change
        depth += change * aim
      case "up":
        aim -= change
      case "down":
        aim += change
      default:
        break
      }
    }

    let result2 = horiz * depth

    return [result1, result2]
  }
}
