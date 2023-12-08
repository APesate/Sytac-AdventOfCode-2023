//
//  Day8Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 08/12/2023.
//

import Foundation
import RegexBuilder
/*
 RL

 AAA = (BBB, CCC)
 BBB = (DDD, EEE)
 CCC = (ZZZ, GGG)
 DDD = (DDD, DDD)
 EEE = (EEE, EEE)
 GGG = (GGG, GGG)
 ZZZ = (ZZZ, ZZZ)
 */

func gcd(_ a: Int, _ b: Int) -> Int {
    return b == 0 ? a : gcd(b, a % b)
}

func lcm(_ a: Int, _ b: Int) -> Int {
    return a / gcd(a, b) * b
}

func lcm(_ array: [Int]) -> Int {
    return array.reduce(1, { lcm($0, $1) })
}

private let inputRegex =
Regex {
    Capture {
        OneOrMore(("A"..."Z"))
    } transform: { String($0) }
    " = ("
    Capture {
        OneOrMore(("A"..."Z"))
    } transform: { String($0) }
    ", "
    Capture {
        OneOrMore(("A"..."Z"))
    } transform: { String($0) }
}

public func day8Part2(_ input: String) -> Int {
    var lines = input.split(whereSeparator: \.isNewline)
    let steps = String(lines.removeFirst())
    var map: [String: (String, String)] = [:]

    for line in lines where line != "\n" {
        let parsed = line.matches(of: inputRegex)

        for match in parsed {
            map[match.output.1] = (match.output.2, match.output.3)
        }
    }

    var stepsCount = 1
    var currentStepIndex = 0
    var loops: [Int] = []
    var locations = map.keys.filter({ $0.hasSuffix("A") })

    while loops.count != locations.count {
        defer { stepsCount += 1 }

        for (index, location) in locations.enumerated() {
            if steps[steps.index(steps.startIndex, offsetBy: currentStepIndex)] == "R" {
                locations[index] = map[location]!.1
            } else {
                locations[index] = map[location]!.0
            }

            if locations[index].hasSuffix("Z") {
                loops.append(stepsCount)
            }
        }

        currentStepIndex += 1
        if currentStepIndex >= steps.count {
            currentStepIndex = 0
        }
    }

    return lcm(loops)
}
