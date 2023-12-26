//
//  Day24Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 24/12/2023.
//

import Foundation

public func day24Part1(_ input: String) -> Int {
    let parsed = input
        .split(whereSeparator: \.isNewline)
        .enumerated()
        .map {
            let parts = $1.split(separator: " @ ")
            let loc = parts.first!.split(separator: ",").map { Int(String($0).trimmingCharacters(in: .whitespaces))! }
            let speed = parts.last!.split(separator: ",").map { Double(String($0).trimmingCharacters(in: .whitespaces))! }
            var asciiValue = ($0 % 57) + 65
            asciiValue = asciiValue != 92 ? asciiValue : 47
            return Hail(
                id: String(repeating: UnicodeScalar(asciiValue)!.escaped(asASCII: true), count: Int(floor(Double($0)/57.0)) + 1),
                location: .init(x: loc[0], y: loc[1]),
                speed: .init(x: speed[0], y: speed[1])
            )
        }

    return eval(parsed)
}

private func eval(_ hails: [Hail]) -> Int {
    let min = 200000000000000 // 7
    let max = 400000000000000 // 27
    let frame = CGRect(x: min, y: min, width: max - min, height: max - min)
    var count = 0

    for i in 0..<hails.count {
        let comparing = hails[i]
        for j in (i + 1)..<hails.count {
            let other = hails[j]
            guard let intersection = comparing.intersects(with: other) else {
                continue
            }
            let inBounds = frame.contains(intersection)
            count += inBounds ? 1 : 0
        }
    }

    return count
}

private struct Hail {
    let id: String
    var location: CGPoint
    var speed: Speed
    var slope: Double {
        speed.y / speed.x
    }
    var constant: Double {
        location.y - (slope * location.x)
    }

    // y = mx + b
    func intersects(with other: Hail) -> CGPoint? {
        // No intersection point for parallel lines
        if slope == other.slope {
            return nil
        }

        let x = (other.constant - constant) / (slope - other.slope)
        let y = slope * x + constant
        let intersection = CGPoint(x: x, y: y)

        let isInFutureForSelf = (speed.x > 0 && intersection.x > location.x) || (speed.x < 0 && intersection.x < location.x)
        let isInFutureForOther = (other.speed.x > 0 && intersection.x > other.location.x) || (other.speed.x < 0 && intersection.x < other.location.x)

        if isInFutureForSelf && isInFutureForOther {
            return intersection
        } else {
            return nil
        }
    }
}

private struct Speed {
    let x: Double
    let y: Double
}

