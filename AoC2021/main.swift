//  main.swift - AoC 2021

import Foundation

let dayNum = 1

let startTime = Date()

print("Running program for day \(dayNum):")
print()

runDay(number: dayNum)

let endTime = Date()
showElapsedTime(from: startTime, to: endTime)
print()

func runDay(number: Int) {
  if number == 1 {
    day01()
  } else if number == 2 {
    day02()
  } else if number == 3 {
    day03()
  } else if number == 4 {
    day04()
  } else if number == 5 {
    day05()
  } else if number == 6 {
    day06()
  } else if number == 7 {
    day07()
  } else if number == 8 {
    day08()
  } else if number == 9 {
    day09()
  } else if number == 10 {
    day10()
  } else if number == 11 {
    day11()
  } else if number == 12 {
    day12()
  } else if number == 13 {
    day13()
  } else if number == 14 {
    day14()
  } else if number == 15 {
    day15()
  } else if number == 16 {
    day16()
  } else if number == 17 {
    day17()
  } else if number == 18 {
    day18()
  } else if number == 19 {
    day19()
  } else if number == 20 {
    day20()
  } else if number == 21 {
    day21()
  } else if number == 22 {
    day22()
  } else if number == 23 {
    day23()
  } else if number == 24 {
    day24()
  } else if number == 25 {
    day25()
  }
}


