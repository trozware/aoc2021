import Foundation

func openDataFile(dayNum: Int, separator: String = "\n") -> [String] {
  let filePath = "Day\(dayNum).txt"
  let url = Bundle.main.bundleURL.appendingPathComponent("Data").appendingPathComponent(filePath)
  return readFile(url: url, separator: separator)
}

func openTestFile(dayNum: Int, separator: String = "\n") -> [String] {
  let filePath = "Day\(dayNum).txt"
  let url = Bundle.main.bundleURL.appendingPathComponent("Test").appendingPathComponent(filePath)
  return readFile(url: url, separator: separator)
}

func readFile(url: URL?, separator: String = "\n") -> [String] {
  guard let url = url else { return [] }

  guard let data = try? String(contentsOf: url) else {
    return []
  }

  let dataParts = data
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: separator)
  return dataParts
}

func convertToIntegers(_ array: [String]) -> [Int] {
  let ints = array.map { Int($0) ?? 0 }
  return ints
}

var dateFormatter: DateFormatter {
  let df = DateFormatter()
  df.dateStyle = .none
  df.timeStyle = .long
  df.dateFormat = "h:mm:ss:SSS"
  return df
}

func logTime(_ desc: String) -> Date {
  let now = Date()
  let timeStamp = dateFormatter.string(from: now)
  print("\(timeStamp): \(desc)")
  return now
}

func showElapsedTime(from startTime: Date, to endTime: Date) {
  let elapsedTime = endTime.timeIntervalSince(startTime) * 1000
  let timeString = String(format: "%.1f", elapsedTime)
  print("\nTime taken: \(timeString) milliseconds")
}

extension String {
  subscript(index: Int) -> String {
    var index = index
    if index > count { return "" }
    if index < 0 {
      index = self.count + index
    }

    let stringIndex = self.index(self.startIndex, offsetBy: index)
    return String(self[stringIndex])
  }

  subscript(from: Int, upto: Int) -> String {
    var end = upto
    if end < 0 {
      end = self.count + end
    }
    let removeStart = self
      .suffix(self.count - from)
      .prefix(end - from)
    return String(removeStart)
  }

  func padLeft(to length: Int, with spacer: String = " ") -> String {
    let pad = Array.init(repeating: spacer, count: length - count)
    let paddedString = pad.joined() + self
    return paddedString
  }
}
