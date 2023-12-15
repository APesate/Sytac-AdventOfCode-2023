//
//  Day15Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 15/12/2023.
//

import Foundation

public func day15Part2(_ input: String) -> Int {
    var boxes: [[String]] = []
    input
        .split(separator: ",")
        .forEach { processBox(String($0), &boxes) }

    return sequenceValue(boxes)
}

private func processBox(_ input: String, _ boxes: inout [[String]]) {
    let hash = hash(input)

    while (boxes.count - 1) < hash {
        boxes.append([])
    }

    if input.contains("-") {
        if let index = boxes[hash].firstIndex(where: {
            let label = $0[..<$0.firstIndex(of: "=")!]
            let newLabel = input[..<input.firstIndex(of: "-")!]
            return newLabel == label
        }) {
            boxes[hash].remove(at: index)
        }
    } else {
        if let index = boxes[hash].firstIndex(where: {
            let label = $0[..<$0.firstIndex(of: "=")!]
            let newLabel = input[..<input.firstIndex(of: "=")!]
            return newLabel == label
        }) {
            boxes[hash][index] = input
        } else {
            boxes[hash].append(input)
        }
    }
}

private func sequenceValue(_ boxes: [[String]]) -> Int {
    var res = 0

    for (index, box) in boxes.enumerated() {
        let boxNumber = index + 1
        for (lensIndex, lens) in box.enumerated() {
            let value = lensValue(lens)
            let lensValue = (value * (lensIndex + 1) * boxNumber)
            res += lensValue
        }
    }

    return res
}

private func lensValue(_ input: String) -> Int {
    if input.contains("=") {
        return Int(input.suffix(from: input.index(after: input.lastIndex(where: { $0 == "=" })!)))!
    } else {
        fatalError("Invalid input: \(input)")
    }
}

private func hash(_ input: String) -> Int {
    var res = 0

    for char in input {
        guard char.isASCII, let ascii = char.asciiValue else {
            fatalError("Invalid Char \(char)")
        }

        guard char != "=" && char != "-" else {
            break
        }

        res += Int(ascii)
        res *= 17
        res %= 256
    }

    return res
}
