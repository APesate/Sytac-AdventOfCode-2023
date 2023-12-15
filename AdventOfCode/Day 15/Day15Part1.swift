//
//  Day15Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 15/12/2023.
//

import Foundation

public func day15Part1(_ input: String) -> Int {
    input
        .split(separator: ",")
        .map({ value(String($0)) })
        .reduce(into: 0, { $0 += $1 })
}

private func value(_ input: String) -> Int {
    input.reduce(into: 0) { partialResult, char in
        guard char.isASCII, let ascii = char.asciiValue else {
            fatalError("Invalid Char \(char)")
        }

        partialResult += Int(ascii)
        partialResult *= 17
        partialResult %= 256
    }
}
