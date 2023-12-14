//
//  Day13Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 13/12/2023.
//

import Foundation

/*
 #.##..##.
 ..#.##.#.
 ##......#
 ##......#
 ..#.##.#.
 ..##..##.
 #.#.##.#.

 #...##..#
 #....#..#
 ..##..###
 #####.##.
 #####.##.
 ..##..###
 #....#..#
 */

private let x =
"""
.##.#.#
###..##
#..#.#.
#..#...
#..#...
#.##.#.
###..##
.##.#.#
.##.#.#
###..##
#.##.#.
#..#...
#..#...
#..#.#.
###..##
.##.#.#
....#..
"""

// 28481 Low
// 30283 x
// 31083 x
// 31971 x

public func day13Part1(_ input: String) -> Int {
    let input = parse(input)
    var result = 0

    for (index, section) in input.enumerated() {
        print("\(index): [V: \(hasVerticalReflection(section) ?? -1), H: \(hasHorizontalReflection(section) ?? -1)]")
        
        let ver = hasVerticalReflection(section) ?? -1
        let hor = hasHorizontalReflection(section) ?? -1

        guard ver != -1 || hor != -1 else {
            fatalError("Unparsed input\n\(section.map({ String($0) }).joined(separator: "\n"))")
        }

        if ver > hor {
            result += ver
        } else {
            result += hor * 100
        }
    }

    return result
}

private func hasVerticalReflection(_ input: [[Character]]) -> Int? {
    var map: [String: [Int]] = [:]
    var midPoint: [Int] = []

    for j in (0..<input.first!.count) {
        var key = ""
        for i in (0..<input.count) {
            key.append(String(input[i][j]))
        }

        if map[key] != nil {
            if map[key]!.contains(j - 1) && checkVerticalMidPoint(input, j - 1, map) {
                midPoint.append(j - 1)
            }
            map[key]?.append(j)
        } else {
            map[key] = [j]
        }
    }

    return midPoint.last != nil ? midPoint.last! + 1 : nil
}

private func checkVerticalMidPoint(_ input: [[Character]], _ midPoint: Int, _ map: [String: [Int]]) -> Bool {
    var reflectionPointToCheck = midPoint - 1

    for j in ((midPoint + 2)..<input.first!.count) where reflectionPointToCheck >= 0 {
        var key = ""
        for i in (0..<input.count) {
            key.append(String(input[i][j]))
        }

        guard map[key] != nil && map[key]!.contains(reflectionPointToCheck) else {
            return false
        }
        reflectionPointToCheck -= 1
    }

    return true
}

private func hasHorizontalReflection(_ input: [[Character]]) -> Int? {
    var map: [String: [Int]] = [:]
    var midPoint: [Int] = []

    for i in (0..<input.count) {
        var key = ""
        for j in (0..<input.first!.count) {
            key.append(String(input[i][j]))
        }

        if map[key] != nil {
            if map[key]!.contains(i - 1) && checkHorizontalMidPoint(input, i - 1, map) {
                midPoint.append(i - 1)
            }
            map[key]?.append(i)
        } else {
            map[key] = [i]
        }
    }

    return midPoint.last != nil ? midPoint.last! + 1 : nil
}

private func checkHorizontalMidPoint(_ input: [[Character]], _ midPoint: Int, _ map: [String: [Int]]) -> Bool {
    var reflectionPointToCheck = midPoint - 1

    for i in ((midPoint + 2)..<input.count) where reflectionPointToCheck >= 0 {
        var key = ""
        for j in (0..<input.first!.count) {
            key.append(String(input[i][j]))
        }

        guard map[key] != nil && map[key]!.contains(reflectionPointToCheck) else {
            return false
        }
        reflectionPointToCheck -= 1
    }

    return true
}

/*
 #.##..##.
 ..#.##.#.
 ##......#
 ##......#
 ..#.##.#.
 ..##..##.
 #.#.##.#.
 */

private func parse(_ input: String) -> [[[Character]]] {
    input
        .split(separator: "\n\n")
        .map {
            $0
                .split(whereSeparator: \.isNewline)
                .map { $0.compactMap { $0 } }
        }
}
