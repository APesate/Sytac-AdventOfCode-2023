//
//  Day20Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 20/12/2023.
//

import Foundation
import RegexBuilder

private func gcd(_ a: Int, _ b: Int) -> Int {
    return b == 0 ? a : gcd(b, a % b)
}

private func lcm(_ a: Int, _ b: Int) -> Int {
    return a / gcd(a, b) * b
}

private func lcm(_ array: [Int]) -> Int {
    return array.reduce(1, { lcm($0, $1) })
}

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

public func day20Part2(_ input: String) -> Int {
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

private func modulesToWatch(_ modules: [Module]) -> [Module] {
    let rxInput: Conjunction = modules.first(where: { $0.destinations.contains("rx") }) as! Conjunction
    return modules.filter({ rxInput.inputs.keys.contains($0.id) })
}

private func pressButton(_ times: Int, _ broadcaster: Broadcaster, _ modules: [Module]) -> Int {
    var toWatch: [Module: [Int]] = modulesToWatch(modules).reduce(into: [:], { $0[$1] = [] })
    var i = 1

    while true {
        var eventsQueue: [Event] = broadcaster.process(Event(origin: .init(), pulse: .low, module: .init())) ?? []

        while !eventsQueue.isEmpty {
            let event = eventsQueue.removeFirst()
            let newEvents = event.module.process(event) ?? []
            eventsQueue.append(contentsOf: newEvents)

            if event.pulse == .low && toWatch[event.module] != nil {
                toWatch[event.module]?.append(i)
            }

            if toWatch.values.allSatisfy({ $0.count >= 2 }) {
                let lcms = toWatch.values.reduce(into: [], { $0.append($1[1] - $1.first!)})
                return lcm(lcms)
            }
        }

        i += 1
    }
    
    fatalError("Will never happen")
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
