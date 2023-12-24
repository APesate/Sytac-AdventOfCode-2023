//
//  Day23Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 23/12/2023.
//

import Foundation

private var dp: [[Int]]!

public func day23Part1(_ input: String) -> Int {
    let grid = Grid(
        input
            .split(whereSeparator: \.isNewline)
            .map({ $0.map { $0 } })
    )

    dp = Array(repeating: Array(repeating: -1, count: grid.cols), count: grid.rows)

    var visited = Array(repeating: Array(repeating: false, count: grid.cols), count: grid.rows)
    let longestPathLength = longestPathDFS(grid: grid, current: grid.start, destination: grid.end, visited: &visited)
    return longestPathLength
}

private struct Point: Equatable {
    var x: Int
    var y: Int
}

private enum Direction {
    case up, down, left, right
}

private struct Grid {
    var rows: Int { grid.count }
    var cols: Int { grid.first!.count }
    var grid: [[Character]]

    init(_ grid: [[Character]]) {
        self.grid = grid
    }

    var start: Point {
        .init(x: 0, y: grid.first!.firstIndex(where: { $0 == "."})!)
    }

    var end: Point {
        .init(x: rows - 1, y: grid.last!.firstIndex(where: { $0 == "."})!)
    }

    func isValid(_ point: Point, _ direction: Direction) -> Bool {
        let invalidChar: Character = "#"
        var isValid = point.x >= 0 && point.x < rows && point.y >= 0 && point.y < cols && invalidChar != grid[point.x][point.y]

        guard isValid, let forced = forcedDirection(at: point) else {
            return isValid
        }

        switch forced {
            case .up where direction == .down,
                    .down where direction == .up,
                    .left where direction == .right,
                    .right where direction == .left:
                isValid = false
            default:
                break
        }

        return isValid
    }

    func forcedDirection(at point: Point) -> Direction? {
        switch grid[point.x][point.y] {
            case "<": return .left
            case "^": return .up
            case ">": return .right
            case "v": return .down
            default:  return nil
        }
    }

    func nextPoint(from point: Point, direction: Direction) -> Point {
        switch direction {
            case .up:    return Point(x: point.x - 1, y: point.y)
            case .down:  return Point(x: point.x + 1, y: point.y)
            case .left:  return Point(x: point.x, y: point.y - 1)
            case .right: return Point(x: point.x, y: point.y + 1)
        }
    }
}

private func longestPathDFS(grid: Grid, current: Point, destination: Point, visited: inout [[Bool]]) -> Int {
    if current == destination {
        return 0
    }

    if visited[current.x][current.y] {
        return 0
    }

    visited[current.x][current.y] = true

    if dp[current.x][current.y] != -1 {
        visited[current.x][current.y] = false
        return dp[current.x][current.y]
    }

    var maxLength = 0

    if let forcedDir = grid.forcedDirection(at: current) {
        let next = grid.nextPoint(from: current, direction: forcedDir)
        if grid.isValid(next, forcedDir) {
            maxLength = max(maxLength, 1 + longestPathDFS(grid: grid, current: next, destination: destination, visited: &visited))
        }
    } else {
        // Explore all four directions
        let validNeighbours = [Direction.up, Direction.down, Direction.left, Direction.right]
            .map { (grid.nextPoint(from: current, direction: $0), $0) }
            .filter {  grid.isValid($0.0, $0.1) && !visited[$0.0.x][$0.0.y] }
        for next in validNeighbours {
            maxLength = max(maxLength, 1 + longestPathDFS(grid: grid, current: next.0, destination: destination, visited: &visited))
        }
    }

    visited[current.x][current.y] = false

    dp[current.x][current.y] = maxLength
    return maxLength
}
