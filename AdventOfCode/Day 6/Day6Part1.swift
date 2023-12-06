//
//  Day6Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 06/12/2023.
//

import Foundation
//Time:      7  15   30
//Distance:  9  40  200
// D = v * t
// F(x) = v * (t-v)
func day6Part1(_ input: String) -> Int {
    let input = input
        .split(whereSeparator: \.isNewline)
        .map {
            $0
                .split(separator: ":")
                .last!
                .trimmingCharacters(in: .whitespaces)
                .split(separator: " ")
                .map { Int(String($0))! }
        }
    let (times, distances) = (input.first!, input.last!)
    var winsPerRace: [Int] = []

    for race in (0..<times.count) {
        let (maxTime, targetDitance) = (times[race], distances[race])
        var possibleWins = 0

        for pressTime in (0...maxTime) {
            let distance = pressTime * (maxTime - pressTime)
            possibleWins += (distance > targetDitance) ? 1 : 0
        }

        winsPerRace.append(possibleWins)
    }

    return winsPerRace.reduce(1, { $0 * $1 })
}
