//
//  Day5Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 05/12/2023.
//

import Foundation

/*
 Where:
 x: Target Num from prev category
 xs: Start range for x
 d: Start range for destination

 F(x)  = x - xs + d

 Seed: 79
 seed-to-soil map:
 52 50 48

 F(79) = 79 - 50 + 52 = 81
 */

public func day5Part1(_ input: String) -> Int {
    typealias MapRange = (destination: Range<Int>, source: Range<Int>)
    var categoriesMap: [[MapRange]] = Array(repeating: [], count: 7)

    var inputByLine = input.split(whereSeparator: \.isNewline)
    let seeds: [Int] = inputByLine
        .removeFirst()
        .split(separator: ": ")
        .last!
        .split(separator: " ")
        .map({ Int(String($0))! })

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

    for seed in seeds {
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

    return minLocation
}
