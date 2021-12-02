//  Day14.swift - AoC 2021

import Foundation

func day14(testData: [String], realData: [String]) {
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

    return [1, 2]
  }
}
