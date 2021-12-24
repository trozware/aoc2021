//  Day16.swift - AoC 2021

import Foundation

func day16(testData: [String], realData: [String]) {
//  let expectedTestResults = [20, 1]
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
    // let hex = "D2FE28"
    // let hex = "38006F45291200"
    // let hex = "EE00D40C823060"
    // let hex = "8A004A801A8002F478"
    // let hex = "620080001611562C8802118E34"
    // let hex = "C0015000016115A2E0802F182340"
    // let hex = "A0016C880162017C3686B18A3D4780"

    // let hex = "C200B40A82"
    // let hex = "04005AC33890"
    // let hex = "880086C3E88112"
    // let hex = "CE00C43D881120"
    // let hex = "D8005AC2A8F0"
    // let hex = "F600BC2D8F"
    // let hex = "9C005AC2F8F0"
    // let hex = "9C0141080250320F1802104A08"

    let hex = data[0]

    let bin = hexToBin(hex)
    // print(bin)

    let binDigits = bin.map { String($0) }
    var pointer = 0
    var versionsCounter = 0
    var packets: [Packet] = []

    while pointer < binDigits.count - 6 {
      let startPointer = pointer
      let version = getVersion(binDigits, pointer: &pointer)
      if version == -1 { break }

      versionsCounter += version

      let type = getType(binDigits, pointer: &pointer)

      var value: Int? = nil
      var packetLength: Int? = nil
      var packetCount: Int? = nil

      if type == 4 {
        value = getLiteralValue(binDigits, pointer: &pointer)
      } else {
        let (packLength, packCount) = getOperator(binDigits, pointer: &pointer)
        packetLength = packLength
        packetCount = packCount
      }

      if version == -1 || type == -1 || value == -1 || packetLength == -1 || packetCount == -1 {
        continue
      }

      let packet = Packet(pointer: startPointer, len: pointer - startPointer, version: version, type: type,
                          value: value, packetLength: packetLength, packetCount: packetCount)
      packets.append(packet)
    }

    for p in packets {
      print(p)
    }

    print("\nVersions counter:", versionsCounter)

    // Part 2

    let result = analysePackets(packets)
    print(result)
    print("\nResult:", result)

    return [versionsCounter, result]
  }

  func analysePackets(_ packets: [Packet], operatorType: Int? = nil) -> Int {
    var result = 0

    var nums: [Int] = []
    var startPack = 0

    while startPack < packets.count {
      let pack = packets[startPack]
      print(pack)
      startPack += 1
      //print("startPack = ", startPack, "packets count = ", packets.count)

      if let value = pack.value {
        nums.append(value)
      } else if let count = pack.packetCount {
        let subPackets = Array(packets[startPack ..< startPack + count])
        startPack += count
        //print("startPack = ", startPack, "packets count = ", packets.count)
        nums.append(analysePackets(subPackets, operatorType: pack.type))
      } else if let len = pack.packetLength {
        var subPackets: [Packet] = []
        var totalLen = 0
        while totalLen < len {
          subPackets.append(packets[startPack])
          totalLen += packets[startPack].len
          startPack += 1
        }
        //print("startPack = ", startPack, "packets count = ", packets.count)
        nums.append(analysePackets(subPackets, operatorType: pack.type))
      }
    }

    if !nums.isEmpty && operatorType != nil {
      switch operatorType! {
      case 0:
        result = sumNums(nums)
      case 1:
        result = productNums(nums)
      case 2:
        result = nums.min()!
      case 3:
        result = nums.max()!
      case 5:
        result = nums[0] > nums[1] ? 1 : 0
      case 6:
        result = nums[0] < nums[1] ? 1 : 0
      case 7:
        result = nums[0] == nums[1] ? 1 : 0
      default:
        break
      }
      return result
    } else if nums.count > 0 {
      return nums[0]
    }

    return result
  }

  func sumNums(_ nums: [Int]) -> Int {
    nums.reduce(0) { $0 + $1 }
  }

  func productNums(_ nums: [Int]) -> Int {
    nums.reduce(1) { $0 * $1 }
  }

  func getDecValue(_ binary: [String], length: Int, pointer: inout Int) -> Int {
    if binary.count < pointer + length {
      return -1
    }

    let bits = binary[pointer ..< pointer + length].joined(separator: "")
    let dec = Int(bits, radix: 2)!
    pointer += length
    return dec
  }

  func getVersion(_ binary: [String], pointer: inout Int) -> Int {
    return getDecValue(binary, length: 3, pointer: &pointer)
  }

  func getType(_ binary: [String], pointer: inout Int) -> Int {
    return getDecValue(binary, length: 3, pointer: &pointer)
  }

  func getOperatorDataLength(_ binary: [String], pointer: inout Int) -> Int {
    return getDecValue(binary, length: 15, pointer: &pointer)
  }

  func getOperatorPacketsCount(_ binary: [String], pointer: inout Int) -> Int {
    return getDecValue(binary, length: 11, pointer: &pointer)
  }

  func getLiteralValue(_ binary: [String], pointer: inout Int) -> Int {
    var binValue = ""
    var index = pointer

    while true {
      let headerBit = binary[index]
      let dataBits = binary[index+1 ..< index + 5].joined(separator: "")
      binValue += dataBits
      index += 5
      if headerBit == "0" {
        break
      }
    }

    pointer = index
    let decValue = Int(binValue, radix: 2)!
    return decValue
  }

  func getOperator(_ binary: [String], pointer: inout Int) -> (Int?, Int?) {
    let lengthBit = binary[pointer]
    pointer += 1

    if lengthBit == "0" {
      let totalLength = getOperatorDataLength(binary, pointer: &pointer)
      return (totalLength, nil)
    } else if lengthBit == "1" {
      let packetsCount = getOperatorPacketsCount(binary, pointer: &pointer)
      return (nil, packetsCount)
    }

    return (nil, nil)
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

  struct Packet {
    let pointer: Int
    let len: Int
    let version: Int
    let type: Int
    let value: Int?
    let packetLength: Int?
    let packetCount: Int?
  }
}
