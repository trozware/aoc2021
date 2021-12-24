//  Day20.swift - AoC 2021

import Foundation

func day20(testData: [String], realData: [String]) {
  let expectedTestResults = [35, 3351]
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
    let algorithm = data[0]
    let imageData = Array(data[2 ..< data.count])
    var points: [String: Point] = [:]

    for rowNum in 0 ..< imageData.count {
      for colNum in 0 ..< imageData[0].count {
        let id = "\(rowNum),\(colNum)"
        let on = imageData[rowNum][colNum] == "#"
        let point = Point(id: id, row: rowNum, col: colNum, on: on)
        points[id] = point
      }
    }

    var totalOn = printGrid(points)

    for index in 0 ..< 2 {
      let rowNums = points.values.map { $0.row }
      let minRow = rowNums.min()! - 20
      let maxRow = rowNums.max()! + 20

      let colNums = points.values.map { $0.col }
      let minCol = colNums.min()! - 20
      let maxCol = colNums.max()! + 20

      var newPoints: [String: Point] = [:]
      for r in minRow ... maxRow {
        for c in minCol ... maxCol {
          let pid = "\(r),\(c)"
          let value = surroundingPixels(r: r, c: c, allPoints: points)
          let newSetting = algorithm[value]
          let newPoint = Point(id: pid, row: r, col: c, on: newSetting == "#")
          newPoints[pid] = newPoint
        }
      }

      if index > 1 && !index.isMultiple(of: 2) {
        points = trimPoints(newPoints)
      } else {
        points = newPoints
      }

      totalOn = printGrid(points)
      print(totalOn)
      print()
    }

    points = trimPoints(points)
    totalOn = printGrid(points)
    print(totalOn)
    print()
    let result1 = totalOn

    for index in 2 ..< 50 {

      let rowNums = points.values.map { $0.row }
      let minRow = rowNums.min()! - 20
      let maxRow = rowNums.max()! + 20

      let colNums = points.values.map { $0.col }
      let minCol = colNums.min()! - 20
      let maxCol = colNums.max()! + 20

      print(index, rowNums.max()!, colNums.max()!)

      var newPoints: [String: Point] = [:]
      for r in minRow ... maxRow {
        for c in minCol ... maxCol {
          let pid = "\(r),\(c)"
          let value = surroundingPixels(r: r, c: c, allPoints: points)
          let newSetting = algorithm[value]
          let newPoint = Point(id: pid, row: r, col: c, on: newSetting == "#")
          newPoints[pid] = newPoint
        }
      }

      if index > 1 && !index.isMultiple(of: 2) {
        points = trimPoints(newPoints)
      } else {
        points = newPoints
      }

//      totalOn = printGrid(points)
//      print(totalOn)
//      print()
    }

    points = trimPoints(points)
    totalOn = printGrid(points)
    print(totalOn)
    print()

    return [result1, totalOn]
  }

  func surroundingPixels(r: Int, c: Int, allPoints: [String: Point]) -> Int {
    let pointIds = [
      "\(r - 1),\(c - 1)",
      "\(r - 1),\(c)",
      "\(r - 1),\(c + 1)",
      "\(r),\(c - 1)",
      "\(r),\(c)",
      "\(r),\(c + 1)",
      "\(r + 1),\(c - 1)",
      "\(r + 1),\(c)",
      "\(r + 1),\(c + 1)"
    ]

    var pointsData = ""
    for pid in pointIds {
      if let p = allPoints[pid] {
        pointsData += p.on ? "1" : "0"
      } else {
        pointsData += "0"
      }
    }

    let pointsValue = Int(pointsData, radix: 2)!
    return pointsValue
  }

  func trimPoints(_ points: [String: Point]) -> [String: Point] {
    let rowNums = points.values.map { $0.row }
    let minRow = rowNums.min()! + 30
    let maxRow = rowNums.max()! - 30

    let colNums = points.values.map { $0.col }
    let minCol = colNums.min()! + 30
    let maxCol = colNums.max()! - 30

    var trimmedPoints: [String: Point] = [:]
    for (id, p) in points {
      if p.row >= minRow && p.row <= maxRow && p.col >= minCol && p.col <= maxCol {
        trimmedPoints[id] = p
      }
    }
    return trimmedPoints
  }

  func printGrid(_ points: [String: Point]) -> Int {
    let rowNums = points.values.map { $0.row }
    let minRow = rowNums.min()!
    let maxRow = rowNums.max()!

    let colNums = points.values.map { $0.col }
    let minCol = colNums.min()!
    let maxCol = colNums.max()!

    var totalOn = 0

    for r in minRow ... maxRow {
      var rowPrint = ""
      for c in minCol ... maxCol {
        let pid = "\(r),\(c)"
        var state = false
        if let p = points[pid] {
          state = p.on
        }
        if state {
          totalOn += 1
          rowPrint += "#"
        } else {
          rowPrint += "."
        }
      }
      print(rowPrint)
    }
    print()

    return totalOn
  }

  struct Point {
    let id: String
    let row: Int
    let col: Int
    var on: Bool
  }
}
