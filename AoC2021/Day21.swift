//  Day21.swift - AoC 2021

import Foundation

func day21(testData: [String], realData: [String]) {
  let expectedTestResults = [739785, 2]

  let testResults = runCode(p1start: 4, p2start: 8)
  if testResults != expectedTestResults {
    print("Error running tests")
    print("Expected:", expectedTestResults)
    print("Got:", testResults)
    return
  } else {
    print("Tests passed")
    print()
  }

  let realResults = runCode(p1start: 10, p2start: 2)
  print("Results:", realResults)

  func runCode(p1start: Int, p2start: Int) -> [Int] {
    var p1 = p1start
    var p2 = p2start
    var p1score = 0
    var p2score = 0

    var dieCounter = 1
    var playerTurn = 1
    var totalRolls = 0

    while true {
      let roll = getDiceRoll(dieCounter: &dieCounter)
      totalRolls += 3
      if playerTurn == 1 {
        p1 = advancePlayer(p1, by: roll)
        p1score += p1
        playerTurn = 2
        if p1score >= 1000 {
          break
        }
      } else {
        p2 = advancePlayer(p2, by: roll)
        p2score += p2
        playerTurn = 1
        if p2score >= 1000 {
          break
        }
      }
    }

    let result1 = min(p1score, p2score) * totalRolls

    // Part 2

    p1 = p1start
    p2 = p2start
    p1score = 0
    p2score = 0

    var universes: [(Int, Int, Int, Int)] = [(p1, p2, 0, 0)]
    var p1Wins: [(Int, Int, Int, Int)] = []
    var p2Wins: [(Int, Int, Int, Int)] = []

    while true {
      for universe in universes {
        var (startingP1, startingP2, p1score, p2score) = universe
        for d in 1 ... 3 {
          p1 = advancePlayer(startingP1, by: d)
          p1score += p1

          if p1score >= 21 {
            p1Wins.append((p1, startingP2, p1score, p2score))
            universes.append((p1, startingP2, -1, -1))
          } else {
            universes.append((p1, startingP2, p1score, p2score))
          }
        }
      }

      for universe in universes {
        var (startingP1, startingP2, p1score, p2score) = universe
        for d in 1 ... 3 {
          p2 = advancePlayer(startingP2, by: d)
          p2score += p2

          if p2score >= 21 {
            p2Wins.append((startingP1, p2, p1score, p2score))
            universes.append((startingP1, p2, -1, -1))
          } else {
            universes.append((startingP1, p2, p1score, p2score))
          }
        }
      }

      universes = universes.filter { _, _, s1, s2 in
        s1 > -1 && s2 > -1
      }

      print(universes.count)
    }

    for universe in universes {
      print(universe)
    }

    return [result1, 3]
  }

  func getDiceRoll(dieCounter: inout Int) -> Int {
    var total = 0
    for _ in 0 ..< 3 {
      total += dieCounter
      dieCounter += 1
      if dieCounter > 100 {
        dieCounter = 1
      }
    }
    return total
  }

  func advancePlayer(_ p: Int, by roll: Int) -> Int {
    var newP = p + roll
    while newP > 10 {
      newP -= 10
    }
    return newP
  }
}
