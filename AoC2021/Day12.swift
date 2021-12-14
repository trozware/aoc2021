//  Day12.swift - AoC 2021

import Foundation

func day12(testData: [String], realData: [String]) {
  let expectedTestResults = [226, 3509]

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
    let links = createLinks(data: data)
    // print(links)

    var completePaths: [[String]] = []
    var partialPaths = [["start"]]

    while !partialPaths.isEmpty {
      let path = partialPaths.first!
      partialPaths = Array(partialPaths.dropFirst())

      let lastStep = path.last!
      let nextSteps = links[lastStep]!

      for step in nextSteps {
        let newPath = path + [step]
        if step == "end" {
          completePaths.append(newPath)
        } else if pathIsValid(path, step) {
          partialPaths.append(newPath)
        }
      }
    }

//    for path in completePaths {
//      print(path.joined(separator: ","))
//    }
//    print()

    let result1 = completePaths.count
    print("Result 1:", result1)

    completePaths = []
    partialPaths = [["start"]]

    while !partialPaths.isEmpty {
      let path = partialPaths.first!
      partialPaths = Array(partialPaths.dropFirst())

      let lastStep = path.last!
      let nextSteps = links[lastStep]!

      for step in nextSteps {
        let newPath = path + [step]
        if step == "end" {
          completePaths.append(newPath)
        } else if pathIsValid2(path, step) {
          partialPaths.append(newPath)
        }
      }
    }

    let result2 = completePaths.count
    print("Result 2:", result2)

    return [result1, result2]
  }

  func createLinks(data: [String]) -> [String: [String]] {
    var links: [String: [String]] = [:]

    for link in data {
      let parts = link.components(separatedBy: "-")
      if parts.count != 2 { continue }

      if links[parts[0]] != nil {
        links[parts[0]]!.append(parts[1])
      } else {
        links[parts[0]] = [parts[1]]
      }

      if links[parts[1]] != nil {
        links[parts[1]]!.append(parts[0])
      } else {
        links[parts[1]] = [parts[0]]
      }
    }

    return links
  }

  func pathIsValid(_ path: [String], _ step: String) -> Bool {
    if step.uppercased() == step {
      return true
    }
    if path.contains(step) {
      return false
    }
    return true
  }

  func pathIsValid2(_ path: [String], _ step: String) -> Bool {
    if step == "start" { return false }
    if step.uppercased() == step {
      return true
    }
    if path.contains(step) {
      // if this is the first lowercase duplicate, then it is Ok
      // this is very slow - takes about 2 minutes on my Mac
      let lowercaseSteps = path.filter { $0.lowercased() == $0 }
      let uniques = Set(lowercaseSteps)
      if lowercaseSteps.count == uniques.count {
        return true
      }
      return false
    }
    return true
  }
}

struct Tree: Identifiable {
  var id: String
  var links: [Tree] = []
}
