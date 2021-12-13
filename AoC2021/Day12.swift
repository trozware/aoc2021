//  Day12.swift - AoC 2021

import Foundation

func day12(testData: [String], realData: [String]) {
  let expectedTestResults = [226, 2]

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
    print(data)
    let links = createLinks(data: data)

    var startTree = Tree(id: "start")

    for link in links["start"]! {
      startTree.links.append(Tree(id: link))

    }



    print(links)
    print(startTree)

    return [1, 2]
  }

  func createLinks(data: [String]) -> [String: [String]] {
    var links: [String: [String]] = [:]
//    var trees: [Tree] = []

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

//    for key in links.keys {
//      trees.append(Tree(id: key))
//    }
//
//    print(trees)


    return links
  }
}

struct Tree: Identifiable {
  var id: String
  var links: [Tree] = []
}
