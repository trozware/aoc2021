//  Day01.swift - AoC 2021  

import Foundation

func day01(testData: [String], realData: [String]) {
  let expectedTestResults = [7, 5]
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
    let depths = convertToIntegers(data)

    var lastDepth = depths[0]
    var increaseCount1 = 0

    for depth in depths {
      if depth > lastDepth {
        increaseCount1 += 1
      }
      lastDepth = depth
    }

    //  print("Part 1: \(increaseCount)")     // 1154

    var depthGroups: [Int] = []
    for index in 0 ..< depths.count - 2 {
      let group = depths[index] + depths[index + 1] + depths[index + 2]
      depthGroups.append(group)
    }

    lastDepth = depthGroups[0]
    var increaseCount2 = 0

    for depth in depthGroups {
      if depth > lastDepth {
        increaseCount2 += 1
      }
      lastDepth = depth
    }

    //  print("Part 2: \(increaseCount)")     // 1127
    return [increaseCount1, increaseCount2]
  }
}
