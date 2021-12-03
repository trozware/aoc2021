//  Day03.swift - AoC 2021

import Foundation

func day03(testData: [String], realData: [String]) {
  let expectedTestResults = [198, 230]
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
    let (gamma, epsilon) = getGammaEpsilon(data)

    let g = Int(gamma, radix: 2)!
    let e = Int(epsilon, radix: 2)!
    let power = g * e

    // Part 2

    var oxygen = ""
    var co2 = ""

    var validNumbers = data

    for index in 0 ..< data[0].count {
      let (newGamma, _) = getGammaEpsilon(validNumbers)

      validNumbers = validNumbers.filter {
        $0[index] == newGamma[index]
      }

      if validNumbers.count == 1 {
        oxygen = validNumbers[0]
        break
      }
    }

    validNumbers = data

    for index in 0 ..< data[0].count {
      let (_, newEpsilon) = getGammaEpsilon(validNumbers)
      
      validNumbers = validNumbers.filter {
        $0[index] == newEpsilon[index]
      }

      if validNumbers.count == 1 {
        co2 = validNumbers[0]
        break
      }
    }

    let o = Int(oxygen, radix: 2)!
    let c = Int(co2, radix: 2)!
    let life = o * c

    return [power, life]
  }

  func getGammaEpsilon(_ data: [String]) -> (String, String) {
    var gamma = ""
    var epsilon = ""

    var columnTotals = Array(repeating: 0, count: data[0].count)

    for line in data {
      for index in 0 ..< line.count {
        let value = Int(line[index]) ?? 0
        columnTotals[index] += value
      }
    }

    for ones in columnTotals {
      let zeroes = data.count - ones
      if ones >= zeroes {
        gamma += "1"
        epsilon += "0"
      } else {
        gamma += "0"
        epsilon += "1"
      }
    }

    return (gamma, epsilon)
  }
}
