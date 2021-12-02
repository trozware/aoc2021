//  Day01.swift - AoC 2021  

import Foundation

func day01() {
  let dayNum = 1

  // let data = openTestFile(dayNum: dayNum, separator: "\n")
  let data = openDataFile(dayNum: dayNum, separator: "\n")

  let depths = convertToIntegers(data)

  var lastDepth = depths[0]
  var increaseCount = 0

  for depth in depths {
    if depth > lastDepth {
      increaseCount += 1
    }
    lastDepth = depth
  }

  print("Part 1: \(increaseCount)")     // 1154

  var depthGroups: [Int] = []
  for index in 0 ..< depths.count - 2 {
    let group = depths[index] + depths[index + 1] + depths[index + 2]
    depthGroups.append(group)
  }

  lastDepth = depthGroups[0]
  increaseCount = 0

  for depth in depthGroups {
    if depth > lastDepth {
      increaseCount += 1
    }
    lastDepth = depth
  }

  print("Part 2: \(increaseCount)")     // 1127
}
