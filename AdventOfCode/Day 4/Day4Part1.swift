//
//  Day4Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 04/12/2023.
//

import Foundation
import RegexBuilder

public func day4Part1(_ input: String) -> Int {
    var result = 0

    for line in input.split(whereSeparator: \.isNewline) {
        let values = line
            .replacingOccurrences(of: "Card\\s+\\d+:", with: "", options: [.regularExpression])
            .split(separator: "|")
            .map { $0.split(separator: " ") }
            .map({ Set($0.map { Int(String($0))! } ) })

        let intersection = values.first!.intersection(values.last!)
        
        let points = intersection.reduce(0, { partial, _ in
            if partial == 0 { return 1 }
            else { return partial * 2 }
        })

        result += points
    }

    return result
}
