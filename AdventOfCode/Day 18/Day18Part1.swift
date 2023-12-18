//
//  Day18Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 18/12/2023.
//

import Foundation
import SwiftUI
import RegexBuilder

private let DirectionRef = Reference<Direction>()
private let StepsRef = Reference<Int>()
private let ColorRef = Reference<String>()
private let inputRegex = Regex {
    Capture(as: DirectionRef) {
        ("A"..."Z")
    } transform: { w in
        return Direction(rawValue: String(w))!
    }
    One(.whitespace)
    Capture(as: StepsRef) {
        OneOrMore(.digit)
    } transform: { w in
        return Int(String(w))!
    }
    " ("
    Capture(as: ColorRef) {
        "#"
        OneOrMore {
            CharacterClass(
                ("A"..."Z"),
                ("a"..."z"),
                ("0"..."9")
            )
        }
    } transform: { w in
        return String(w)
    }
}

private enum Direction: String {
    case up = "U"
    case down = "D"
    case right = "R"
    case left = "L"
}
private typealias Input = (direction: Direction, steps: Int, color: String)

// VERY NAIVE SOLUTION!
public func day18Part1(_ input: String) -> Int {
    let input: [Input] = input
        .split(whereSeparator: \.isNewline)
        .map {
            $0.matches(of: inputRegex).map { ($0[DirectionRef], $0[StepsRef], $0[ColorRef]) }.first!
        }
    return lagoonSize(input)
}

private func lagoonSize(_ input: [Input]) -> Int {
    var lagoon: [[Character]] = [[]]
    var current: (i: Int, j: Int) = (-1, -1)

    for line in input {
        for _ in 0..<line.steps {
            switch line.direction {
                case .up:
                    current.i -= 1
                case .down:
                    current.i += 1
                case .right:
                    current.j += 1
                case .left:
                    current.j -= 1
            }
            extendGridIfNeeded(&lagoon, &current)
            lagoon[current.i][current.j] = "#"
        }
    }

    let startingPoint = findInternalPoint(grid: lagoon)!
    floodLagoon(&lagoon, startingPoint.0, startingPoint.1)

    return lagoon.reduce(into: 0, { $0 += $1.filter { $0 == "#" }.count })
}

private func extendGridIfNeeded(_ grid: inout [[Character]], _ coordinate: inout (i: Int, j: Int)) {
    if coordinate.i < 0 {
        grid.insert(Array(repeating: ".", count: grid.first?.count ?? 1), at: 0)
        coordinate = (0, coordinate.j)
    } else if coordinate.i >= grid.count {
        grid.append(Array(repeating: ".", count: grid.first?.count ?? 1))
    }

    if coordinate.j < 0 {
        grid = grid.map {
            var line = $0
            line.insert(".", at: 0)
            return line
        }
        coordinate = (coordinate.i, 0)
    } else if coordinate.j >= grid.first!.count {
        grid = grid.map {
            var line = $0
            line.append(".")
            return line
        }
    }
}

private func floodLagoon(_ grid: inout [[Character]], _ x: Int, _ y: Int) {
    if x < 0 || x >= grid.count || y < 0 || y >= grid[0].count || grid[x][y] != "." {
        return
    }

    grid[x][y] = "#"

    floodLagoon(&grid, x + 1, y)
    floodLagoon(&grid, x - 1, y)
    floodLagoon(&grid, x, y + 1)
    floodLagoon(&grid, x, y - 1)
}

private func findInternalPoint(grid: [[Character]]) -> (Int, Int)? {
    let rowCount = grid.count
    let colCount = grid[0].count

    for x in 1..<(rowCount - 1) {
        for y in 1..<(colCount - 1) {
            if grid[x][y] == "." && !isConnectedToBorder(grid: grid, x: x, y: y) {
                return (x, y)
            }
        }
    }
    return nil
}

private func isConnectedToBorder(grid: [[Character]], x: Int, y: Int) -> Bool {
    let rowCount = grid.count
    let colCount = grid.first!.count
    var stack: [(Int, Int)] = [(x, y)]
    var visited = Set<String>()

    while !stack.isEmpty {
        let (currX, currY) = stack.removeLast()

        // Skip if out of bounds or already visited
        if currX < 0 || currY < 0 || currX >= rowCount || currY >= colCount || visited.contains("\(currX),\(currY)") {
            continue
        }

        // If it's a border, return true
        if currX == 0 || currY == 0 || currX == rowCount - 1 || currY == colCount - 1 {
            if grid[currX][currY] == "." {
                return true
            } else {
                continue
            }
        }

        // If it's not a '.', it's a border character, so continue
        if grid[currX][currY] != "." {
            continue
        }

        // Mark as visited
        visited.insert("\(currX),\(currY)")

        // Add adjacent cells to the stack
        stack.append((currX + 1, currY))
        stack.append((currX - 1, currY))
        stack.append((currX, currY + 1))
        stack.append((currX, currY - 1))
    }

    return false
}
