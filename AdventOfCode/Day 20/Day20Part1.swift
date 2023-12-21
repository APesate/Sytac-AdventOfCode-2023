//
//  Day20Part1.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 20/12/2023.
//

import Foundation
import RegexBuilder

private let moduleTypeRef = Reference<(ModuleType, String)>()
private let destinationsRef = Reference<[String]>()
private let moduleRegex = Regex {
    Capture(as: moduleTypeRef) {
        ChoiceOf {
            "broadcaster"
            Regex {
                One(.anyOf("%&"))
                OneOrMore(.word)
            }
        }
    } transform: { w in
        if w.contains("%") {
            return (ModuleType.flip, String(w).replacingOccurrences(of: "%", with: ""))
        } else if w.contains("&") {
            return (ModuleType.conjunction, String(w).replacingOccurrences(of: "&", with: ""))
        } else {
            return (ModuleType.broadcaster, String(w))
        }
    }

    " -> "

    Capture(as: destinationsRef) {
        OneOrMore(("a"..."z"))
        ZeroOrMore {
            ", "
            OneOrMore(("a"..."z"))
        }
    } transform: { w in
        String(w).split(separator: ", ").map { String($0) }
    }
}

public func day20Part1(_ input: String) -> Int {
    let parsed = input
        .split(whereSeparator: \.isNewline)
        .map {
            let match = $0.matches(of: moduleRegex).first!
            let module = match[moduleTypeRef].0.makeModule()
            module.id = match[moduleTypeRef].1
            module.destinations = match[destinationsRef]
            return module
        }
    parsed
        .filter { $0 is Conjunction }
        .forEach { mod in
            (mod as! Conjunction).inputs = parsed.filter { $0.destinations.contains(mod.id) }.reduce(into: [:]) { $0[$1.id!] = $1.state } 
        }
    parsed.forEach { module in
        module.destinationsModules = module
            .destinations
            .map { destination in
                parsed.first(where: { mod in mod.id == destination }) ?? .init(id: destination)
            }
    }

    return pressButton(1_000, parsed.first(where: { $0 is Broadcaster })! as! Broadcaster, parsed)
}

private func pressButton(_ times: Int, _ broadcaster: Broadcaster, _ modules: [Module]) -> Int {
    var memo: [Int: (Int, Int, Int)] = [modules.hashValue: (0, 0, 0)]
    var i = 1
    var low: Int = 0
    var high: Int = 0

    while i <= times {
        var eventsQueue: [Event] = broadcaster.process(Event(origin: .init(), pulse: .low, module: .init())) ?? []
        low += 1

        while !eventsQueue.isEmpty {
            let event = eventsQueue.removeFirst()
            let newEvents = event.module.process(event) ?? []
            eventsQueue.append(contentsOf: newEvents)

            switch event.pulse {
                case .high: high += 1
                case .low: low += 1
            }

        }

        let key = modules.hashValue
        guard memo[key] == nil else {
            print("Cycle at \(i)")
            return (high * (times / i)) * (low * (times / i))
        }
        memo[key] = (i, low, high)
        i += 1
    }
    return high * low
}

private struct Event: Hashable, CustomDebugStringConvertible {
    let origin: Module
    let pulse: Pulse
    let module: Module

    var debugDescription: String {
        return "\(origin.id!): \(pulse.rawValue) -> \(module.id!)"
    }
}

private enum Pulse: Int {
    case low
    case high
}

private enum ModuleType: String {
    case broadcaster
    case flip = "%"
    case conjunction = "&"

    func makeModule() -> Module {
        switch self {
            case .broadcaster:
                return Broadcaster()
            case .conjunction:
                return Conjunction()
            case .flip:
                return Flip()
        }
    }
}

private class Module: Hashable, CustomDebugStringConvertible {
    var id: String!
    var destinations: [String]! = []
    var destinationsModules: [Module]! = []
    var state: Bool = false

    static func == (lhs: Module, rhs: Module) -> Bool {
        lhs.id == rhs.id
    }

    init(id: String = "") {
        self.id = id
    }

    var debugDescription: String {
        "[\(id!)]: \(state)"
    }

    func process(_ event: Event) -> [Event]? { [] }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(state)
    }
}

private class Flip: Module {
    override func process(_ event: Event) -> [Event]? {
        switch event.pulse {
            case .high:
                return nil
            case .low:
                state.toggle()
                if state {
                    return destinationsModules.map { Event(origin: self, pulse: .high, module: $0) }
                } else {
                    return destinationsModules.map { Event(origin: self, pulse: .low, module: $0) }
                }
        }
    }
}

private class Conjunction: Module {
    var inputs: [String: Bool]!

    func refreshState() {
        state = inputs.allSatisfy { $0.value == true }
    }

    override func process(_ event: Event) -> [Event]? {
        inputs[event.origin.id!] = event.pulse == .high ? true : false
        refreshState()

        if state {
            return destinationsModules.map { Event(origin: self, pulse: .low, module: $0) }
        } else {
            return destinationsModules.map { Event(origin: self, pulse: .high, module: $0) }
        }
    }

    override func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(inputs)
    }
}

private class Broadcaster: Module {
    override func process(_ _: Event) -> [Event]? {
        destinationsModules.map { Event(origin: self, pulse: .low, module: $0) }
    }
}
