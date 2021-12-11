//  Day09.swift - AoC 2021

import Foundation

func day09(testData: [String], realData: [String]) {
  let expectedTestResults = [15, 1134]

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
    var lowPoints: [Int] = []
    var lowCoords: [(Int, Int)] = []

    let numRows = data.count
    let numCols = data[0].count

    for row in 0 ..< numRows {
      let rowData = data[row]

      for col in 0 ..< numCols {
        let point = Int(rowData[col])!
        let adjacents = adjacentPoints(data: data, rowNum: row, colNum: col)

        let lowerNum = adjacents.first { $0 <= point }
        if lowerNum == nil {
          lowPoints.append(point)
          lowCoords.append((row, col))
        }
      }
    }

    let result1 = lowPoints.reduce(0) { (cumulativeTotal, nextValue) in
      return cumulativeTotal + nextValue + 1
    }

    print(result1)

    // Part 2

    var basins: [Int] = []

    for coord in lowCoords {
      var unchecked = [coord]
      var checked: Set<String> = []

      while !unchecked.isEmpty {
        let (row, col) = unchecked[0]
        let id = "\(row),\(col)"

        unchecked = Array(unchecked.dropFirst())
        if checked.contains(id) {
          continue
        }
        checked.insert(id)

        let adjs = adjacentCoordsNotNine(data: data, rowNum: row, colNum: col)
        unchecked += adjs
      }
      basins.append(checked.count)
    }

    let bigBasins = basins.sorted().suffix(3)
    let result2 = bigBasins.reduce(1) { $0 * $1 }

    print(result2)
    print()

    return [result1, result2]
  }

  func adjacentPoints(data: [String], rowNum: Int, colNum: Int) -> [Int] {
    var adjs: [Int] = []

    let rowBefore = rowNum == 0 ? nil : data[rowNum - 1]
    let row = data[rowNum]
    let rowAfter = rowNum == data.count - 1 ? nil : data[rowNum + 1]

    if let rowBefore = rowBefore {
      let height = Int(rowBefore[colNum])!
      adjs.append(height)
    }
    if let rowAfter = rowAfter {
      let height = Int(rowAfter[colNum])!
      adjs.append(height)
    }

    if colNum > 0 {
      let height = Int(row[colNum - 1])!
      adjs.append(height)
    }

    if colNum < row.count - 1 {
      let height = Int(row[colNum + 1])!
      adjs.append(height)
    }

    return adjs
  }

  func adjacentCoordsNotNine(data: [String], rowNum: Int, colNum: Int) -> [(Int, Int)] {
    var adjs: [(Int, Int)] = []

    let rowBefore = rowNum == 0 ? nil : data[rowNum - 1]
    let row = data[rowNum]
    let rowAfter = rowNum == data.count - 1 ? nil : data[rowNum + 1]

    if let rowBefore = rowBefore {
      let height = rowBefore[colNum]
      if height != "9" {
        adjs.append((rowNum - 1, colNum))
      }
    }
    if let rowAfter = rowAfter {
      let height = rowAfter[colNum]
      if height != "9" {
        adjs.append((rowNum + 1, colNum))
      }
    }

    if colNum > 0 {
      let height = row[colNum - 1]
      if height != "9" {
        adjs.append((rowNum, colNum - 1))
      }
    }

    if colNum < row.count - 1 {
      let height = row[colNum + 1]
      if height != "9" {
        adjs.append((rowNum, colNum + 1))
      }
    }

    return adjs
  }
}
