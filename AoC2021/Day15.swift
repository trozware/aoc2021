//  Day15.swift - AoC 2021

import Foundation

func day15(testData: [String], realData: [String]) {
  let expectedTestResults = [40, 2]

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
    var points: [Point15] = []

    for rowNum in 0 ..< data.count {
      for colNum in 0 ..< data[0].count {
        let cost = Int(data[rowNum][colNum])!
        let newPoint = Point15(id: "\(rowNum),\(colNum)", row: rowNum, col: colNum, cost: cost)
        points.append(newPoint)
      }
    }

    var neighbors: [String: [Point15]] = [:]
    for point in points {
      let nexts = assignNeighbors(point: point, allPoints: points)
      neighbors[point.id] = nexts
    }

//
//    var newPoints: [Point15] = []
//    for index in 0 ..< points.count {
//      var newPoint = points[index]
//      newPoint.neighbors = assignNeighbors(point: points[index], allPoints: points)
//      newPoints.append(newPoint)
//    }
//    points = newPoints

    let startPoint = points.first { $0.row == 0 && $0.col == 0 }!
    let endPoint = points.first { $0.row == data[0].count - 1 && $0.col == data.count - 1 }!

//    print(startPoint)
//    print(endPoint)
//    print()
//    for p in points {
//      print(p)
//    }

    var partialPaths = [[startPoint]]
    var completePaths: [[Point15]] = []

    while !partialPaths.isEmpty {
      let path = partialPaths[0]
      partialPaths = Array(partialPaths.dropFirst())

      let lastPoint = path.last!
      let nexts = neighbors[lastPoint.id]!
      let nextPaths = nexts.map { path + [$0] }
      var minCost = Int.max
      var minPath: [Point15]? = nil
      for next in nextPaths {
        let cost = costOfPath(next)
        if cost < minCost {
          minCost = cost
          minPath = next
        }
      }
      if let minPath = minPath {
        if minPath.last! == endPoint {
          completePaths.append(minPath)
          print("complete", completePaths.count)
        } else {
          partialPaths.append(minPath)
          print("partial", partialPaths.count)
        }
      }

//      for n in neighbors[lastPoint.id]! {
//        let newPath = path + [n]
//        if n == endPoint {
//          completePaths.append(newPath)
//          print("complete", completePaths.count)
//        } else if !path.contains(n) {
//          // printPath(newPath)
//          partialPaths.append(newPath)
//          print("partial", partialPaths.count)
//        }
//      }
    }

    print(completePaths.count)
    printPath(completePaths[0])


    let risks = completePaths.map { costOfPath($0) }
    let lowestRisk = risks.min()! - startPoint.cost

    print(lowestRisk)

    return [1, 2]
  }

  func printPath(_ path: [Point15]) {
    let ids = path.map { $0.id }
    print(ids.joined(separator: " - "))
  }

  func assignNeighbors(point: Point15, allPoints: [Point15]) -> [Point15] {
//    let pointAbove = allPoints.first {
//      $0.row == point.row - 1 && $0.col == point.col
//    }

    let pointBelow = allPoints.first {
      $0.row == point.row + 1 && $0.col == point.col
    }

//    let pointLeft = allPoints.first {
//      $0.row == point.row && $0.col == point.col - 1
//    }

    let pointRight = allPoints.first {
      $0.row == point.row && $0.col == point.col + 1
    }

    let neighbours = [pointBelow, pointRight].compactMap { $0 }
    return neighbours
  }

  func costOfPath(_ path: [Point15]) -> Int {
    let totalCost = path.reduce(0) { (cumulativeTotal, nextPoint) in
      return cumulativeTotal + nextPoint.cost
    }
    return totalCost
  }
}

struct Point15: CustomStringConvertible, Equatable {
  let id: String
  let row: Int
  let col: Int
  let cost: Int
//  var neighbors: [Point15] = []

  var description: String {
    return "row: \(row), col: \(col), cost: \(cost)"
    //, neighbors: \(neighbors.count)"
  }
}
