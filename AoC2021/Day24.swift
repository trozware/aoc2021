//  Day24.swift - AoC 2021

import Foundation

func day24(testData: [String], realData: [String]) {
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

    //    let yAdds = [8, 13, 8, 10, 12, 1, 13, 5, 10, 3, 2, 2, 12, 7 ]
    //    let zOp = ["m", "m", "m", "m", "d", "d", "m", "m", "d", "d", "m", "d", "d", "d"]

    var inputNum = 99999999999999

    //    while true {
    //      let input = "\(inputNum)"
    //      if input.count < 14 { break }
    //      if input.contains("0") {
    //        inputNum -= 1
    //        continue
    //      }
    //
    //      var zValue = 0
    //      for i in 0 ..< 14 {
    //        let y = Int(input[i])! + yAdds[i]
    //        if zOp[i] == "m" {
    //          zValue = (zValue * 26) + y
    //        } else {
    //          let div = Int(trunc(Double(zValue) / 26.0))
    //          zValue = (div * 26) + y
    //        }
    //        // print(zValue)
    //      }
    //
    //      if zValue == 0 {
    //        print("Valid", input, zValue)
    //      } else if zValue < 10000 {
    //        print(input, zValue)
    //      } else if input.hasSuffix("99999") {
    //        print(input, zValue)
    //      }
    //
    //      inputNum -= 1
    //
    //      print(input, zValue)
    //      break
    //    }

    var alu = ALU()
    let change = 1

    while true {
      let input = "\(inputNum)"
      if input.count < 14 { break }
      if input.contains("0") {
        inputNum -= change
        continue
      }

      var pointer = 0

      alu.reset()
      for i in data {
        if i.isEmpty {
          break
        }
        alu.process(instruction: i, inputs: input, pointer: &pointer)
        print(i.padLeft(to: 12), "  ->  ", alu)
      }
      print(input, alu.z)

      if alu.z == 0 {
        print(input)
        print(alu)
        break
      }

      print(alu)
      break

      inputNum -= change
    }

    return [2, 2]
  }

  struct ALU: CustomStringConvertible {
    var w = 0
    var x = 0
    var y = 0
    var z = 0

    mutating func reset() {
      w = 0
      x = 0
      y = 0
      z = 0
    }

    mutating func process(instruction: String, inputs: String, pointer: inout Int) {
      let parts = instruction.components(separatedBy: " ")
      switch parts[0] {
      case "inp":
        let input = Int(inputs[pointer])!
        pointer += 1
        assignValue(register: parts[1], value: input)
      case "add":
        addValues(register1: parts[1], param2: parts[2])
      case "mul":
        multiplyValues(register1: parts[1], param2: parts[2])
      case "div":
        divideValues(register1: parts[1], param2: parts[2])
      case "mod":
        modValues(register1: parts[1], param2: parts[2])
      case "eql":
        eqlValues(register1: parts[1], param2: parts[2])
      default:
        break
      }
    }

    mutating func assignValue(register: String, value: Int) {
      switch register {
      case "w":
        w = value
      case "x":
        x = value
        print("x = ", x)
      case "y":
        y = value
      case "z":
        z = value
      default:
        break
      }
    }

    func readValue(register: String) -> Int {
      switch register {
      case "w":
        return w
      case "x":
        return x
      case "y":
        return y
      case "z":
        return z
      default:
        return 0
      }
    }

    mutating func addValues(register1: String, param2: String) {
      var value = 0
      if let num = Int(param2) {
        value = num
      } else {
        value = readValue(register: param2)
      }
      let result = readValue(register: register1) + value
      assignValue(register: register1, value: result)
    }

    mutating func multiplyValues(register1: String, param2: String) {
      var value = 0
      if let num = Int(param2) {
        value = num
      } else {
        value = readValue(register: param2)
      }
      let result = readValue(register: register1) * value
      assignValue(register: register1, value: result)
    }

    mutating func divideValues(register1: String, param2: String) {
      var value = 0
      if let num = Int(param2) {
        value = num
      } else {
        value = readValue(register: param2)
      }
      let result = Double(readValue(register: register1)) / Double(value)
      let resultInt = Int(trunc(result))
      assignValue(register: register1, value: resultInt)
    }

    mutating func modValues(register1: String, param2: String) {
      var value = 0
      if let num = Int(param2) {
        value = num
      } else {
        value = readValue(register: param2)
      }
      let result = readValue(register: register1) % value
      assignValue(register: register1, value: result)
    }

    mutating func eqlValues(register1: String, param2: String) {
      var value = 0
      if let num = Int(param2) {
        value = num
      } else {
        value = readValue(register: param2)
      }
      let result = readValue(register: register1) == value
      assignValue(register: register1, value: result ? 1 : 0)
    }

    var description: String {
      return "w: \(w), x: \(x), y: \(y), z: \(z)"
    }
  }
}
