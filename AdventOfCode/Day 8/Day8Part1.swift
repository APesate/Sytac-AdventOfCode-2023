//
//  Day8Part1.swift
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

public func day8Part1(_ input: String) -> Int {
    var lines = input.split(whereSeparator: \.isNewline)
    let steps = String(lines.removeFirst())
    var map: [String: (String, String)] = [:]

    for line in lines where line != "\n" {
        let parsed = line.matches(of: inputRegex)

        for match in parsed {
            map[match.output.1] = (match.output.2, match.output.3)
        }
    }

    var stepsCount = 0
    var currentStepIndex = 0
    var location = "AAA"

    while location != "ZZZ" {
        if steps[steps.index(steps.startIndex, offsetBy: currentStepIndex)] == "R" {
            location = map[location]!.1
        } else {
            location = map[location]!.0
        }

        currentStepIndex += 1
        if currentStepIndex >= steps.count {
            currentStepIndex = 0
        }

        stepsCount += 1
    }

    return stepsCount
}
