//
//  Day7Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 06/12/2023.
//

import Foundation

/*
 Five of a kind, where all five cards have the same label: AAAAA
 Four of a kind, where four cards have the same label and one card has a different label: AA8AA
 Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
 Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
 Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
 One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
 High card, where all cards' labels are distinct: 23456
 */

//let day7TestInput =
//"""
//32T3K 765
//T55J5 684
//KK677 28
//KTJJT 220
//QQQJA 483
//"""
// Part 2: 5905

private enum Card: Int {
    case A = 12
    case K = 11
    case Q = 10
    case T = 9
    case n9 = 8
    case n8 = 7
    case n7 = 6
    case n6 = 5
    case n5 = 4
    case n4 = 3
    case n3 = 2
    case n2 = 1
    case J = 0

    var name: String {
        switch self {
            case .A: return "A"
            case .K: return "K"
            case .Q: return "Q"
            case .J: return "J"
            case .T: return "T"
            case .n9: return "9"
            case .n8: return "8"
            case .n7: return "7"
            case .n6: return "6"
            case .n5: return "5"
            case .n4: return "4"
            case .n3: return "3"
            case .n2: return "2"
        }
    }

    init?(_ value: Character) {
        switch value {
            case "A": self = .A
            case "K": self = .K
            case "Q": self = .Q
            case "J": self = .J
            case "T": self = .T
            case "9": self = .n9
            case "8": self = .n8
            case "7": self = .n7
            case "6": self = .n6
            case "5": self = .n5
            case "4": self = .n4
            case "3": self = .n3
            case "2": self = .n2
            default: return nil
        }
    }
}

private enum Hand: Int {
    case fiveOfak = 6 // 1
    case fourOfak = 5 // 2
    case fullHouse = 4 // 2
    case threeOfak = 3 // 2-3
    case twoPair = 2 // 3 - 4
    case onePair = 1 // 5
    case highCard = 0

    var name: String {
        switch self {
            case .fiveOfak: return "fiveOfak"
            case .fourOfak: return "fourOfak"
            case .fullHouse: return "fullHouse"
            case .threeOfak: return "threeOfak"
            case .twoPair: return "twoPair"
            case .onePair: return "onePair"
            case .highCard: return "highCard"
        }
    }
}

public func day7Part2(_ input: String) -> Int {
    typealias Input = (Hand, Int, [Card])
    var hands: [Input] = []

    for line in input.split(whereSeparator: \.isNewline) {
        let values = line.split(separator: " ")
        let (hand, bid) = (String(values.first!), Int(String(values.last!))!)
        let parsed = determineHandType(hand)
        hands.append((parsed.0, bid, parsed.1))
    }

    hands.sort { (lhs: Input, rhs: Input) in
        var result: Bool = false
        if lhs.0 == rhs.0 {
            for index in (0..<lhs.2.count) {
                guard lhs.2[index] != rhs.2[index] else { continue }
                result = lhs.2[index].rawValue > rhs.2[index].rawValue
                break
            }
        } else {
            result = lhs.0.rawValue > rhs.0.rawValue
        }

        return result
    }

    var result = 0

    for (index, hand) in hands.enumerated() {
        result += hand.1 * (hands.count - index)
    }

    return result // 246436046
}

private func determineHandType(_ hand: String) -> (Hand, [Card]) {
    var map: [Card: Int] = [:]
    var cards: [Card] = []

    hand.forEach {
        let card = Card($0)!
        cards.append(card)
        if map[card] != nil {
            map[card]! += 1
        } else {
            map[card] = 1
        }
    }

    var result: (Hand, [Card])!
    let jokers = map[.J] ?? 0
    map[.J] = nil
    let counts = map.values.sorted(by: >)

    if jokers == 5 {
        result = (.fiveOfak, cards)
    } else if counts.first(where: { $0 + jokers == 5 }) != nil {
        result = (.fiveOfak, cards)
    } else if counts.first(where: { $0 + jokers == 4 }) != nil {
        result = (.fourOfak, cards)
    } else if let index3 = counts.firstIndex(where: { $0 + jokers == 3 }), (counts.enumerated().first(where: { $0.1 == 2 && $0.0 != index3 }) != nil) {
        result = (.fullHouse, cards)
    } else if let index2 = counts.firstIndex(where: { $0 + jokers == 2 }), (counts.enumerated().first(where: { $0.1 == 3 && $0.0 != index2 }) != nil) {
        result = (.fullHouse, cards)
    } else if counts.first(where: { $0 + jokers == 3 }) != nil {
        result = (.threeOfak, cards)
    } else if let index2 = counts.firstIndex(where: { $0 + jokers == 2 }), (counts.enumerated().first(where: { $0.1 == 2 && $0.0 != index2 }) != nil) {
        result = (.twoPair, cards)
    } else if counts.first(where: { $0 + jokers == 2 }) != nil {
        result = (.onePair, cards)
    } else {
        result = (.highCard, cards)
    }

    return result
}
