//  Day04.swift - AoC 2021

import Foundation

func day04(testData: [String], realData: [String]) {
  let expectedTestResults = [4512, 1924]

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
    let draws = convertToIntegers(data[0].components(separatedBy: ","))
    var boards: [Board] = []

    for x in stride(from: 2, through: data.count - 5, by: 6) {
      let board = Board(lines: Array(data[x ..< x + 5]))
      boards.append(board)
    }

    var counter = 0
    var result1 = 0
    var result2 = 0

    outerLoop1:
    for draw in draws {
      counter += 1
      // print("Round \(counter) - \(draw):")

      for board in boards {
        board.markDraw(draw)

        if board.hasWon() {
          print("Winner")
          board.show()
          result1 = board.score() * draw
          break outerLoop1
        }
      }
    }

    for board in boards {
      board.reset()
    }

    var winCount = 0

    outerLoop2:
    for draw in draws {
      counter += 1
      // print("Round \(counter) - \(draw):")

      for board in boards {
        if board.hasWon() {
          continue
        }

        board.markDraw(draw)

        if board.hasWon() {
          winCount += 1
          if winCount == boards.count {
            print("Loser")
            board.show()
            result2 = board.score() * draw
            break outerLoop2
          }
        }
      }
    }

    return [result1, result2]
  }
}

class Board {
  var numbers: [[Int]]
  var marks: [[String]]

  init(lines: [String]) {
    numbers = []

    for line in lines {
      var trimmedLine = line
        .trimmingCharacters(in: .whitespaces)

      while trimmedLine.contains("  ") {
        trimmedLine = trimmedLine
          .replacingOccurrences(of: "  ", with: " ")
      }
      let nums = convertToIntegers(trimmedLine.components(separatedBy: .whitespaces))
      numbers.append(nums)
    }

    let markLine = Array(repeating: "", count: 5)
    marks = Array(repeating: markLine, count: 5)
  }

  func reset() {
    let markLine = Array(repeating: "", count: 5)
    marks = Array(repeating: markLine, count: 5)
  }

  func show() {
    for rowNum in 0 ..< 5 {
      let row = numbers[rowNum]
      var rowString = ""
      for colNum in 0 ..< 5 {
        let item = "\(row[colNum])\(marks[rowNum][colNum])".padLeft(to: 5)
        rowString += item
      }
      print(rowString)
    }

    print()
  }

  func markDraw(_ draw: Int) {
    for rowNum in 0 ..< 5 {
      for colNum in 0 ..< 5 {
        if numbers[rowNum][colNum] == draw {
          marks[rowNum][colNum] = "*"
        }
      }
    }
  }

  func hasWon() -> Bool {
    // check by row
    for rowNum in 0 ..< 5 {
      var markedCount = 0
      for colNum in 0 ..< 5 {
        if marks[rowNum][colNum] == "*" {
          markedCount += 1
          if markedCount == 5 {
            return true
          }
        }
      }
    }

    // check by column
    for colNum in 0 ..< 5 {
      var markedCount = 0
      for rowNum in 0 ..< 5 {
        if marks[rowNum][colNum] == "*" {
          markedCount += 1
          if markedCount == 5 {
            return true
          }
        }
      }
    }

    return false
  }

  func score() -> Int {
    var total = 0

    for rowNum in 0 ..< 5 {
      for colNum in 0 ..< 5 {
        if marks[rowNum][colNum] != "*" {
          total += numbers[rowNum][colNum]
        }
      }
    }

    return total
  }
}
