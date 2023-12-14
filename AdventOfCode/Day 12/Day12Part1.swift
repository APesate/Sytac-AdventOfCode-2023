//
//  Day12Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 12/12/2023.
//

import Foundation
import RegexBuilder
/*
 ???.### 1,1,3
 .??..??...?##. 1,1,3
 ?#?#?#?#?#?#?#? 1,3,1,6
 ????.#...#... 4,1,1
 ????.######..#####. 1,6,5
 ?###???????? 3,2,1
 */

private let notWorkingRegex = Regex {
    OneOrMore {
        Capture {
            OneOrMore("#")
        }
    }
}

public func day12Part1(_ input: String) -> Int {
    let input = parse(input)
    var result = 0

    for line in input {
        result += backtrack(line.0, line.0.startIndex, line.1, 0)
    }

    return result
}

private func backtrack(_ input: String, _ index: String.Index, _ sequence: [Int], _ group: Int) -> Int {
    guard input.endIndex > index else {

        return isValidSequence(input, sequence) ? 1 : 0
    }

    if group >= sequence.count {
        if input[index] == "#" {
            return 0
        } else {

            return isValidSequence(input, sequence) ? 1 : 0
        }
    }

    guard input[index] == "?" else {
        if isGroupCompleted(input, index, sequence, group) {
            if input[index] == "." {
                return backtrack(input, input.index(after: index), sequence, group + 1)
            } else { // #

                return 0
            }
        } else {
            if input[index] == "." && input.distance(from: input.startIndex, to: index) != 0 && input[input.index(before: index)] == "#" {

                return 0
            } else { // #
                return backtrack(input, input.index(after: index), sequence, group)
            }
        }
    }

    var input = input

    guard !isGroupCompleted(input, index, sequence, group) else {
        input = input.replacingCharacters(in: index...index, with: ".")
        return backtrack(input, input.index(after: index), sequence, group + 1)
    }

    var combinations = 0

    for char in ["#", "."] {
        input = input.replacingCharacters(in: index...index, with: char)

        combinations += backtrack(input, input.index(after: index), sequence, group)
    }

    return combinations
}

private func isValidSequence(_ input: String, _ sequence:  [Int]) -> Bool {
    input
        .matches(of: notWorkingRegex)
        .map { $0.output.0.count }
    == sequence
}

private func isGroupCompleted(_ input: String, _ index: String.Index, _ sequence: [Int], _ group: Int) -> Bool {
    let groupSize = sequence[group]
    let distance = input.distance(from: input.startIndex, to: index) - groupSize

    guard distance >= 0 else { return false }

    let lowerBound = input.index(input.startIndex, offsetBy: input.distance(from: input.startIndex, to: index) - groupSize, limitedBy: input.endIndex)

    guard let lowerBound else { return false }

    return input[lowerBound..<index].allSatisfy({ $0 == "#" })
}

private func parse(_ input: String) -> [(String, [Int])] {
    input
        .split(whereSeparator: \.isNewline)
        .map {
            let parts = $0
                .split(separator: " ")

            return (
                String(parts.first!),
                parts
                    .last!
                    .split(separator: ",")
                    .map { Int(String($0))! }
            )
        }
}
