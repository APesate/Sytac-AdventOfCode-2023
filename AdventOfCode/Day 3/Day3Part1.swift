//
//  Day3Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 03/12/2023.
//

import Foundation
import RegexBuilder

private typealias Symbol = (Character, ClosedRange<Int>, Int)
private typealias Number = (Int, Range<Int>, Int)

private let number = Reference<Int>()
private let numbersRegex = Regex {
    Capture(as: number) {
        OneOrMore(.digit)
    } transform: { value in
        return Int(String(value))!
    }
}

private let category = CharacterClass.generalCategory(.decimalNumber).inverted.subtracting(.anyOf(".\n"))
private let symbolRegex = Regex {
    Capture {
        One(category)
    } transform: {
        String($0).first!
    }
}

public func day3ExtractEnginePart1(_ input: String) -> Int {
    var symbols: [Symbol] = []
    var numbers: [Number] = []

    for (row, line) in input.split(whereSeparator: \.isNewline).enumerated() {
        symbols.append(contentsOf: line.matches(of: symbolRegex).map { match in
            return (match.output.1,
                    ((line.distance(from: line.startIndex, to: match.range.lowerBound) - 1)...(line.distance(from: line.startIndex, to: match.range.lowerBound) + 1)),
                    row)
        })

        numbers.append(contentsOf: line.matches(of: numbersRegex).map({ match in
            return (match.output.1,
                    ((line.distance(from: line.startIndex, to: match.range.lowerBound))..<(line.distance(from: line.startIndex, to: match.range.upperBound))),
                    row)
        }))
    }

    return numbers.filter { num in
        symbols.contains { symbol in
            symbol.1.overlaps(num.1) && ((symbol.2 - 1)...(symbol.2 + 1)).contains(num.2)
        }
    }.reduce(0, {
        $0 + $1.0
    })
}
