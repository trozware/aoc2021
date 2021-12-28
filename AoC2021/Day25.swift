//  Day25.swift - AoC 2021

import Foundation

func day25(testData: [String], realData: [String]) {
  let expectedTestResults = [58, 2]
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
    // let test = ["...>>>>>..."]
    //    let test = [
    //      "..........",
    //      ".>v....v..",
    //      ".......>..",
    //      ".........."
    //    ]
    //    let test = [
    //      "...>...",
    //      ".......",
    //      "......>",
    //      "v.....>",
    //      "......>",
    //      ".......",
    //      "..vvv.."
    //    ]

    // Works but its slow
    
    var herd: [Cucumber] = []
    let maxY = data.count
    let maxX = data[0].count

    for y in 0 ..< data.count {
      let row = data[y]
      for x in 0 ..< row.count {
        let direction = row[x]
        if direction == "." { continue }
        let cuc = Cucumber(x: x, y: y, direction: direction)
        herd.append(cuc)
      }
    }
    // printHerd(herd, maxX: maxX, maxY: maxY)

    var moves = 1

    while true {
      for cuc in herd {
        if cuc.direction == ">" {
          cuc.checkCanMove(herd: herd, maxX: maxX, maxY: maxY)
        }
      }
      for cuc in herd {
        if cuc.direction == ">" {
          cuc.move(maxX: maxX, maxY: maxY)
        }
      }

      for cuc in herd {
        if cuc.direction == "v" {
          cuc.checkCanMove(herd: herd, maxX: maxX, maxY: maxY)
        }
      }
      for cuc in herd {
        if cuc.direction == "v" {
          cuc.move(maxX: maxX, maxY: maxY)
        }
      }

      print("Moves: \(moves)")
      // printHerd(herd, maxX: maxX, maxY: maxY)

      let haveMoved = herd.firstIndex { $0.canMove }
      if haveMoved == nil { break }
      
      moves += 1
    }

    return [moves, 2]
  }

  func printHerd(_ herd: [Cucumber], maxX: Int, maxY: Int) {
    let blankLine = Array(repeating: ".", count: maxX)
    var grid = Array(repeating: blankLine, count: maxY)

    for cuc in herd {
      grid[cuc.y][cuc.x] = cuc.direction
    }

    for line in grid {
      print(line.joined(separator: ""))
    }
    print()
  }


  class Cucumber: CustomStringConvertible {
    var x: Int
    var y: Int
    let direction: String
    var canMove = false

    init(x: Int, y: Int, direction: String) {
      self.x = x
      self.y = y
      self.direction = direction
    }

    var description: String {
      "x: \(x), y: \(y), direction: \(direction)"
    }

    func move(maxX: Int, maxY: Int) {
      if !canMove { return }

      if direction == ">" {
        x += 1
        if x >= maxX {
          x = 0
        }
      } else {
        y += 1
        if y >= maxY {
          y = 0
        }
      }
    }

    func checkCanMove(herd: [Cucumber], maxX: Int, maxY: Int) {
      if direction == ">" {
        var targetX = x + 1
        if targetX >= maxX {
          targetX = 0
        }
        let cucToEast = herd.first { $0.y == y && $0.x == targetX }
        canMove = cucToEast == nil
      } else {
        var targetY = y + 1
        if targetY >= maxY {
          targetY = 0
        }
        let cucToSouth = herd.first { $0.x == x && $0.y == targetY }
        canMove = cucToSouth == nil
      }
    }
  }
}
