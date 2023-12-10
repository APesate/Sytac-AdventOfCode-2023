//
//  Day10Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 10/12/2023.
//

import Foundation
/*
 | is a vertical pipe connecting north and south.
 - is a horizontal pipe connecting east and west.
 L is a 90-degree bend connecting north and east.
 J is a 90-degree bend connecting north and west.
 7 is a 90-degree bend connecting south and west.
 F is a 90-degree bend connecting south and east.
 . is ground; there is no pipe in this tile.
 S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
 */

private typealias Point = (Int, Int)

private struct Coordinate {
    let location: Point
    let pipe: Pipe

    var up: Point {
        (location.0 - 1, location.1)
    }

    var down: Point {
        (location.0 + 1, location.1)
    }

    var left: Point {
        (location.0, location.1 - 1)
    }

    var right: Point {
        (location.0, location.1 + 1)
    }
}

private enum Pipe: String {
    case pV = "|"
    case pH = "-"
    case pL = "L"
    case pJ = "J"
    case p7 = "7"
    case pF = "F"
    case pG = "."
    case pS = "S"

    var character: Character {
        switch self {
            case .pV: return self.rawValue.first!
            case .pH: return self.rawValue.first!
            case .pL: return self.rawValue.first!
            case .pJ: return self.rawValue.first!
            case .p7: return self.rawValue.first!
            case .pF: return self.rawValue.first!
            case .pG: return self.rawValue.first!
            case .pS: return self.rawValue.first!
        }
    }
}

public func day10Part1(_ input: String) -> Int {
    var input = input
        .split(whereSeparator: \.isNewline)
        .map { Array<Character>($0.map { $0 }) }

    let startingPoint = startingPoint(input)
    var previousStep = Coordinate(location: (-1, -1), pipe: .pG)
    var loopStep = startingPoint
    var loopLength = 0

    while true {
        // Mark as visited
        if loopStep.pipe != startingPoint.pipe {
            input[loopStep.location.0][loopStep.location.1] = Pipe.pG.character
        }

        switch loopStep.pipe {
            case .pS:
                if loopStep.up.0 >= 0 
                    && [Pipe.p7, .pF, .pV, .pS].contains(pipe(input, at: loopStep.up).pipe)
                    && loopStep.up != previousStep.location {
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.up)
                }
                else if loopStep.down.0 < input.count 
                            && [Pipe.pL, .pJ, .pV, .pS].contains(pipe(input, at: loopStep.down).pipe)
                            && loopStep.down != previousStep.location {
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.down)
                }
                else if loopStep.right.1 < input[loopStep.location.0].count 
                            && [Pipe.pJ, .p7, .pH, .pS].contains(pipe(input, at: loopStep.right).pipe)
                            && loopStep.right != previousStep.location {
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.right)
                }
                else if loopStep.left.1 >= 0 
                            && [Pipe.pL, .pF, .pH, .pS].contains(pipe(input, at: loopStep.left).pipe)
                            && loopStep.left != previousStep.location {
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.left)
                } 
                else {
                    fatalError("Reach matrix boundary \(loopStep)")
                }
            case .pV:
                if loopStep.up.0 >= 0 && [Pipe.p7, .pF, .pV, .pS].contains(pipe(input, at: loopStep.up).pipe) && loopStep.up != previousStep.location {
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.up)
                }
                else if loopStep.down.0 < input.count && [Pipe.pL, .pJ, .pV, .pS].contains(pipe(input, at: loopStep.down).pipe) && loopStep.down != previousStep.location {
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.down)
                } 
                else {
                    fatalError("Reach matrix boundary \(loopStep)")
                }
            case .pH:
                if loopStep.right.1 < input[loopStep.location.0].count && [Pipe.pJ, .p7, .pH, .pS].contains(pipe(input, at: loopStep.right).pipe) && loopStep.right != previousStep.location{
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.right)
                }
                else if loopStep.left.1 >= 0 && [Pipe.pL, .pF, .pH, .pS].contains(pipe(input, at: loopStep.left).pipe) && loopStep.left != previousStep.location{
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.left)
                }
                else {
                    fatalError("Reach matrix boundary \(loopStep)")
                }
            case .pL:
                if loopStep.right.1 < input[loopStep.location.0].count && [Pipe.pJ, .p7, .pH, .pS].contains(pipe(input, at: loopStep.right).pipe) && loopStep.right != previousStep.location {
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.right)
                }
                else if loopStep.up.0 >= 0 && [Pipe.p7, .pF, .pV, .pS].contains(pipe(input, at: loopStep.up).pipe) && loopStep.up != previousStep.location {
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.up)
                }
                else {
                    fatalError("Reach matrix boundary \(loopStep)")
                }
            case .pJ:
                if loopStep.up.0 >= 0 && [Pipe.p7, .pF, .pV, .pS].contains(pipe(input, at: loopStep.up).pipe) && loopStep.up != previousStep.location{
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.up)
                }
                else if loopStep.left.1 >= 0 && [Pipe.pL, .pF, .pH, .pS].contains(pipe(input, at: loopStep.left).pipe) && loopStep.left != previousStep.location{
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.left)
                }
                else {
                    fatalError("Reach matrix boundary \(loopStep)")
                }
            case .p7:
                if loopStep.left.1 >= 0 && [Pipe.pL, .pF, .pH, .pS].contains(pipe(input, at: loopStep.left).pipe) && loopStep.left != previousStep.location{
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.left)
                }
                else if loopStep.down.0 < input.count && [Pipe.pL, .pJ, .pV, .pS].contains(pipe(input, at: loopStep.down).pipe) && loopStep.down != previousStep.location{
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.down)
                }
                else {
                    fatalError("Reach matrix boundary \(loopStep)")
                }
            case .pF:
                if loopStep.down.0 < input.count && [Pipe.pL, .pJ, .pV, .pS].contains(pipe(input, at: loopStep.down).pipe) && loopStep.down != previousStep.location{
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.down)
                }
                else if loopStep.right.1 < input[loopStep.location.0].count && [Pipe.pJ, .p7, .pH, .pS].contains(pipe(input, at: loopStep.right).pipe) && loopStep.right != previousStep.location{
                    previousStep = loopStep
                    loopStep = pipe(input, at: loopStep.right)
                }
                else {
                    fatalError("Reach matrix boundary \(loopStep)")
                }
            case .pG:
                fatalError("This can't be reached. GROUND")
        }

        guard loopStep.pipe != .pS else { break }
        loopLength += 1
    }

    return Int(ceil(Double(loopLength) / 2))
}

private func startingPoint(_ input: [[Character]]) -> Coordinate {
    var point: Coordinate!
    for i in (0..<input.count) {
        for j in (0..<input[i].count) {
            guard input[i][j] == Pipe.pS.character else {
                continue
            }

            point = Coordinate(location: (i, j), pipe: .pS)
            break
        }
        guard point == nil else { break }
    }

    return point
}

private func pipe(_ input: [[Character]], at point: Point) -> Coordinate {
    return Coordinate(location: point, pipe: Pipe(rawValue: String(input[point.0][point.1]))!)
}
