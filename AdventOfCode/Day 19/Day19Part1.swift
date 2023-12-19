//
//  Day19Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 19/12/2023.
//

import Foundation
import RegexBuilder

private let partRef = Reference<Part>()
private let partValueRef = Reference<Int>()
private let partsRegex = Regex {
    Repeat(1...4) {
        Capture(as: partRef) {
            ChoiceOf {
                "x"
                "m"
                "a"
                "s"
            }
        } transform: {
            Part(rawValue: String($0))!
        }
            "="
        Capture(as: partValueRef) {
            OneOrMore(.digit)
        } transform: {
            Int(String($0))!
        }
    }
}

private let capturingRuleRegex = Regex {
    Capture {
        One(
            ChoiceOf {
                "x"
                "m"
                "a"
                "s"
            }
        )
    }
    Capture {
        One(
            ChoiceOf {
                ">"
                "<"
            }
        )
    }
    Capture {
        OneOrMore(.digit)
    }
    ":"
    Capture {
        OneOrMore(.word)
    }
}

private let keyRef = Reference<String>()
private let rulesRef = Reference<[Rule]>()
private let finalElseRef = Reference<String>()
private let ruleRegex = Regex {
    OneOrMore {
        One(
            ChoiceOf {
                "x"
                "m"
                "a"
                "s"
            }
        )
        One(
            ChoiceOf {
                ">"
                "<"
            }
        )
        OneOrMore(.digit)
        ":"
        OneOrMore(.word)
        ","
    }
} // Because the compiler 💩
private let workflowsRegex = Regex {
    Capture(as: keyRef) {
        OneOrMore(.word)
    } transform: {
        String($0)
    }
    "{"
    Capture(as: rulesRef, {
        ruleRegex
    }, transform: parseRule(_:))
    Capture(as: finalElseRef) {
        OneOrMore(.word)
    } transform: {
        String($0)
    }
}

private func parseRule(_ string: Substring) -> [Rule] {
    String(string)
        .split(separator: ",")
        .map {
            let value = String($0).matches(of: capturingRuleRegex).first!
            return Rule(
                part: Part(rawValue: String(value.output.1))!,
                condition: Condition(String(value.output.2), Int(String(value.output.3))!),
                outcome: Outcome(String(value.output.4)))
        }
}

private enum Part: String {
    case x
    case m
    case a
    case s
}

private enum Condition {
    case lessThan(Int)
    case moreThan(Int)

    init(_ symbol: String, _ value: Int) {
        switch symbol {
            case "<": self = .lessThan(value)
            case ">": self = .moreThan(value)
            default: fatalError("Invalid Symbol \(symbol) - \(value)")
        }
    }

    func isSatisfied(by value: Int) -> Bool {
        switch self {
            case let .lessThan(conditionValue):
                return value < conditionValue
            case let .moreThan(conditionValue):
                return value > conditionValue
        }
    }
}

private enum Outcome {
    case next(String)
    case accepted
    case rejected

    init(_ outcome: String) {
        switch outcome {
            case "A": self = .accepted
            case "R": self = .rejected
            default: self = .next(outcome)
        }
    }
}

private struct Rule {
    let part: Part
    let condition: Condition
    let outcome: Outcome
}

private typealias Workflows = [String: (rules: [Rule], otherwise: Outcome)]
private typealias PartsGroup = [Part: Int]

public func day19Part1(_ input: String) -> Int {
    let split = input.split(separator: "\n\n")
    let (workflowsInput, partsInput) = (String(split.first!), String(split.last!))
    let workflows: Workflows = workflowsInput
        .split(whereSeparator: \.isNewline)
        .reduce(into: [String: ([Rule], Outcome)](), { dict, line in
            let matches = line.matches(of: workflowsRegex).first!
            let final = Outcome(matches[finalElseRef])
            dict[matches[keyRef]] = (matches[rulesRef], final)
        })
    let parts: [PartsGroup] = partsInput
        .split(whereSeparator: \.isNewline)
        .map { line in
            line.matches(of: partsRegex).reduce(into: [Part: Int]()) { res, match in
                res[match[partRef]] = match[partValueRef]
            }
        }


    return acceptedPartsValue(workflows, parts)
}

private func acceptedPartsValue(_ workflows: Workflows, _ parts: [PartsGroup]) -> Int {
    return parts
        .filter { isPartAccepted(workflows, $0) }
        .reduce(into: 0) { $0 += $1.reduce(into: 0) { $0 += $1.value } }
}

private func isPartAccepted(_ workflows: Workflows, _ parts: PartsGroup) -> Bool {
    var flow: (rules: [Rule], otherwise: Outcome)? = workflows["in"]

    while flow != nil {
        let outcome = flow!
            .rules
            .filter { $0.condition.isSatisfied(by: parts[$0.part]!) }
            .first?
            .outcome
        ?? flow!.otherwise

        switch outcome {
            case .accepted:
                return true
            case .rejected:
                return false
            case let .next(next):
                flow = workflows[next]
        }
    }

    return false
}
