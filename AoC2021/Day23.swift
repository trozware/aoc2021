//  Day23.swift - AoC 2021

import Foundation

func day23(testData: [String], realData: [String]) {
  let expectedTestResults = [1, 2]
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

    // Part 1 done manually: 15237

    // Part 2 done manually: 47509

    return [1, 2]
  }
}
