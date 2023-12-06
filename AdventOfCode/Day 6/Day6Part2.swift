//
//  Day6Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 06/12/2023.
//

import Foundation

//Time:      7  15   30
//Distance:  9  40  200
// D = v * t
// F(x) = v * (t-v)
func day6Part2(_ input: String) -> Int {
    let input = input
        .split(whereSeparator: \.isNewline)
        .map {
            Int(
                String($0
                    .split(separator: ":")
                    .last!
                )
                .replacingOccurrences(of: " ", with: "")
            )!

        }
    let (time, distance) = (input.first!, input.last!)
    var possibleWins = 0

    for pressTime in (0...time) {
        let possibleDistance = pressTime * (time - pressTime)
        possibleWins += (possibleDistance > distance) ? 1 : 0
    }

    return possibleWins
}
