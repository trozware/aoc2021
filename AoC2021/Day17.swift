//  Day 17.swift - AoC 2021

import Foundation

func day17(testData: [String], realData: [String]) {
  let expectedTestResults = [45, 112]
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
    let target = data[0].components(separatedBy: ",")
    let lowX =  Int(target[0])!
    let highX = Int(target[1])!
    let lowY =  Int(target[2])!
    let highY = Int(target[3])!

    var overallMaxHeight = 0
    var totalHits = 0

    for startXVel in 0 ..< 500 {
      for startYVel in -500 ..< 500 {
        var xVel = startXVel
        var yVel = startYVel

        var x = 0
        var y = 0
        var maxHeight = 0

        while true {
          (x, y, xVel, yVel) = changePosition(x: x, y: y, xVelocity: xVel, yVelocity: yVel)
          if y > maxHeight {
            maxHeight = y
          }
          if pointIsInTarget(x: x, y: y, lowX: lowX, highX: highX, lowY: lowY, highY: highY) {
            if maxHeight > overallMaxHeight {
              overallMaxHeight = maxHeight
            }
            totalHits += 1
            break
          }
          if pointIsPastTarget(x: x, y: y, lowX: lowX, highX: highX, lowY: lowY, highY: highY) {
            break
          }
        }
      }
    }

    print("Result 1:", overallMaxHeight)
    print("Result 2:", totalHits)

    return [overallMaxHeight, totalHits]
  }

  func changePosition(x: Int, y: Int, xVelocity: Int, yVelocity: Int) -> (Int, Int, Int, Int) {
    let newX = x + xVelocity
    let newY = y + yVelocity

    var newXVelocity = 0
    if xVelocity > 0 {
      newXVelocity = xVelocity - 1
    } else if xVelocity < 0 {
      newXVelocity = xVelocity + 1
    }

    let newYVelocity = yVelocity - 1

    return (newX, newY, newXVelocity, newYVelocity)
  }

  func pointIsInTarget(x: Int, y: Int, lowX: Int, highX: Int, lowY: Int, highY: Int) -> Bool {
    if x < lowX {
      return false
    } else if x > highX {
      return false
    } else if y < lowY {
      return false
    } else if y > highY {
      return false
    }
    return true
  }

  func pointIsPastTarget(x: Int, y: Int, lowX: Int, highX: Int, lowY: Int, highY: Int) -> Bool {
    if x > highX || y < lowY {
      return true
    }
    return false
  }
}
