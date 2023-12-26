//
//  Day24Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 24/12/2023.
//

import Foundation
import SwiftZ3

public func day24Part2(_ input: String) -> Int {
    let parsed = input
        .split(whereSeparator: \.isNewline)
        .enumerated()
        .map {
            let parts = $1.split(separator: " @ ")
            let loc = parts.first!.split(separator: ",").map { Int(String($0).trimmingCharacters(in: .whitespaces))! }
            let speed = parts.last!.split(separator: ",").map { Int(String($0).trimmingCharacters(in: .whitespaces))! }
            var asciiValue = ($0 % 57) + 65
            asciiValue = asciiValue != 92 ? asciiValue : 47
            return Hailstone(
                id: String(repeating: UnicodeScalar(asciiValue)!.escaped(asASCII: true), count: Int(floor(Double($0)/57.0)) + 1),
                position: .init(loc[0], loc[1], loc[2]),
                velocity: .init(x: speed[0], y: speed[1], z: speed[2])
            )
        }

    return findTrajectoryWithZ3(hailstones: parsed)
}

private func findTrajectoryWithZ3(hailstones: [Hailstone]) -> Int {
        let context = Z3Context()

        // Define real number variables for position and velocity
    let x = context.makeConstant(name: "x", sort: RealSort.self)
    let y = context.makeConstant(name: "y", sort: RealSort.self)
    let z = context.makeConstant(name: "z", sort: RealSort.self)
    let vx = context.makeConstant(name: "vx", sort: RealSort.self)
    let vy = context.makeConstant(name: "vy", sort: RealSort.self)
    let vz = context.makeConstant(name: "vz", sort: RealSort.self)

        // Create a time variable for each hailstone
    let T = (0..<hailstones.count).map { context.makeConstant(name: "T\($0)", sort: RealSort.self) }

        let solver = context.makeSolver()

        // Add constraints for each hailstone
        for (i, hailstone) in hailstones.enumerated() {
            solver.assert(context.makeEqual(
                context.makeAdd([x, context.makeMul([T[i], vx])]),
                context.makeAdd([
                    context.makeIntToReal(context.makeInteger64(Int64(hailstone.position.x))),
                    context.makeMul([T[i], context.makeIntToReal(context.makeInteger64(Int64(hailstone.velocity.x)))])
                ])
            ))

            solver.assert(context.makeEqual(
                context.makeAdd([y, context.makeMul([T[i], vy])]),
                context.makeAdd([
                    context.makeIntToReal(context.makeInteger64(Int64(hailstone.position.y))),
                    context.makeMul([T[i], context.makeIntToReal(context.makeInteger64(Int64(hailstone.velocity.y)))])
                ])
            ))

            solver.assert(context.makeEqual(
                context.makeAdd([z, context.makeMul([T[i], vz])]),
                context.makeAdd([
                    context.makeIntToReal(context.makeInteger64(Int64(hailstone.position.z))),
                    context.makeMul([T[i], context.makeIntToReal(context.makeInteger64(Int64(hailstone.velocity.z)))])
                ])
            ))
        }

        // Check if the constraints are satisfiable
        if solver.check() == .satisfiable, let model = solver.getModel() {
            // Extract and print the solution
            let solutionX = model.eval(x)!.numeralDouble
            let solutionY = model.eval(y)!.numeralDouble
            let solutionZ = model.eval(z)!.numeralDouble
            return Int(solutionX + solutionY + solutionZ)
        } else {
            return 0
        }
    }


private struct Hailstone {
    let id: String
    var position: Vector3D
    var velocity: Vector3D
}

private struct Vector3D {
    var x: Int
    var y: Int
    var z: Int

    static func +(lhs: Vector3D, rhs: Vector3D) -> Vector3D {
        return Vector3D(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    static func -(lhs: Vector3D, rhs: Vector3D) -> Vector3D {
        return Vector3D(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

    static func *(lhs: Vector3D, rhs: Int) -> Vector3D {
        return Vector3D(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }

    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }


    init(_ x: Int, _ y: Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }

}
