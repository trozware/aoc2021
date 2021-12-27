//  Day22.swift - AoC 2021

import Foundation

func day22(testData: [String], realData: [String]) {
  let expectedTestResults = [590784, 2758514936282235]
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
    var onLights: Set<Point> = []
    var lastCount1 = 0
    var lastCount2 = 0

//    let ranges = ["on x=10..12,y=10..12,z=10..12",
//                  "on x=11..13,y=11..13,z=11..13",
//                  "off x=9..11,y=9..11,z=9..11",
//                  "on x=10..10,y=10..10,z=10..10"]

    for r in data {
      let (switchOn, xRange, yRange, zRange) = parse(input: r)
      let cuboid = getCuboidLimited(xRange: xRange, yRange: yRange, zRange: zRange)

      if switchOn {
        onLights = onLights.union(cuboid)
      } else {
        onLights = onLights.subtracting(cuboid)
      }

      print(onLights.count)
      if onLights.count == lastCount1 &&  onLights.count == lastCount2 {
        break
      }
      lastCount2 = lastCount1
      lastCount1 = onLights.count
    }
    print()

    // Part 2 is way too slow generating the cuboid sets

    //    let data2 = openTestFile(dayNum: 222, separator: "\n")
    //
    //    var onLights2: Set<Point> = []
    //    lastCount1 = 0
    //    lastCount2 = 0
    //
    //    for r in data2 {
    //      let (switchOn, xRange, yRange, zRange) = parse(input: r)
    //      let cuboid = getCuboid(xRange: xRange, yRange: yRange, zRange: zRange)
    //
    //      if switchOn {
    //        onLights2 = onLights2.union(cuboid)
    //      } else {
    //        onLights2 = onLights2.subtracting(cuboid)
    //      }
    //
    //      print(onLights2.count)
    //      if onLights2.count == lastCount1 &&  onLights2.count == lastCount2 {
    //        break
    //      }
    //      lastCount2 = lastCount1
    //      lastCount1 = onLights2.count
    //    }

    return [onLights.count, 2]
  }

  func parse(input: String) -> (Bool, ClosedRange<Int>, ClosedRange<Int>, ClosedRange<Int>) {
    // on x=10..12,y=10..12,z=10..12
    let switchOn = input.hasPrefix("on") ? true : false

    let parts = input
      .components(separatedBy: ",")
      .flatMap { $0
      .components(separatedBy: "=" )[1]
      .components(separatedBy: "..")
      }
      .map { Int($0)! }

    let xRange = parts[0] ... parts[1]
    let yRange = parts[2] ... parts[3]
    let zRange = parts[4] ... parts[5]

    let ranges = (switchOn, xRange, yRange, zRange)
    return ranges
  }

  func getCuboidLimited(xRange: ClosedRange<Int>, yRange: ClosedRange<Int>, zRange: ClosedRange<Int>) -> Set<Point> {
    var cuboid: [Point] = []
    for x in xRange {
      if x < -50 || x > 50 { continue }
      for y in yRange {
        if y < -50 || y > 50 { continue }
        for z in zRange {
          if z < -50 || z > 50 { continue }
          cuboid.append(Point(x: x, y: y, z: z))
        }
      }
    }
    return Set(cuboid)
  }

  func getCuboid(xRange: ClosedRange<Int>, yRange: ClosedRange<Int>, zRange: ClosedRange<Int>) -> Set<Point> {
    var cuboid: [Point] = []
    for x in xRange {
      for y in yRange {
        for z in zRange {
          cuboid.append(Point(x: x, y: y, z: z))
        }
      }
    }
    return Set(cuboid)
  }

  struct Point: Hashable {
    let x: Int
    let y: Int
    let z: Int

    func hash(into hasher: inout Hasher) {
      hasher.combine("\(x),\(y),\(z)")
    }
  }
}
