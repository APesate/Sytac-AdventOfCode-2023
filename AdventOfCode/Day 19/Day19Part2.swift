//
//  Day19Part2.swift
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

private enum Condition: CustomDebugStringConvertible {
    case lessThan(Int)
    case moreThan(Int)

    init(_ symbol: String, _ value: Int) {
        switch symbol {
            case "<": self = .lessThan(value)
            case ">": self = .moreThan(value)
            default: fatalError("Invalid Symbol \(symbol) - \(value)")
        }
    }

    var debugDescription: String {
        switch self {
            case let .lessThan(x): return "< \(x)"
            case let .moreThan(x): return "> \(x)"
        }
    }

    var value: Int {
        switch self {
            case let .lessThan(x): return x
            case let .moreThan(x): return x
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

private struct Rule: CustomDebugStringConvertible {
    let part: Part
    let condition: Condition
    let outcome: Outcome

    var debugDescription: String {
        "\(part.rawValue) \(condition): \(outcome)"
    }
}

private enum ValidationError: Error {
    case invalidRange
}

private typealias Workflows = [String: (rules: [Rule], otherwise: Outcome)]
private struct PartRanges: CustomDebugStringConvertible {
    var x: ClosedRange<Int> = (1...4000)
    var m: ClosedRange<Int> = (1...4000)
    var a: ClosedRange<Int> = (1...4000)
    var s: ClosedRange<Int> = (1...4000)

    var sum: Int {
        (x.count)
        * (m.count)
        * (a.count)
        * (s.count)
    }

    var debugDescription: String {
        "x: [\(x.lowerBound), \(x.upperBound)] - m: [\(m.lowerBound), \(m.upperBound)] - a: [\(a.lowerBound), \(a.upperBound)] - s: [\(s.lowerBound), \(s.upperBound)]"
    }

    static func keyPath(for part: Part) -> WritableKeyPath<Self, ClosedRange<Int>> {
        switch part {
            case .x: return \Self.x
            case .m: return \Self.m
            case .a: return \Self.a
            case .s: return \Self.s
        }
    }

    func range(for part: Part) -> ClosedRange<Int> {
        switch part {
            case .x: return x
            case .m: return m
            case .a: return a
            case .s: return s
        }
    }

    mutating func adjust(part: Part, to condition: Condition) throws {
        let rangeToCheck = range(for: part)
        
        guard rangeToCheck.contains(condition.value) else {
            throw ValidationError.invalidRange
        }
        
        switch condition {
            case let .lessThan(conditionValue):
                self[keyPath: Self.keyPath(for: part)] = (rangeToCheck.lowerBound...min(conditionValue - 1, rangeToCheck.upperBound))
            case let .moreThan(conditionValue):
                self[keyPath: Self.keyPath(for: part)] = (max(conditionValue + 1, rangeToCheck.lowerBound)...rangeToCheck.upperBound)
        }
    }

    func opposite(for condition: Condition, _ key: WritableKeyPath<Self, ClosedRange<Int>>) -> Self {
        var copy = self
        switch condition {
            case let .lessThan(conditionValue):
                copy[keyPath: key] = conditionValue...self[keyPath: key].upperBound
            case let .moreThan(conditionValue):
                copy[keyPath: key] = self[keyPath: key].lowerBound...(conditionValue)
        }
        return copy
    }
}

public func day19Part2(_ input: String) -> Int {
    let split = input.split(separator: "\n\n")
    let workflowsInput = String(split.first!)
    let workflows: Workflows = workflowsInput
        .split(whereSeparator: \.isNewline)
        .reduce(into: [String: ([Rule], Outcome)](), { dict, line in
            let matches = line.matches(of: workflowsRegex).first!
            let final = Outcome(matches[finalElseRef])
            dict[matches[keyRef]] = (matches[rulesRef], final)
        })

    let ranges = acceptedRanges(workflows, "in", PartRanges())

    return ranges.reduce(into: 0) { partialResult, range in
        partialResult += range.sum
    } // 130745440937650
}

private func acceptedRanges(_ workflows: Workflows, _ flowKey: String, _ ranges: PartRanges) -> [PartRanges] {
    var lranges = ranges
    var accepted: [PartRanges] = []

    for (index, rule) in workflows[flowKey]!.rules.enumerated() {

        if index > 0 {
            let rulesToAdjust = workflows[flowKey]!.rules[0..<index]
            rulesToAdjust
                .forEach { lranges[keyPath: PartRanges.keyPath(for: $0.part)] = ranges.opposite(for: $0.condition, PartRanges.keyPath(for: $0.part))[keyPath: PartRanges.keyPath(for: $0.part)] }
        }

        do {
            try lranges.adjust(part: rule.part, to: rule.condition)

            switch rule.outcome {
                case .accepted:
//                    print("\(flowKey):\(rule.part) \(rule.condition.debugDescription) -> \(lranges)")
                    accepted.append(lranges)
                case .rejected:
                    continue
                case let .next(next):
                    accepted.append(contentsOf: acceptedRanges(workflows, next, lranges))
            }
        } catch {
            continue
        }
    }

    let rulesToAdjust = workflows[flowKey]!.rules
    rulesToAdjust
        .forEach { lranges[keyPath: PartRanges.keyPath(for: $0.part)] = ranges.opposite(for: $0.condition, PartRanges.keyPath(for: $0.part))[keyPath: PartRanges.keyPath(for: $0.part)] }

    // Otherwise
    switch workflows[flowKey]!.otherwise {
        case .accepted:
//            print("\(flowKey):Other -> \(lranges)")
            accepted.append(lranges)
        case .rejected:
            break
        case let .next(next):
            accepted.append(contentsOf: acceptedRanges(workflows, next, lranges))
    }

    return accepted
}
