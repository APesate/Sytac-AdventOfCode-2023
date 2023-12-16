//
//  Day16Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 16/12/2023.
//

import Foundation

private enum Beam: String {
    case vSplit = "|"
    case hSplit = "-"
    case empty = "."
    case mRight = "/"
    case mLeft = "\\"
}

private enum Direction: Int {
    case right
    case left
    case up
    case down
}

private struct PathElement: CustomDebugStringConvertible {
    let type: Beam
    var isEnergised: Bool = false
    var visited: [(Int, Int, Direction)] = []

    var debugDescription: String {
        isEnergised ? "#" : type.rawValue
    }
}

public func day16Part1(_ input: String) -> Int {
    var input = input
        .split(whereSeparator: \.isNewline)
        .map { $0
            .map { PathElement(type: Beam(rawValue: String($0))!) }
        }
    energise(&input, 0, 0)

    return input.reduce(into: 0) { partialResult, line in
        partialResult += line.filter { $0.isEnergised }.count
    }
}

private func energise(_ input: inout [[PathElement]], _ oi: Int, _ oj: Int, _ odirection: Direction = .right) {
    var i = oi
    var j = oj
    var direction = odirection

    while i >= 0 && i < input.count && j >= 0 && j < input.first!.count {
        input[i][j].isEnergised = true

        switch input[i][j].type {
            case .vSplit where direction == .left || direction == .right:
                guard !input[i][j].visited.contains(where: { $0 == (oi, oj, odirection) }) else { return }

                input[i][j].visited.append((oi, oj, odirection))
                energise(&input, i - 1, j, .up)
                energise(&input, i + 1, j, .down)
                return

            case .hSplit where direction == .down || direction == .up:
                guard !input[i][j].visited.contains(where: { $0 == (oi, oj, odirection) }) else { return }

                input[i][j].visited.append((oi, oj, odirection))
                energise(&input, i, j - 1, .left)
                energise(&input, i, j + 1, .right)
                return

            case .mRight:
                guard !input[i][j].visited.contains(where: { $0 == (oi, oj, odirection) }) else { return }

                input[i][j].visited.append((oi, oj, odirection))
                let next = processMRight(input, i, j, direction)
                i = next.i
                j = next.j
                direction = next.direction

            case .mLeft:
                guard !input[i][j].visited.contains(where: { $0 == (oi, oj, odirection) }) else { return }

                input[i][j].visited.append((oi, oj, odirection))
                let next = processMLeft(input, i, j, direction)
                i = next.i
                j = next.j
                direction = next.direction

            default:
                let next = nextCoordinate(in: direction, i, j)
                i = next.i
                j = next.j
        }
    }
}

// /
private func processMRight(_ input: [[PathElement]], _ i: Int, _ j: Int, _ direction: Direction) -> (i: Int, j: Int, direction: Direction) {
    switch direction {
        case .down:
            return (i: i, j: j - 1, direction: .left)
        case .right:
            return (i: i - 1, j: j, direction: .up)
        case .left:
            return (i: i + 1, j: j, direction: .down)
        case .up:
            return (i: i , j: j + 1, direction: .right)
    }
}

// \
private func processMLeft(_ input: [[PathElement]], _ i: Int, _ j: Int, _ direction: Direction) -> (i: Int, j: Int, direction: Direction) {
    switch direction {
        case .down:
            return (i: i, j: j + 1, direction: .right)
        case .right:
            return (i: i + 1, j: j, direction: .down)
        case .left:
            return (i: i - 1, j: j, direction: .up)
        case .up:
            return (i: i , j: j - 1, direction: .left)
    }
}

private func nextCoordinate(in direction: Direction, _ i: Int, _ j: Int) -> (i: Int, j: Int) {
    switch direction {
        case .down:
            return (i: i + 1, j: j)
        case .right:
            return (i: i, j: j + 1)
        case .left:
            return (i: i, j: j - 1)
        case .up:
            return (i: i - 1, j: j)
    }
}
