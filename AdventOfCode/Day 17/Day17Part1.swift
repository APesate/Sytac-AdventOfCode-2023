//
//  Day17Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 17/12/2023.
//

import Foundation

private struct Point: Hashable {
    var x: Int
    var y: Int
}

private struct State: Hashable {
    static func == (lhs: State, rhs: State) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    var point: Point
    var run: (Int, Int)

    func hash(into hasher: inout Hasher) {
        hasher.combine(point)
        hasher.combine(run.0)
        hasher.combine(run.1)
    }
}

public func day17Part1(_ input: String) -> Int {
    let lines = input
        .split(whereSeparator: \.isNewline)
    let input = Dictionary(lines
        .enumerated()
        .map { (row, line) in
            line
                .enumerated()
                .compactMap { (col, value) in
                    (Point(x: row, y: col), Int(String(value))!)
                }
        }
        .flatMap({$0})
    ) { lhs, rhs in
        return lhs < rhs ? lhs : rhs
    }

    return dijkstra(grid: input, start: Point(x: 0, y: 0), end: Point(x: lines.count - 1, y: lines.first!.count - 1), maxRun: 3) ?? -1
}

private func dijkstra(grid: [Point: Int], start: Point, end: Point, maxRun: Int) -> Int? {
    var distances = [State: Int]()
    var priorityQueue = PriorityQueue<(Int, State)>(sort: { $0.0 < $1.0 })

    let startState = State(point: start, run: (0, 0))
    distances[startState] = 0
    priorityQueue.enqueue((0, startState))

    while !priorityQueue.isEmpty {
        let (_, currentState) = priorityQueue.dequeue()!

        let (consecutiveMovesRow, consecutiveMovesCol) = currentState.run
        if !(consecutiveMovesRow >= -maxRun && consecutiveMovesRow <= maxRun && consecutiveMovesCol >= -maxRun && consecutiveMovesCol <= maxRun) {
            continue
        }

        if currentState.point == end {
            return distances[currentState]
        }

        for neighbour in neighbours(currentState, grid: grid) {
            let alt = distances[currentState, default: Int.max] + grid[neighbour.point, default: Int.max]
            if alt < distances[neighbour, default: Int.max] {
                distances[neighbour] = alt
                priorityQueue.enqueue((alt, neighbour))
            }
        }
    }

    return nil
}

private func neighbours(_ state: State, grid: [Point: Int]) -> [State] {
    let (i, j) = (state.point.x, state.point.y)
    let (consecutiveMovesRow, consecutiveMovesCol) = state.run
    var result: [State] = []

    if consecutiveMovesRow == 0 {
        result.append(State(point: Point(x: i - 1, y: j), run: (-1, 0)))
        result.append(State(point: Point(x: i + 1, y: j), run: (1, 0)))
    }
    if consecutiveMovesCol == 0 {
        result.append(State(point: Point(x: i, y: j - 1), run: (0, -1)))
        result.append(State(point: Point(x: i, y: j + 1), run: (0, 1)))
    }
    if consecutiveMovesRow > 0 {
        result.append(State(point: Point(x: i + 1, y: j), run: (consecutiveMovesRow + 1, 0)))
    }
    if consecutiveMovesRow < 0 {
        result.append(State(point: Point(x: i - 1, y: j), run: (consecutiveMovesRow - 1, 0)))
    }
    if consecutiveMovesCol > 0 {
        result.append(State(point: Point(x: i, y: j + 1), run: (0, consecutiveMovesCol + 1)))
    }
    if consecutiveMovesCol < 0 {
        result.append(State(point: Point(x: i, y: j - 1), run: (0, consecutiveMovesCol - 1)))
    }

    return result.filter { grid[$0.point] != nil }
}
