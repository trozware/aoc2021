//  Day18.swift - AoC 2021

import Foundation

func day18(testData: [String], realData: [String]) {
//  let expectedTestResults = [1, 2]
//  let testResults = runCode(data: testData)
//  if testResults != expectedTestResults {
//    print("Error running tests")
//    print("Expected:", expectedTestResults)
//    print("Got:", testResults)
//    return
//  } else {
//    print("Tests passed")
//    print()
//  }

  let realResults = runCode(data: realData)
  print("Results:", realResults)

  func runCode(data: [String]) -> [Int] {
    var num = "[[[[[9,8],1],2],3],4]"
    var startParts: [String] = []
    var endParts: [String] = []

    print(num)

    while true {
      num = substring(of: num, from: 1, upto: num.count - 1)
      print(num)

      if num[0] != "[" {
        startParts.append(num[0])
        endParts.append("")
        num = substring(of: num, from: 2, upto: num.count)
      }

      if num[num.count - 1] != "]" {
        endParts.append(num[num.count - 1])
        startParts.append("")
        num = substring(of: num, from: 0, upto: num.count - 2)
      }

      if num.isEmpty {
        break
      }

      print(num)
      print(startParts)
      print(Array(endParts.reversed()))
    }

    print(startParts)
    print(Array(endParts.reversed()))

    return [1, 2]
  }

  func reduce(_ num: String) {

  }

  struct Num {
    
  }
}
