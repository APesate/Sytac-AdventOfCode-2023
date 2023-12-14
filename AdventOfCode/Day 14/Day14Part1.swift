//
//  Day14Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 14/12/2023.
//

import Foundation
/*
 O....#....
 O.OO#....#
 .....##...
 OO.#O....O
 .O.....O#.
 O.#..O.#.#
 ..O..#O..O
 .......O..
 #....###..
 #OO..#....
 */

public func day14Part1(_ input: String) -> Int {
    var input = parse(input)
    rollUp(&input)
    return score(input)
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
