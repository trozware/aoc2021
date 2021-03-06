//  Day15.swift - AoC 2021

import Foundation

func day15(testData: [String], realData: [String]) {
  let expectedTestResults = [40, 315]

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

    // Part 1

    var endPointId = points.first { $0.row == data[0].count - 1 && $0.col == data.count - 1 }!.id
    let lowestCost = findPathCost(points: points, endPointId: endPointId)
    // 739

    // Part 2 - takes about 17 hours

    let bigCave = expandCave(data: data)

    points = []

    for rowNum in 0 ..< bigCave.count {
      for colNum in 0 ..< bigCave[0].count {
        let cost = bigCave[rowNum][colNum]
        let newPoint = Point15(id: "\(rowNum),\(colNum)", row: rowNum, col: colNum, cost: cost)
        points.append(newPoint)
      }
    }

    endPointId = points.first { $0.row == bigCave[0].count - 1 && $0.col == bigCave.count - 1 }!.id
    let lowestCost2 = findPathCost(points: points, endPointId: endPointId)

    // Answer = 3040 - got using Python

    return [lowestCost, lowestCost2]
  }

  func findPathCost(points: [Point15], endPointId: String) -> Int {
    let startPoint = points.first { $0.row == 0 && $0.col == 0 }!
    startPoint.pathCost = 0

    var queue = points
    var lowestCost = Int.max
    var next = startPoint
    var costAssigned: [Point15] = []

  outerloop:
    while !queue.isEmpty {
      // queue = Array(queue.dropFirst())
      let index = queue.firstIndex(of: next)!
      queue.remove(at: index)

      let nextPoints = assignNeighbors(point: next, allPoints: queue)

      for p in nextPoints {
        let newPathCost = p.cost + next.pathCost
        if newPathCost < p.pathCost {
          p.pathCost = newPathCost
          costAssigned.append(p)

          if p.id == endPointId {
            lowestCost = p.pathCost
            print(p)
            break outerloop
          }
        }
      }

      //      queue.sort { a, b in
      //        a.pathCost < b.pathCost
      //      }

      // find next point to check
      costAssigned.sort { a, b in
        a.pathCost < b.pathCost
      }
      next = costAssigned.first!
      costAssigned = Array(costAssigned.dropFirst())
    }

    return lowestCost
  }

  func assignNeighbors(point: Point15, allPoints: [Point15]) -> [Point15] {
    let pointBelow = allPoints.first {
      $0.row == point.row + 1 && $0.col == point.col
    }

    let pointAbove = allPoints.first {
      $0.row == point.row - 1 && $0.col == point.col
    }

    let pointRight = allPoints.first {
      $0.row == point.row && $0.col == point.col + 1
    }

    let pointLeft = allPoints.first {
      $0.row == point.row && $0.col == point.col - 1
    }

    let neighbours = [pointBelow, pointAbove, pointRight, pointLeft].compactMap { $0 }
    return neighbours
  }

  func expandCave(data: [String]) -> [[Int]] {
    var points: [[Int]] = []
    let rowWidth = data[0].count

    for rowNum in 0 ..< data.count {
      points.append([])
      for colNum in 0 ..< rowWidth {
        let cost = Int(data[rowNum][colNum])!
        points[rowNum].append(cost)
      }
    }

    for _ in 1 ..< 5 {
      for rowNum in 0 ..< points.count {
        let rowStart = Array(points[rowNum].suffix(rowWidth))
        let rowData = rowStart.map { cost -> Int in
          var newCost = cost + 1
          if newCost > 9 { newCost = 1 }
          return newCost
        }
        points[rowNum] += rowData
      }
    }

    let requiredRows = points.count * 5
    var startRow = 0

    while points.count < requiredRows {
      let starter = points[startRow]
      let rowData = starter.map { cost -> Int in
        var newCost = cost + 1
        if newCost > 9 { newCost = 1 }
        return newCost
      }
      points.append(rowData)
      startRow += 1
    }

    return points
  }
}

class Point15: CustomStringConvertible, Identifiable, Hashable, Equatable {
  let id: String
  let row: Int
  let col: Int
  var cost: Int
  var pathCost: Int

  init(id: String, row: Int, col: Int, cost: Int, pathCost: Int = Int.max) {
    self.id = id
    self.row = row
    self.col = col
    self.cost = cost
    self.pathCost = pathCost
  }

  var description: String {
    return "\nrow: \(row), col: \(col), cost: \(cost), path cost: \(pathCost)"
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: Point15, rhs: Point15)  -> Bool {
    lhs.id == rhs.id
  }
}
