//
//  Day5Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 05/12/2023.
//

import Foundation
import RegexBuilder

/*
 Where:
 x: Target Num from prev category
 xs: Start range for x
 d: Start range for destination

 F(x) = x - xs + d => x = Fx + xs - d

 Seed: 79
 seed-to-soil map:
 52 50 48

 F(79) = 79 - 50 + 52 = 81
 */
// 79 14 55 13

let pairRegex =
Regex {
    Capture {
        Regex {
            OneOrMore(.digit)
            One(.whitespace)
            OneOrMore(.digit)
        }
    }
}

public func day5Part2(_ input: String) -> Int {
    typealias MapRange = (destination: Range<Int>, source: Range<Int>)
    var categoriesMap: [[MapRange]] = Array(repeating: [], count: 7)

    var inputByLine = input.split(whereSeparator: \.isNewline)
    var seedsRange: [Range<Int>] = []

    let seedsInput = String(inputByLine
        .removeFirst()
        .split(separator: ": ")
        .last!)

    for match in seedsInput.matches(of: pairRegex) {
        let value = match
            .output
            .1
            .split(separator: " ")
            .map({ Int(String($0))! })

        seedsRange.append((value.first!..<(value.first! + value.last!)))
    }

    var categoryCount = -1 // Start at -1 cause I'm lazy to remove the first \n and category title

    for line in inputByLine where line.first?.isNewline == false  {
        guard !line.contains("map") else {
            categoryCount += 1
            continue
        }
        let values = line
            .split(separator: " ")
            .map({ Int(String($0))! })

        categoriesMap[categoryCount]
            .append((destination: (values.first!..<(values.first! + values.last!)),
                     source: (values[1]..<(values[1] + values.last!)))
            )
    }

    var minLocation = Int.max

    for seedRange in seedsRange {
        for seed in seedRange {
            var sourceValue = seed

            for map in categoriesMap {
                let category = map.first(where: {
                    $0.source.contains(sourceValue)
                })

                guard let category else { continue }

                sourceValue = sourceValue - category.source.lowerBound + category.destination.lowerBound
            }
            minLocation = min(minLocation, sourceValue)
        }
    }

    return minLocation
}
