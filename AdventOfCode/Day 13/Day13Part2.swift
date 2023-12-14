//
//  Day13Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 13/12/2023.
//

import Foundation

public func day13Part2(_ input: String) -> Int {
    let input = parse(input)
    var result = 0

    for (index, section) in input.enumerated() {
        let ver = hasVerticalReflection(section) ?? -1
        let hor = hasHorizontalReflection(section) ?? -1
        print("\(index): [V: \(ver), H: \(hor)]")

        guard ver != -1 || hor != -1 else {
            fatalError("Unparsed input\n\(section.map({ String($0) }).joined(separator: "\n"))")
        }

        if hor > 0 {
            result += hor * 100
        } else {
            result += ver
        }
    }

    return result
}

// MARK: - Vertical

private func hasVerticalReflection(_ input: [[Character]]) -> Int? {
    var map: [String: [Int]] = [:]

    for j in (0..<input.first!.count) {
        var key = ""
        for i in (0..<input.count) {
            key.append(String(input[i][j]))
        }

        let matchingKeyWithOneError = checkForPossibleMatch(map, key)
        let possibleMatches = map.filter({ matchingKeyWithOneError?.contains($0.key) == true })

        if map[key] != nil || matchingKeyWithOneError != nil {
            if (map[key]?.contains(j - 1) == true || possibleMatches.values.contains(where: { $0.contains(j - 1) }))
                && checkVerticalMidPoint(input, j, map) {
                return j
            }

            if map[key] != nil {
                map[key]?.append(j)
            } else {
                map[key] = [j]
            }
        } else {
            map[key] = [j]
        }
    }

    return nil
}

private func checkVerticalMidPoint(_ input: [[Character]], _ midPoint: Int, _ map: [String: [Int]]) -> Bool {
    var reflectionPointToCheck = midPoint - 1
    var joker = false

    for j in (midPoint..<input.first!.count) where reflectionPointToCheck >= 0 {
        var key = ""
        for i in (0..<input.count) {
            key.append(String(input[i][j]))
        }

       if !joker,
                  let reflectionLineIndex = map.firstIndex(where: { $0.value.contains(reflectionPointToCheck) }),
                  let matchingKeyWithOneError = checkForPossibleMatch([map[reflectionLineIndex].key: map[reflectionLineIndex].value], key)?.first,
                  map[matchingKeyWithOneError] != nil && map[matchingKeyWithOneError]!.contains(reflectionPointToCheck) {
            joker.toggle()
            reflectionPointToCheck -= 1
       } else  if map[key] != nil && map[key]!.contains(reflectionPointToCheck) {
           reflectionPointToCheck -= 1
       } else {
            return false
        }
    }

    return joker
}

// MARK: - Horizontal

private func hasHorizontalReflection(_ input: [[Character]]) -> Int? {
    var map: [String: [Int]] = [:]

    for i in (0..<input.count) {
        var key = ""
        for j in (0..<input.first!.count) {
            key.append(String(input[i][j]))
        }

        let matchingKeyWithOneError = checkForPossibleMatch(map, key)
        let possibleMatches = map.filter({ matchingKeyWithOneError?.contains($0.key) == true })

        if map[key] != nil || matchingKeyWithOneError != nil {
            if (map[key]?.contains(i - 1) == true || possibleMatches.values.contains(where: { $0.contains(i - 1) }))
                && checkHorizontalMidPoint(input, i, map) {
                return i
            }
            
            if map[key] != nil {
                map[key]?.append(i)
            } else {
                map[key] = [i]
            }
        } else {
            map[key] = [i]
        }
    }

    return nil
}

private func checkHorizontalMidPoint(_ input: [[Character]], _ midPoint: Int, _ map: [String: [Int]]) -> Bool {
    var reflectionPointToCheck = midPoint - 1
    var joker = false

    for i in (midPoint..<input.count) where reflectionPointToCheck >= 0 {
        var key = ""
        for j in (0..<input.first!.count) {
            key.append(String(input[i][j]))
        }

        if !joker,
           let reflectionLineIndex = map.firstIndex(where: { $0.value.contains(reflectionPointToCheck) }),
           let matchingKeyWithOneError = checkForPossibleMatch([map[reflectionLineIndex].key: map[reflectionLineIndex].value], key)?.first,
           map[matchingKeyWithOneError] != nil && map[matchingKeyWithOneError]!.contains(reflectionPointToCheck) {
            joker.toggle()
            reflectionPointToCheck -= 1
        } else if map[key] != nil && map[key]!.contains(reflectionPointToCheck) {
            reflectionPointToCheck -= 1
        } else {
            return false
        }
    }

    return joker
}

// MARK: - Utils

private func checkForPossibleMatch(_ map: [String: [Int]], _ key: String) -> [String]? {
    var possible: [String] = []

    for visited in map.keys {
        let differences = visited.enumerated().filter({ (index, char) in
            let inKey = key[key.index(key.startIndex, offsetBy: index)]
            return inKey != char
        })
        if differences.count == 1 {
            possible.append(visited)
        }
    }

    return possible.isEmpty ? nil : possible
}

private func parse(_ input: String) -> [[[Character]]] {
    input
        .split(separator: "\n\n")
        .map {
            $0
                .split(whereSeparator: \.isNewline)
                .map { $0.compactMap { $0 } }
        }
}
