//
//  Day3Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 03/12/2023.
//

import Foundation
import RegexBuilder

private typealias Symbol = (Character, ClosedRange<Int>, Int)
private typealias Number = (Int, Range<Int>, Int)
private typealias NumberSymbol = (Int, Range<Int>, Symbol)

private let number = Reference<Int>()
private let numbersRegex = Regex {
    Capture(as: number) {
        OneOrMore(.digit)
    } transform: { value in
        return Int(String(value))!
    }
}

private let symbolRegex = Regex {
    Capture {
        One("*")
    } transform: {
        String($0).first!
    }
}

public func day3ExtractEnginePart2(_ input: String) -> Int {
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

    let filtered = numbers.filter { num in
        symbols.contains { symbol in
            symbol.1.overlaps(num.1) && ((symbol.2 - 1)...(symbol.2 + 1)).contains(num.2)
        }
    }

    let numSym = filtered.compactMap { num in
        if let symbol = symbols.first(where: { symbol in
            symbol.1.overlaps(num.1) && ((symbol.2 - 1)...(symbol.2 + 1)).contains(num.2)
        }) {
            return (num.0, num.1, symbol)
        }

        return nil
    }

    var final = numSym
    var result = 0

    while !final.isEmpty {
        let num = final.removeFirst()

        let pairIndex = final.firstIndex { option in
            num.2 == option.2
        }

        if let pairIndex {
            result += final.remove(at: pairIndex).0 * num.0
        }
    }

    return result // 72246648
}
