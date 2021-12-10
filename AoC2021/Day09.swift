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
    print()

    // Part 2

    var basins: [Int] = []
    for coord in lowCoords {
      let basin = findBasin(data: data, coords: coord)
      basins.append(basin)
    }

    let bigBasins = basins.sorted().suffix(3)
    print(bigBasins)

    let result2 = bigBasins.reduce(1) { $0 * $1 }
    print(result2)
    print()

    // WRONG: 884058 is too low

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

  func findBasin(data: [String], coords: (Int, Int)) -> Int {
    let (row, col) = coords

    let (centerStr, start, end) = expanduntilNines(fullRow: data[row], startCol: col, endCol: col)

    var basinCount = centerStr.count
    var startCol = start
    var endCol = end
    let origStartCol = startCol
    let origEndCol = endCol

    var rowNum = row - 1

    while rowNum >= 0 {
      let (newCount, newStart, newEnd) = processNextLine(rowData: data[rowNum], rowNum: rowNum, col: col, start: startCol, end: endCol)
      if newCount == 0 { break }

      basinCount += newCount
      startCol = newStart
      endCol = newEnd

      rowNum -= 1
    }

    rowNum = row + 1
    startCol = origStartCol
    endCol = origEndCol

    while rowNum < data.count {
      let (newCount, newStart, newEnd) = processNextLine(rowData: data[rowNum], rowNum: rowNum, col: col, start: startCol, end: endCol)
      if newCount == 0 { break }

      basinCount += newCount
      startCol = newStart
      endCol = newEnd

      rowNum += 1
    }

    return basinCount
  }

  func processNextLine(rowData: String, rowNum: Int, col: Int, start: Int, end: Int) -> (Int, Int, Int) {
    var startCol = start
    var endCol = end

    var rowEntries = substring(of: rowData, from: startCol, upto: endCol + 1)

    while rowEntries.hasPrefix("9") {
      rowEntries = String(rowEntries.suffix(rowEntries.count - 1))
      startCol += 1
    }
    while rowEntries.hasSuffix("9") {
      rowEntries = String(rowEntries.prefix(rowEntries.count - 1))
      endCol -= 1
    }
    if rowEntries.isEmpty { return (0, 0, 0) }

    // now expand to 9 or edge
    let (centerStr, start, end) = expanduntilNines(fullRow: rowData, startCol: startCol, endCol: endCol)
    rowEntries = centerStr
    startCol = start
    endCol = end

    let noNines = rowEntries.replacingOccurrences(of: "9", with: "")
    let basinCount = noNines.count

    while rowEntries.contains("9") {
      // move left or right until the 9 is outside startCol - endCol
      // *** THIS IS PROBABLY WHERE THE ERROR IS ***
      if startCol < col {
        rowEntries = String(rowEntries.suffix(rowEntries.count - 1))
        startCol += 1
      } else {
        rowEntries = String(rowEntries.prefix(rowEntries.count - 1))
        endCol -= 1
      }
    }

    return (basinCount, startCol, endCol)
  }

  func expanduntilNines(fullRow: String, startCol: Int, endCol: Int) -> (String, Int, Int) {
    var result = substring(of: fullRow, from: startCol, upto: endCol + 1)

    var colNum = startCol - 1
    while colNum >= 0 {
      if fullRow[colNum] == "9" {
        break
      }
      result = fullRow[colNum] + result
      colNum -= 1
    }
    let start = colNum + 1

    colNum = endCol + 1
    while colNum < fullRow.count {
      if fullRow[colNum] == "9" {
        break
      }
      result += fullRow[colNum]
      colNum += 1
    }
    let end = colNum - 1

    return (result, start, end)
  }
}
