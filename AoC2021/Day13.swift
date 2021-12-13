//  Day13.swift - AoC 2021

import Foundation

func day13(testData: [String], realData: [String]) {
  let expectedTestResults = [17, 2]

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
    var points: [Point13] = []
    var folds: [String] = []

    for line in data {
      if line.isEmpty { continue }
      if line.contains("fold") {
        folds.append(line)
      } else {
        points.append(Point13(line: line))
      }
    }

    points = fold(instruction: folds[0], points: points)

    let result1 = points.count
    print("Result 1:", result1)

    for index in 1 ..< folds.count {
      points = fold(instruction: folds[index], points: points)
    }
    printGrid(points: points)

    // Result 2: read the letters in the console
    // AHPRPAUZ

    return [result1, 2]
  }

  func fold(instruction: String, points: [Point13]) -> [Point13] {
    //  e.g. fold along y=7

    let instructionInfo = instruction.replacingOccurrences(of: "fold along ", with: "")
    let instructionParts = instructionInfo.components(separatedBy: "=")
    let direction = instructionParts[0]
    let location = Int(instructionParts[1])!

    if direction == "y" {
      let newPoints = points.map { point -> Point13 in
        if point.y <= location {
          return point
        }
        let distFromFold = point.y - location
        let newY = location - distFromFold
        return Point13(x: point.x, y: newY)
      }
      return Array(Set(newPoints))
    } else if direction == "x" {
      let newPoints = points.map { point -> Point13 in
        if point.x <= location {
          return point
        }
        let distFromFold = point.x - location
        let newX = location - distFromFold
        return Point13(x: newX, y: point.y)
      }
      return Array(Set(newPoints))
    }

    return points
  }

  func printGrid(points: [Point13]) {
    let xs = points.map { $0.x }
    let ys = points.map { $0.y }
    let maxX = xs.max()!
    let maxY = ys.max()!

    let blankLine = Array(repeating: ".", count: maxX + 1)
    var grid = Array(repeating: blankLine, count: maxY + 1)

    for point in points {
      grid[point.y][point.x] = "#"
    }

    for line in grid {
      print(line.joined(separator: " "))
    }
    print()
  }
}

struct Point13: Hashable {
  var x: Int
  var y: Int

  func hash(into hasher: inout Hasher) {
    hasher.combine("\(x),\(y)")
  }
}

extension Point13 {
  init(line: String) {
    let coords = line.components(separatedBy: ",")
    x = Int(coords[0])!
    y = Int(coords[1])!
  }
}
