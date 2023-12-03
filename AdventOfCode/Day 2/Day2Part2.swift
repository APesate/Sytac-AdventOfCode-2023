import Foundation
import RegexBuilder

//"""
//Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
//Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
//Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
//Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
//Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
//"""

public func day2PowerInGames(in input: String) -> Int {
    var result = 0

    for line in input.split(whereSeparator: \.isNewline) {
        var maxPerColor: [Color: Int] = [
            .red: 1,
            .green: 1,
            .blue: 1
        ]

        for colorMatch in line.matches(of: colorRegex) {
            let color = colorMatch[color]
            let value = colorMatch[number]

            maxPerColor[color] = max(maxPerColor[color]!, value)
        }


        result += maxPerColor.reduce(1, { $0 * $1.value})
    }

    return result
}

private enum Color: String {
    case blue, red, green
}

private let color = Reference<Color>()
private let number = Reference<Int>()
private let colorRegex = Regex {
    Capture(as: number) {
        OneOrMore(.digit)
    } transform: { value in
        return Int(String(value))!
    }
    One(.whitespace)
    Capture(as: color) {
        ChoiceOf {
            "blue"
            "red"
            "green"
        }
    } transform: { value in
        return Color(rawValue: String(value))!
    }
}

