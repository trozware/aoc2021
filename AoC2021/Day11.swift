//  Day11.swift - AoC 2021

import Foundation

func day11(testData: [String], realData: [String]) {
  let expectedTestResults = [1656, 195]

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
    // let test = [ "11111", "19991", "19191", "19991", "11111" ]

    var octs = convertToIntArrays(data)

    var flashCount = 0
    var index = 0
    var result1 = 0
    var result2 = 0

    while true {
      if index == 100 {
        result1 = flashCount
        print("Result 1:", result1)
      }
      index += 1

      octs = incrementAll(octs)
      var haveChanged: [String] = []

      while true {
        var madeChanges = false
        for rowNum in 0 ..< octs.count {
          for colNum in 0 ..< octs[0].count {
            if octs[rowNum][colNum] > 9 && !haveChanged.contains("\(rowNum),\(colNum)") {
              (octs, haveChanged) = processFlash(octs, rowNum: rowNum, colNum: colNum, haveChanged: haveChanged)
              flashCount += 1
              madeChanges = true
            }
          }
        }
        if !madeChanges {
          break
        }
      }

      for change in haveChanged {
        let coords = change.split(separator: ",")
        let row = Int(coords[0])!
        let col = Int(coords[1])!
        octs[row][col] = 0
      }

      if checkForAllFlashes(octs) {
        result2 = index
        break
      }
    }

    print("Result 2:", result2)

    return [result1, result2]
  }

  func convertToIntArrays(_ data: [String]) -> [[Int]] {
    let octs = data.map { line -> [Int] in
      var nums: [Int] = []
      for char in line {
        nums.append(Int(String(char)) ?? 0)
      }
      return nums
    }
    return octs
  }

  func incrementAll(_ data: [[Int]]) -> [[Int]] {
    var newData: [[Int]] = []
    for row in data {
      let newRow = row.map { $0 + 1 }
      newData.append(newRow)
    }
    return newData
  }

  func processFlash(_ data: [[Int]], rowNum: Int, colNum: Int, haveChanged: [String]) -> ([[Int]],  [String]) {
    var newData: [[Int]] = []
    var newChanges = haveChanged

    for row in 0 ..< data.count {
      var newRow: [Int] = []
      for col in 0 ..< data[0].count {
        let newItem = data[row][col]
        let id = "\(row),\(col)"
        if (rowNum-1 ... rowNum+1).contains(row) && (colNum-1 ... colNum+1).contains(col)
            && !newChanges.contains(id) {
          newRow.append(newItem + 1)
        } else {
          newRow.append(newItem)
        }
      }
      newData.append(newRow)
    }
    newData[rowNum][colNum] = 0
    newChanges.append("\(rowNum),\(colNum)")

    return (newData, newChanges)
  }

  func checkForAllFlashes(_ data: [[Int]]) -> Bool {
    for row in data {
      let zeros = row.filter { $0 == 0 }
      if zeros.count < 10 {
        return false
      }
    }
    return true
  }
}
