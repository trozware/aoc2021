//  Day10.swift - AoC 2021

import Foundation

func day10(testData: [String], realData: [String]) {
  let expectedTestResults = [26397, 288957]

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
    var corrupts: [String] = []
    var firstCorrupt: [String] = []
    var incompletes: [String] = []
    var partials: [String] = []

    var openBrackets = ""
    let openForClose = [")": "(", "]": "[", "}": "{", ">": "<"]
    let scores = [")": 3, "]": 57, "}": 1197, ">": 25137]

    // let test = "[({(<(())[]>[[{[]{<()<>>"  // incomplete
    // let test = "{([(<{}[<>[]}>{[]{[(<()>" // corrupt

    let openings = "([{<"
    let closings = ")]}>"

    for line in data {
      var corrupt = false
      for char in line {
        let stringC = String(char)
        if openings.contains(stringC) {
          openBrackets += stringC
        } else if closings.contains(stringC) {
          if openBrackets.hasSuffix(openForClose[stringC]!) {
            openBrackets = String(openBrackets.prefix(openBrackets.count - 1))
          } else {
            corrupts.append(line)
            firstCorrupt.append(stringC)
            corrupt = true
            break
          }
        }
      }

      if !corrupt {
        incompletes.append(line)
        partials.append(openBrackets)
      }

      openBrackets = ""
    }

    var result1 = 0
    for corrupt in firstCorrupt {
      result1 += scores[corrupt]!
    }

    let closeForOpen = ["(": ")", "[": "]", "{": "}", "<": ">"]
    let scores2 = [")": 1, "]": 2, "}": 3, ">": 4]
    var incompleteScores: [Int] = []

    for p in partials {
      let rev = String(p.reversed())
      let closers = rev.map { closeForOpen[String($0)]! }

      var score = 0
      for c in closers {
        score *= 5
        score += scores2[c]!
      }
      incompleteScores.append(score)
    }

    incompleteScores.sort()
    let mid = (incompleteScores.count - 1) / 2
    let result2 = incompleteScores[mid]

    return [result1, result2]
  }
}
