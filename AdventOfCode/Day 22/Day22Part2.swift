//
//  Day22Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 22/12/2023.
//

import Foundation
import simd
import Collections

public func day22Part2(_ input: String) -> Int {
    let bricks = input
        .split(whereSeparator: \.isNewline)
        .enumerated()
        .map {
            var asciiValue = ($0 % 57) + 65
            asciiValue = asciiValue != 92 ? asciiValue : 47
            return Brick(
                id: String(repeating: UnicodeScalar(asciiValue)!.escaped(asASCII: true), count: Int(floor(Double($0)/57.0)) + 1),
                edges: $1
                    .split(separator: "~")
                    .reduce(into: []) {
                        let components = $1.split(separator: ",")
                        $0.append(vector_int3(Int32(components[0])!, Int32(components[1])!, Int32(components[2])!))
                    }
            )
        }
    let fallSimulation = BrickFallSimulation(bricks: bricks)
    fallSimulation.simulateFalling()
    //    fallSimulation.debugPrint(axis: \.x, "x")
    //    fallSimulation.debugPrint(axis: \.y, "y")

    return fallSimulation.optimalFall()
}

private class BrickFallSimulation {
    var bricks: [Brick]

    init(bricks: [Brick]) {
        self.bricks = bricks.sorted(by: <)
    }

    var removableBricks: Set<Brick> {
        var removable: Set<Brick> = []

        for brick in bricks where brick.supportedBricks.allSatisfy({ $0.supportingBricks.count > 1 }) {
            removable.insert(brick)
        }

        return removable
    }

    func optimalFall() -> Int {
        bricks
            .map(fallChainBFS(_:))
            .reduce(into: 0, { $0 += $1.count })
    }

    private func fallChainBFS(_ brick: Brick) -> Set<Brick> {
        var safeToEliminate: Set<Brick> = [brick]
        var queue: OrderedSet<Brick> = OrderedSet(brick.supportedBricks)

        while !queue.isEmpty {
            let brickToRemove = queue.removeFirst()

            if safeToEliminate.isSuperset(of: brickToRemove.supportingBricks) {
                safeToEliminate.insert(brickToRemove)
                queue.formUnion(brickToRemove.supportedBricks)
            }
        }

        safeToEliminate.remove(brick)

        return safeToEliminate
    }

    func debugPrint(axis: WritableKeyPath<vector_int3, Int32>, _ id: String) {
        let maxWidth = Int(bricks.max(by: { $0.edges.last![keyPath: axis] < $1.edges.last![keyPath: axis] })!.edges.last![keyPath: axis]) + 1
        let maxHeight = Int(bricks.max(by: { $0.edges.last!.z < $1.edges.last!.z })!.edges.last!.z) + 1
        var grid = Array(repeating: Array(repeating: ".", count: maxWidth), count: maxHeight)

        bricks.forEach { brick in
            let hor = (Int(brick.edges.first![keyPath: axis])...Int(brick.edges.last![keyPath: axis]))
            let ver = (Int(brick.edges.first!.z)...Int(brick.edges.last!.z))

            for i in hor.lowerBound...hor.upperBound {
                grid[ver.lowerBound][i] = grid[ver.lowerBound][i] != "." && grid[ver.lowerBound][i] != String(brick.id.first!) ? "?" : String(brick.id.first!)
            }
            for i in ver.lowerBound...ver.upperBound {
                grid[i][hor.lowerBound] = grid[i][hor.lowerBound] != "." && grid[i][hor.lowerBound] != String(brick.id.first!) ? "?" : String(brick.id.first!)
            }
        }
        print(id)
        print(grid.reversed().map { $0.map { String($0) }.joined(separator: " ") }.joined(separator: "\n"))
        print(String(repeating: "-", count: maxWidth))
    }

    func simulateFalling() {
        for (index, fallingBrick) in bricks.enumerated() {
            var didCollide = false
            while !didCollide && fallingBrick.edges.first!.z != 0{
                didCollide = false

                for alreadyPlacedBrick in bricks[..<index]
                where bricksOverlapInXY(fallingBrick, alreadyPlacedBrick) && fallingBrick.edges.first!.z - 1 == alreadyPlacedBrick.edges.last!.z {
                    didCollide = true
                    fallingBrick.supportingBricks.insert(alreadyPlacedBrick)
                    alreadyPlacedBrick.supportedBricks.insert(fallingBrick)
                }

                if !didCollide {
                    fallingBrick.edges[0].z -= 1
                    fallingBrick.edges[1].z -= 1
                }
            }
        }
    }

    private func bricksOverlapInXY(_ brick1: Brick, _ brick2: Brick) -> Bool {
        let overlapInX = (brick1.edges.first!.x...brick1.edges.last!.x).overlaps(brick2.edges.first!.x...brick2.edges.last!.x)
        let overlapInY = (brick1.edges.first!.y...brick1.edges.last!.y).overlaps(brick2.edges.first!.y...brick2.edges.last!.y)
        return overlapInX && overlapInY
    }
}



// MARK: - Auxiliary

private class Brick: Comparable, Equatable, Hashable, CustomDebugStringConvertible {
    let id: String
    var edges: [vector_int3]
    var supportedBricks: Set<Brick> = [] // Bricks above this one
    var supportingBricks: Set<Brick> = [] // Bricks that support this one from below

    init(id: String, edges: [vector_int3]) {
        self.id = id
        self.edges = edges
    }

    var debugDescription: String {
        "\(id): \(edges.map({ ($0.x, $0.y, $0.z) }))"
    }

    var stack: String {
        "[\(supportingBricks.count)] : \(id) : [\(supportedBricks.count)]"
    }

    static func ==(lhs: Brick, rhs: Brick) -> Bool {
        lhs.id == rhs.id
    }

    static func <(lhs: Brick, rhs: Brick) -> Bool {
        lhs.edges.first!.z < rhs.edges.first!.z
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(edges)
    }
}


