/**
 * As they're making the final adjustments, they discover that their calibration document (your puzzle input) has been amended by a very young Elf who was
 * apparently just excited to show off her art skills. Consequently, the Elves are having trouble reading the values on the document.
 *
 * The newly-improved calibration document consists of lines of text; each line originally contained a specific calibration value that the Elves now need to recover.
 * On each line, the calibration value can be found by combining the first digit and the last digit (in that order) to form a single two-digit number.
 *
 * For example:
 *
 * 1abc2
 * pqr3stu8vwx
 * a1b2c3d4e5f
 * treb7uchet
 *
 * In this example, the calibration values of these four lines are 12, 38, 15, and 77. Adding these together produces 142.
 **/

import Foundation
import RegexBuilder

public func calibrationValue1(from input: String) -> Int {
    var result = 0
    var left: Character? = nil
    var right: Character? = nil

    // Iterate over each Character Once
    for char in input {
        // If the character is a new line it means we reach the end of an input line
        // Combine, add to the results, and reset for the next input.
        guard !char.isNewline else {
            result += Int("\(left!)\((right ?? left)!)")!
            left = nil
            right = nil
            continue
        }

        // Ignore non-decimal characters
        guard char.isNumber else {
            continue
        }

        // If it's the first number we find set it to left most pointer.
        // Otherwise right.
        if left == nil {
            left = char
        } else {
            right = char
        }
    }

    // Last character is not a new line so we miss the last input.
    // Add the value and return the function.
    return result + Int("\(left!)\((right ?? left)!)")!
}
