//
//  Day9Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 09/12/2023.
//

import Foundation

public func day9Part2(_ input: String) -> Int {
    input
        .split(whereSeparator: \.isNewline)
        .map {
            $0
                .split(separator: " ")
                .map { Int(String($0))! }
        }
        .map(prediction(for:))
        .reduce(0, { $0 + $1 })
}

private func prediction(for input: [Int]) -> Int {
    guard !input.allSatisfy({ $0 == 0 }) else { return 0 }

    let diff: [Int] = input.enumerated().reduce(into: []) { partialResult, element in
        guard element.offset > 0 else { return }
        partialResult.append(element.element - input[element.offset - 1])
    }
    let prediction = prediction(for: diff)
    return input.first! - prediction
}
