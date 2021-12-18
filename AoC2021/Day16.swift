//  Day16.swift - AoC 2021

import Foundation

func day16(testData: [String], realData: [String]) {
  let expectedTestResults = [31, 2]
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
    // let hex = "D2FE28"
    let hex = "38006F45291200"

    let bin = hexToBin(hex)
    print(bin)

    var binDigits = bin.map { String($0) }

    let versionBits = binDigits[0 ..< 3].joined(separator: "")
    let version = Int(versionBits, radix: 2)!
    print("Version:", version)

    let typeBits = binDigits[3 ..< 6].joined(separator: "")
    let type = Int(typeBits, radix: 2)!
    print("Type:", type)

    binDigits = Array(binDigits.suffix(from: 6))

    if type == 4 {
      let (_, value) = decodeLiteralValue(binDigits)
      print(value)
    } else {
      let _ = decodeOperator(binDigits)
    }

    return [1, 2]
  }

  func decodeLiteralValue(_ data: [String]) -> (String, Int) {
    var binValue = ""
    var index = 0

    while true {
      let headerBit = data[index]
      let dataBits = data[index+1 ..< index + 5].joined(separator: "")
      binValue += dataBits
      if headerBit == "0" {
        break
      }
      index += 5
    }

    let decValue = Int(binValue, radix: 2)!
    return (binValue, decValue)
  }

  func decodeOperator(_ data: [String]) -> Int {
    // var value = ""
    var index = 0

    let lengthBit = data[index]
    index += 1

    if lengthBit == "0" {
      let totalLengthBits = data[index ..< index + 15].joined(separator: "")
      let totalLength = Int(totalLengthBits, radix: 2)!
      print(totalLength)

      index += 15
      var packetData = Array(data.suffix(from: index))

      var processedBin = ""
      var decValues: [Int] = []

      while processedBin.count < totalLength {
        let (binValue, decValue) = decodeLiteralValue(packetData)
        processedBin += binValue
        decValues.append(decValue)
        packetData = Array(data.suffix(from: binValue.count))
      }

      print(decValues)
    }

    // let decValue = Int(value, radix: 2)!
    return 1
  }

  func hexToBin(_ hex: String) -> String {
    let conversions: [Character: String] = [
      "0": "0000", "1": "0001", "2": "0010", "3": "0011", "4": "0100", "5": "0101", "6": "0110", "7": "0111",
      "8": "1000", "9": "1001", "A": "1010", "B": "1011", "C": "1100", "D": "1101", "E": "1110", "F": "1111"
    ]

    var bin = ""
    for hexDigit in hex {
      bin += conversions[hexDigit]!
    }
    return bin
  }
}
