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
    let storedPolymer = polymer

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

    polymer = storedPolymer

    var pairCounts: [String: Int] = [:]
    for index in 0 ..< polymer.count - 1 {
      let pair = polymer[index] + polymer[index + 1]
      if pairCounts[pair] != nil {
        pairCounts[pair]! += 1
      } else {
        pairCounts[pair] = 1
      }
    }

    for _ in 0 ..< 40 {
      var newCounts: [String: Int] = [:]
      for (pair, count) in pairCounts {
        let insertion = rules[pair]!
        let newPair1 = pair[0] + insertion
        let newPair2 = insertion + pair[1]
        if newCounts[newPair1] != nil {
          newCounts[newPair1]! += count
        } else {
          newCounts[newPair1] = count
        }
        if newCounts[newPair2] != nil {
          newCounts[newPair2]! += count
        } else {
          newCounts[newPair2] = count
        }
      }
      pairCounts = newCounts
    }

    var counts: [String: Int] = [:]
    for (pair, count) in pairCounts {
      if counts[pair[0]] != nil {
        counts[pair[0]]! += count
      } else {
        counts[pair[0]] = count
      }
      if counts[pair[1]] != nil {
        counts[pair[1]]! += count
      } else {
        counts[pair[1]] = count
      }
    }

    for (letter, count) in counts {
      counts[letter] = count / 2
      if letter == storedPolymer.first {
        counts[letter]! += 1
      } else if letter == storedPolymer.last {
        counts[letter]! += 1
      }
    }

    let (maxC, minC) = findMaxMin(counts: counts)
    let result2 = maxC - minC
    print("Result 2:", result2)

    return [result1, result2]
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

    return findMaxMin(counts: counts)
  }

  func findMaxMin(counts: [String: Int]) -> (Int, Int) {
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
