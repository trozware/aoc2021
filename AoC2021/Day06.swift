//  Day06.swift - AoC 2021

import Foundation

func day06(testData: [String], realData: [String]) {
  let expectedTestResults = [5934, 26984457539]

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
    var fishes = convertToIntegers(data[0].components(separatedBy: ","))

    var day = 0

    while day < 80 {
      var newFishCount = 0

      for index in 0 ..< fishes.count {
        var fish = fishes[index]
        fish -= 1

        if fish < 0 {
          fishes[index] = 6
          newFishCount += 1
        } else {
          fishes[index] = fish
        }
      }

      let newFishes = Array(repeating: 8, count: newFishCount)
      fishes += newFishes

      day += 1
    }
    let result1 = fishes.count

    var fishCounts = [0:0, 1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0]
    for fish in fishes {
      fishCounts[fish]! += 1
    }

    while day < 256 {
      var newFishCounts = [0:0, 1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0]
      let newCount = fishCounts[0]!

      for age in 0 ..< 8 {
        newFishCounts[age] = fishCounts[age + 1]
      }
      newFishCounts[8] = newCount
      newFishCounts[6]! += newCount

      fishCounts = newFishCounts
      day += 1
    }

    var result2 = 0
    for (_, count) in fishCounts {
      result2 += count
    }

    return [result1, result2]
  }
}
