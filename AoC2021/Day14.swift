//  Day14.swift - AoC 2021

import Foundation

func day14(testData: [String], realData: [String]) {
  let expectedTestResults = [1588, 2188189693529]

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
    var polymer = data[0].map { String($0) }

    var rules: [String: String] = [:]
    for index in 2 ..< data.count {
      let parts = data[index].components(separatedBy: " -> ")
      if parts.count != 2 { continue }
      rules[parts[0]] = parts[1]
    }

//    print(polymer)
//    print(rules)

    for _ in 0 ..< 10 {
      var additions: [String] = []

      for index in 0 ..< polymer.count - 1 {
        let pair = polymer[index] + polymer[index + 1]
        let insertion = rules[pair]!
        additions.append(insertion)
      }

      let combined = zip(polymer, additions).flatMap{ [$0.0, $0.1] }
      polymer = combined + [polymer.last!]
      // print(polymer.count)
    }

    let (maxCount, minCount) = countElements(polymer: polymer)
    let result1 = maxCount - minCount
    print("Result 1:", result1)

    

//    for i in 10 ..< 20 {
//      // print("Loop", i + 1)
//
//      var additions: [String] = []
//
//      for index in 0 ..< polymer.count - 1 {
//        let pair = polymer[index] + polymer[index + 1]
//        let insertion = rules[pair]!
//        additions.append(insertion)
//      }
//
//      let combined = zip(polymer, additions).flatMap{ [$0.0, $0.1] }
//      polymer = combined + [polymer.last!]
//      // print(polymer.count)
//
//    }
//
//    let (maxCount2, minCount2) = countElements(polymer: polymer)
//    let result2 = maxCount2 - minCount2
//    print("Result 2:", result2)

    return [result1, 3]
  }

  func countElements(polymer: [String]) -> (Int, Int) {
    var counts: [String: Int] = [:]

    for p in polymer {
      if counts[p] == nil {
        counts[p] = 1
      } else {
        counts[p]! += 1
      }
    }
//    print(counts)

    var maxCount = 0
    var minCount = Int.max

    for (_, count) in counts {
      if count < minCount {
        minCount = count
      }
      if count > maxCount {
        maxCount = count
      }
    }

    return (maxCount, minCount)
  }
}

// test - always H & B, detected after 2 rounds
