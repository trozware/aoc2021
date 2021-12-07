//  Day07.swift - AoC 2021

import Foundation

func day07(testData: [String], realData: [String]) {
  let expectedTestResults = [37, 168]
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
    let crabs = convertToIntegers(data[0].components(separatedBy: ","))
    let highestNum = crabs.max()!

    var minFuel = Int.max
    var bestPosition = -1

    for pos in 0 ... highestNum {
      var fuel = 0
      for crab in crabs {
        fuel += abs(crab - pos)
      }

      if fuel < minFuel {
        bestPosition = pos
        minFuel = fuel
      }
    }

    print(bestPosition, minFuel)
    let result1 = minFuel

    minFuel = Int.max
    bestPosition = -1

    var moveCosts: [Int: Int] = [0:0]
    for moves in 1 ... highestNum {
      moveCosts[moves] = sumOfNumbers(to: moves)
    }

    for pos in 0 ..< crabs.max()! {
      var fuel = 0
      for crab in crabs {
        let moves = abs(crab - pos)
        fuel += moveCosts[moves]!
      }

      if fuel < minFuel {
        bestPosition = pos
        minFuel = fuel
      }
    }

    print(bestPosition, minFuel)
    let result2 = minFuel

    return [result1, result2]
  }

  func sumOfNumbers(to num: Int) -> Int {
    if num == 1 {
      return num
    }
    return num + sumOfNumbers(to: num - 1)
  }
}
