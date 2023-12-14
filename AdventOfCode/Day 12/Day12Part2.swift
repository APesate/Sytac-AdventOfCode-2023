//
//  Day12Part2.swift
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

private var memo: [String: Int] = [:]

public func day12Part2(_ input: String) -> Int {
    let input = parse(input)
    var result = 0

    for line in input {
        let value: [Character] = Array(Array(repeating: line.0, count: 5).joined(separator: "?"))
        let sequence = Array(repeating: line.1, count: 5).flatMap({ $0 })
        result += dpCount(value, sequence, 0, 0, 0, &memo)
        memo.removeAll()
    }

    return result
}

private func memoKey(_ i: Int, _ bi: Int, _ currentGroup: Int) -> String {
    "\(i)-\(bi)-\(currentGroup)"
}

private func dpCount(_ input: [Character], _ sequence: [Int], _ inputIndex: Int, _ groupIndex: Int, _ currentGroupSize: Int, _ memo: inout [String: Int]) -> Int {
    let key = memoKey(inputIndex, groupIndex, currentGroupSize)
    
    guard memo[key] == nil else {
        return memo[key]!
    }

    guard inputIndex != input.count else {
        return ((groupIndex == sequence.count && currentGroupSize == 0) ||
                (groupIndex == sequence.count - 1 && sequence[groupIndex] == currentGroupSize))
        ? 1 : 0
    }

    var combinations = 0

    for char in Array<Character>([".", "#"]) {
        if input[inputIndex] == char || input[inputIndex] == "?" {
            if char == "." && currentGroupSize == 0 {
                combinations += dpCount(input, sequence, inputIndex + 1, groupIndex, 0, &memo)
            } else if char == "." && currentGroupSize > 0 && groupIndex < sequence.count && sequence[groupIndex] == currentGroupSize {
                combinations += dpCount(input, sequence, inputIndex + 1, groupIndex + 1, 0, &memo)
            } else if char == "#" {
                combinations += dpCount(input, sequence, inputIndex + 1, groupIndex, currentGroupSize + 1, &memo)
            }
        }
    }
    memo[key] = combinations
    return combinations
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
