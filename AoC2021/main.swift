//  main.swift - AoC 2021

import Foundation

let dayNum = 15

print("Running program for day \(dayNum):")
print()

let test = openTestFile(dayNum: dayNum, separator: "\n")
let data = openDataFile(dayNum: dayNum, separator: "\n")

let startTime = Date()

runDay(number: dayNum)

let endTime = Date()
showElapsedTime(from: startTime, to: endTime)
print()

func runDay(number: Int) {
  if number == 1 {
    day01(testData: test, realData: data)
  } else if number == 2 {
    day02(testData: test, realData: data)
  } else if number == 3 {
    day03(testData: test, realData: data)
  } else if number == 4 {
    day04(testData: test, realData: data)
  } else if number == 5 {
    day05(testData: test, realData: data)
  } else if number == 6 {
    day06(testData: test, realData: data)
  } else if number == 7 {
    day07(testData: test, realData: data)
  } else if number == 8 {
    day08(testData: test, realData: data)
  } else if number == 9 {
    day09(testData: test, realData: data)
  } else if number == 10 {
    day10(testData: test, realData: data)
  } else if number == 11 {
    day11(testData: test, realData: data)
  } else if number == 12 {
    day12(testData: test, realData: data)
  } else if number == 13 {
    day13(testData: test, realData: data)
  } else if number == 14 {
    day14(testData: test, realData: data)
  } else if number == 15 {
    day15(testData: test, realData: data)
  } else if number == 16 {
    day16(testData: test, realData: data)
  } else if number == 17 {
    day17(testData: test, realData: data)
  } else if number == 18 {
    day18(testData: test, realData: data)
  } else if number == 19 {
    day19(testData: test, realData: data)
  } else if number == 20 {
    day20(testData: test, realData: data)
  } else if number == 21 {
    day21(testData: test, realData: data)
  } else if number == 22 {
    day22(testData: test, realData: data)
  } else if number == 23 {
    day23(testData: test, realData: data)
  } else if number == 24 {
    day24(testData: test, realData: data)
  } else if number == 25 {
    day25(testData: test, realData: data)
  }
}


