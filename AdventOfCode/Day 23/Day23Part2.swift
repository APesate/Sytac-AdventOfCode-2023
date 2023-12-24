//
//  Day23Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 23/12/2023.
//

import Foundation

private var dp: [[PathResult]]!

public func day23Part2(_ input: String) -> Int {
    let grid = Grid(
        input
            .split(whereSeparator: \.isNewline)
            .map({ $0.map { $0 } })
    )

    dp = Array(repeating: Array(repeating: .init(length: -1, reachedDestination: false), count: grid.cols), count: grid.rows)

    var visited = Array(repeating: Array(repeating: false, count: grid.cols), count: grid.rows)
    var currentPath: [Point] = []
    var bestPath: [Point] = []
    let final = longestPathDFS(grid: grid, current: grid.start, destination: grid.end, visited: &visited, currentPath: &currentPath, bestPath: &bestPath)
    return final.length
}

private struct Point: Equatable, CustomDebugStringConvertible {
    var x: Int
    var y: Int

    var debugDescription: String {
        "(\(x), \(y))"
    }
}

private enum Direction: String, CustomDebugStringConvertible {
    case up, down, left, right

    var debugDescription: String {
        "\(rawValue)"
    }
}

private struct PathResult {
    var length: Int
    var reachedDestination: Bool
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
        point.x >= 0
        && point.x < rows
        && point.y >= 0 
        && point.y < cols
        && grid[point.x][point.y] != "#"
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

private func longestPathDFS(grid: Grid, current: Point, destination: Point, visited: inout [[Bool]], currentPath: inout [Point], bestPath: inout [Point]) -> PathResult {
    if current == destination {
        currentPath.append(current)
        if currentPath.count > bestPath.count {
            bestPath = currentPath
        }
        currentPath.removeLast()
        return .init(length: 1, reachedDestination: true)
    }

    guard !visited[current.x][current.y] else { return .init(length: 0, reachedDestination: false) }

    visited[current.x][current.y] = true
    currentPath.append(current)

    var maxLength = PathResult(length: 0, reachedDestination: false)

    let validNeighbours = [Direction.down, Direction.right, Direction.left, Direction.up]
    for dir in validNeighbours {
        let next = grid.nextPoint(from: current, direction: dir)
        if grid.isValid(next, dir) && !visited[next.x][next.y] {
            let result = longestPathDFS(grid: grid, current: next, destination: destination, visited: &visited, currentPath: &currentPath, bestPath: &bestPath)
            if result.reachedDestination {
                if result.length + 1 > maxLength.length {
                    maxLength = .init(length: result.length + 1, reachedDestination: true)
                }
            }
        }
    }

    visited[current.x][current.y] = false
    currentPath.removeLast()

    dp[current.x][current.y] = maxLength
    return maxLength
}


private func printMarkedPath(grid: Grid, path: [Point]) {
    var markedGrid = grid.grid

    print("  \t\((0..<grid.cols).map({ String($0 % 10) }).joined(separator: " "))")
    var rows: [String] = []
    for i in 0..<grid.rows {
        var row = "\(i)\t"
        for j in 0..<grid.cols {
            if path.firstIndex(of: Point(x: i, y: j)) != nil {
                if Point(x: i, y: j) == path.last! {
                    markedGrid[i][j] = "\u{025C7}"
                } else if Point(x: i, y: j) == path[path.count - 2] {
                    markedGrid[i][j] = "\u{025C9}"
                } else {
                    markedGrid[i][j] = Point(x: i, y: j) == grid.start ? "S" : "\u{025BE}"
                }
            } else if markedGrid[i][j] == "#" {
                markedGrid[i][j] = "|"
            }
            row.append("\(markedGrid[i][j]) ")
        }
        rows.append(row)
    }

    print(rows.joined(separator: "\n"))
}
