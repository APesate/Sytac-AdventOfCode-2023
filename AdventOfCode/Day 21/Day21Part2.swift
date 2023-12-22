//
//  Day21Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 21/12/2023.
//

import Foundation

private var distanceCache = [Point: Int]()

public func day21Part2(_ input: String) -> Int {
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


    let startCoor = parsed.first(where: { $0.first(where: { $0.terrain == .standing}) != nil })!.first(where: { $0.terrain == .standing })!.location

    bfs(grid: parsed, start: startCoor)

    let reachableLocations = calculateReachableLocations(distances: distanceCache, gridSize: parsed.count, maxSteps: 5000)
//    16733044
    return reachableLocations
}

private func bfs(grid: [[Coordinate]], start: Point) {
    let gridSize = grid.count
    var queue = [(start.x, start.y, 0)]  // (row, col, steps)
    var visited = Set<Point>()

    while !queue.isEmpty {
        let (row, col, steps) = queue.removeFirst()
        let wrappedRow = (row + gridSize) % gridSize
        let wrappedCol = (col + gridSize) % gridSize

        if visited.contains(Point(wrappedRow, wrappedCol)) {
            continue
        }
        visited.insert(Point(wrappedRow, wrappedCol))
        distanceCache[Point(wrappedRow, wrappedCol)] = steps

        for (dr, dc) in [(-1, 0), (0, 1), (1, 0), (0, -1)] {
            let newRow = fittingIndex(row + dr, grid, isColumnIndex: false)
            let newCol = fittingIndex(col + dc, grid, isColumnIndex: true)

            if grid[newRow][newCol].terrain.rawValue != "#" {
                queue.append((newRow, newCol, steps + 1))
            }
        }
    }
}

private func calculateReachableLocations(distances: [Point: Int], gridSize: Int, maxSteps: Int) -> Int {
    var reachableCount = 0
    let gridRepeats = maxSteps / gridSize

    for (point, steps) in distances {
        if steps > maxSteps || steps % 2 != maxSteps % 2 {
            continue
        }
        let row = point.x
        let col = point.y

        // Count locations on edges and corners with special handling
        let onEdge = row == 0 || col == 0 || row == gridSize - 1 || col == gridSize - 1
        let onCorner = (row == 0 || row == gridSize - 1) && (col == 0 || col == gridSize - 1)

        if onCorner {
            // Corner points represent 4x replicated points
            reachableCount += 4 * (gridRepeats * gridRepeats)
        } else if onEdge {
            // Edge points represent 2x replicated points
            reachableCount += 2 * (gridRepeats * gridRepeats)
        } else {
            // Interior points are unique
            reachableCount += gridRepeats * gridRepeats
        }
    }

    return reachableCount
}

private func fittingIndex(_ index: Int, _ grid: [[Coordinate]], isColumnIndex: Bool) -> Int {
    var index = index
    if isColumnIndex {
        if index >= grid.first!.count {
            index = index - grid.first!.count
        } else if index < 0 {
            index = index + grid.first!.count
        }
    } else {
        if index >= grid.count {
            index = index - grid.count
        } else if index < 0 {
            index = index + grid.count
        }
    }

    return index
}

// MARK: - Auxiliary

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
