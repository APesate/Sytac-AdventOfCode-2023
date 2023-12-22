//
//  Day21Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 21/12/2023.
//

import Foundation
/*
 ...........
 .....###.#.
 .###.##.O#.
 .O#O#O.O#..
 O.O.#.#.O..
 .##O.O####.
 .##.O#O..#.
 .O.O.O.##..
 .##.#.####.
 .##O.##.##.
 ...........
 */

public func day21Part1(_ input: String) -> Int {
    let parsed: [[Coordinate]] = input
        .split(whereSeparator: \.isNewline)
        .enumerated()
        .map { (row, line) in
            line
                .enumerated()
                .map { (col, char) in
                    Coordinate(location: .init(row, col), terrain: Terrain(char)!)
                }
        }
    return locations(5000, parsed)
}

private func locations(_ steps: Int, _ grid: [[Coordinate]]) -> Int {
    var grid = grid
    let startCoor = grid.first(where: { $0.first(where: { $0.terrain == .standing}) != nil })!.first(where: { $0.terrain == .standing })!.location

    fill(&grid, startCoor, steps, steps % 2 == 0)

//    print("\(grid.map({ $0.debugDescription }).joined(separator: "\n"))")

    return grid.reduce(into: 0, {
        $0 += $1.filter({ $0.isReachable }).count
    })
}

private func fill(_ grid: inout [[Coordinate]], _ location: Point, _ steps: Int, _ isEven: Bool) {
    if steps < 0
        || location.x < 0
        || location.y < 0
        || location.y >= grid.first!.count
        || location.x >= grid.count
        || grid[location.x][location.y].terrain == .rock
        || grid[location.x][location.y].visited.contains(steps) {
        return
    }

    grid[location.x][location.y].visited.append(steps)
    grid[location.x][location.y].isReachable = (isEven && steps % 2 == 0) || (!isEven && steps % 2 != 0)

    fill(&grid, location.up, steps - 1, isEven)
    fill(&grid, location.right, steps - 1, isEven)
    fill(&grid, location.down, steps - 1, isEven)
    fill(&grid, location.left, steps - 1, isEven)
}

private enum Terrain: String {
    case garden = "."
    case rock = "#"
    case standing = "S"

    init?(_ rawValue: Character) {
        switch String(rawValue) {
            case Terrain.garden.rawValue:
                self = .garden
            case Terrain.rock.rawValue:
                self = .rock
            case Terrain.standing.rawValue:
                self = .standing
            default:
                return nil
        }
    }
}

private struct Coordinate: CustomDebugStringConvertible {
    let location: Point
    let terrain: Terrain
    var isReachable: Bool = false
    var visited: [Int] = []

    var debugDescription: String {
        terrain == .standing && isReachable ? "@"
        : isReachable ? "O"
        : visited.count != 0 ? "_"
        : terrain.rawValue
    }
}

private struct Point: Hashable {
    var x: Int
    var y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    var up: Point {
        Point(x - 1, y)
    }

    var down: Point {
        Point(x + 1, y)
    }

    var left: Point {
        Point(x, y - 1)
    }

    var right: Point {
        Point(x, y + 1)
    }
}
