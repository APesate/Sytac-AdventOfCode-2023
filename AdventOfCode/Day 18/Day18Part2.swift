//
//  Day18Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 18/12/2023.
//

import Foundation
import SwiftUI
import RegexBuilder
import SpriteKit

private let StepsCodeRef = Reference<Input>()
private let inputRegex = Regex {
    "#"
    Capture(as: StepsCodeRef) {
        OneOrMore {
            CharacterClass(
                ("A"..."Z"),
                ("a"..."z"),
                ("0"..."9")
            )
        }
    } transform: { w in
        let value = String(w)
        let steps = Int(value[..<value.index(before: value.endIndex)], radix: 16)!
        let direction = Direction(rawValue: Int(String(value.last!))!)!
        return (direction, steps)
    }
}

private enum Direction: Int {
    case right = 0
    case down = 1
    case left = 2
    case up = 3
}

private typealias Input = (direction: Direction, steps: Int)

public func day18Part2(_ input: String) -> Int {
    let input: [Input] = input
        .split(whereSeparator: \.isNewline)
        .map { $0.matches(of: inputRegex).map { $0[StepsCodeRef] }.first! }
    return lagoonSize(input)
}

private func polygonArea(path: CGPath) -> Int {
    var area: CGFloat = 0.0
    var points: [CGPoint] = []

    path.applyWithBlock { element in
        let elementPoints = element.pointee.points
        let type = element.pointee.type

        switch type {
            case .moveToPoint, .addLineToPoint:
                points.append(elementPoints[0])
            case .closeSubpath:
                points.append(points.first!)
            default:
                break
        }
    }

    // Shoelace formula
    for i in 0..<points.count - 1 {
        area += (points[i].x * points[i + 1].y) - (points[i + 1].x * points[i].y)
    }

    return Int(abs(area / 2.0))
}

private func lagoonSize(_ input: [Input]) -> Int {
    var current: (x: Int, y: Int) = (0, 0)
    var perimeter = 0
    let path = CGMutablePath()
    path.move(to: .zero)


    for line in input {
        perimeter += line.steps
        switch line.direction {
            case .up:
                current.x -= line.steps
            case .down:
                current.x += line.steps
            case .right:
                current.y += line.steps
            case .left:
                current.y -= line.steps
        }

        path.addLine(to: .init(x: current.x, y: current.y))
    }
    path.closeSubpath()

    // Picks Theorem A=I+(B/2)-1
    let area = polygonArea(path: path) // A
    let interiorPoints = (area - perimeter / 2 + 1) // I

    // Total Area
    return interiorPoints + perimeter
}
