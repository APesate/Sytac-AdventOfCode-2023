import Foundation
import RegexBuilder

/**
 --- Part Two --- "Optimal"
 *
 * Your calculation isn't quite right. It looks like some of the digits are actually spelled out with letters: one, two, three, four, five, six, seven, eight, and nine also count as valid "digits".
 *
 * Equipped with this new information, you now need to find the real first and last digit on each line. For example:
 *
 * two1nine
 * eightwothree
 * abcone2threexyz
 * xtwone3four
 * 4nineeightseven2
 * zoneight234
 * 7pqrstsixteen
 * In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76. Adding these together produces 281.
 */

// MARK: - Naive

let numbers: [String: Int] = [
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
]

let numbersReversed: [String: Int] = [
    "eno": 1,
    "owt": 2,
    "eerht": 3,
    "ruof": 4,
    "evif": 5,
    "xis": 6,
    "neves": 7,
    "thgie": 8,
    "enin": 9,
]

let numberRegex = Regex {
    Capture {
        ChoiceOf {
            "one"
            "two"
            "three"
            "four"
            "five"
            "six"
            "seven"
            "eight"
            "nine"
            One(.digit)
        }
    } transform: { value -> Int in
        guard value.count > 1 else {
            return Int(value)!
        }

        return numbers[String(value)]!
    }
}

let numberInvertedRegex = Regex {
    Capture {
        ChoiceOf {
            "eno"
            "owt"
            "eerht"
            "ruof"
            "evif"
            "xis"
            "neves"
            "thgie"
            "enin"
            One(.digit)
        }
    } transform: { value -> Int in
        guard value.count > 1 else {
            return Int(value)!
        }

        return numbersReversed[String(value)]!
    }
}

public func calibrationValue2(from input: String) -> Int {

    var result = 0

    for line in input.split(whereSeparator: \.isNewline) {
        let firstMatch = try! numberRegex.firstMatch(in: line)!.output.1
        let lastMatch = try! numberInvertedRegex.firstMatch(in: String(line.reversed()))!.output.1
        print("\(line) -> \(firstMatch)\(lastMatch)")
        result += Int("\(firstMatch)\(lastMatch)") ?? 0
    }

    return result
}

// MARK: - Optimisation Attempt

//let numbers: [String: Character] = [
//    "one": Character("1"),
//    "two": Character("2"),
//    "three": Character("3"),
//    "four": Character("4"),
//    "five": Character("5"),
//    "six": Character("6"),
//    "seven": Character("7"),
//    "eight": Character("8"),
//    "nine": Character("9"),
//    "zero": Character("0")
//]
//
//public func calibrationValue2(from input: String) -> Int {
//
//    var result = 0
//    var left: Character? = nil
//    var right: Character? = nil
//    var line = ""
//    var window = ""
//
//    for (char) in input {
//        guard !char.isNewline else {
//            print("\(line) => \(Int("\(left!)\((right ?? left)!)")!)")
//            result += Int("\(left!)\((right ?? left)!)")!
//            left = nil
//            right = nil
//            window.removeAll()
//            line.removeAll()
//            continue
//        }
//        line.append(char)
//
//        if char.isNumber {
//            // If the char is a number, reset the window.
//            window.removeAll()
//            processNumber(char, left: &left, right: &right)
//        } else {
//            window.append(char)
//            if couldBeValid(window) {
//                processString(&window, left: &left, right: &right)
//            } else {
//                window.removeFirst(window.count - 1)
//            }
//        }
//    }
//
//    // If the window is not empty, we might have a last number to process
//    if !window.isEmpty {
//        processString(&window, left: &left, right: &right)
//    }
//
//    window
//    print("\(line) => \(Int("\(left!)\((right ?? left)!)")!)")
//    // Last character is not a new line so we miss the last input.
//    // Add the value and return the function.
//    return result + Int("\(left!)\((right ?? left)!)")!
//}
//
//func processNumber(_ char: Character, left: inout Character?, right: inout Character?) {
//    // If it's the first number we find set it to left most pointer.
//    // Otherwise right.
//    if left == nil {
//        left = char
//    } else {
//        right = char
//    }
//}
//
//func processString(_ window: inout String, left: inout Character?, right: inout Character?) {
//    guard let value = numbers[window] else {
//        return
//    }
//
//    processNumber(value, left: &left, right: &right)
//    window.removeFirst(window.count - 1)
//}
//
//func couldBeValid(_ window: String) -> Bool {
//    return numbers.keys.contains {
//        $0.hasPrefix(window)
//    }
//}
//

