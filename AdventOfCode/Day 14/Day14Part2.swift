//
//  Day14Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 14/12/2023.
//

import Foundation

public func day14Part2(_ input: String) -> Int {
    var input = parse(input)
    let targetCycles = NSDecimalNumber(decimal: pow(10, 9)).intValue
    return execCycles(targetCycles, &input)
}

private func execCycles(_ cyclesToRun: Int, _ input: inout [[Character]]) -> Int {
    var scores: [Int: [Int]] = [:]
    var i = 0
    var cycleLength = 0
    var cycleScore: Int = 0

    while i < cyclesToRun {
        defer { i += 1 }
        for _ in 1...4 {
            rollUp(&input)
            rotateRight(&input)
        }
        cycleScore = score(input)
        scores[cycleScore] = (scores[cycleScore] ?? []) + [i]
        print("(\(i)): \(cycleScore) -> \(scores[cycleScore]!)")

        guard scores.filter({ $0.value.count > 5}).count > 3 && cycleLength == 0 else {
            continue
        }
        
        let max = scores.filter({ $0.value.count > 5}).max(by: { $0.value.count > $1.value.count })
        cycleLength = max!.value.last! - max!.value[max!.value.count - 2]

        if cycleLength > 5 {
            i += ((cyclesToRun - i) / cycleLength) * cycleLength
        }
    }

    return cycleScore
}

private func rollUp(_ input: inout [[Character]]) {
    for j in 0..<input.first!.count {
        for i in 0..<input.count {
            if input[i][j] == "O" && i > 0 {
                var pi = i
                var found = false
                while pi > 0 {
                    guard input[pi - 1][j] == "." else { break }
                    pi -= 1
                    found = true
                }
                if found {
                    input[pi][j] = "O"
                    input[i][j] = "."
                }
            }
        }
    }
}

private func score(_ input: [[Character]]) -> Int {
    var score = 0
    for i in 0..<input.count {
        score += (input.count - i) * input[i].filter({ $0 == "O" }).count
    }
    return score
}

private func parse(_ input: String) -> [[Character]] {
    input
        .split(whereSeparator: \.isNewline)
        .map { $0.compactMap { $0 } }
}

private func rotateRight(_ grid: inout [[Character]]) {
    let n = grid.count
    for i in 0..<(n / 2) {
        for j in i..<(n - i - 1) {
            let temp = grid[i][j]
            grid[i][j] = grid[n - 1 - j][i]
            grid[n - 1 - j][i] = grid[n - 1 - i][n - 1 - j]
            grid[n - 1 - i][n - 1 - j] = grid[j][n - 1 - i]
            grid[j][n - 1 - i] = temp
        }
    }
}

