//
//  Day4Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 04/12/2023.
//

import Foundation

public func day4Part2(_ input: String) -> Int {
    var result = 0
    var copies: [Int] = Array(repeating: 0, count: input.split(whereSeparator: \.isNewline).count)

    for (cardIndex, line) in input.split(whereSeparator: \.isNewline).enumerated() {
        let values = line
            .replacingOccurrences(of: "Card\\s+\\d+:", with: "", options: [.regularExpression])
            .split(separator: "|")
            .map { $0.split(separator: " ") }
            .map({ Set($0.map { Int(String($0))! } ) })

        let winningNumbers = values.first!.intersection(values.last!).count

        if winningNumbers > 0 {
            for offset in 1...winningNumbers {
                let copyIndex = cardIndex + offset
                copies[copyIndex] += 1 + (1 * copies[cardIndex])
            }
        }

        result += 1 + copies[cardIndex]
    }

    return result
}
