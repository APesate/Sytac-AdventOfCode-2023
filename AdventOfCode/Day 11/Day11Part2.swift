//
//  Day11Part2.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 11/12/2023.
//

import Foundation

/*
 ...#......
 .......#..
 #.........
 ..........
 ......#...
 .#........
 .........#
 ..........
 .......#..
 #...#.....
 */

public func day11Part2(_ input: String) -> Int {
    let input: [[Character]] = input
        .split(whereSeparator: \.isNewline)
        .map { String($0).map { $0 }  }

    let (rowsToExpand, colsToExpand) = universeExpansion(input)
    var universeCoordinates = universeCoordinate(input)
    var pairsDistances: [Int] = []

    var targetUniverse = universeCoordinates.removeFirst()

    while !universeCoordinates.isEmpty {
        pairsDistances.append(contentsOf: universeCoordinates
            .map { pairingUni in
                var distance = (abs(pairingUni.0 - targetUniverse.0) + abs(pairingUni.1 - targetUniverse.1))
                let hor = (min(targetUniverse.0, pairingUni.0)...max(targetUniverse.0, pairingUni.0))
                let ver = (min(targetUniverse.1, pairingUni.1)...max(targetUniverse.1, pairingUni.1))
                distance += rowsToExpand.filter({ hor.contains($0) }).count * 999999
                distance += colsToExpand.filter({ ver.contains($0) }).count * 999999
                return distance
            }
        )
        targetUniverse = universeCoordinates.removeFirst()
    }

    return pairsDistances.reduce(0, { $0 + $1 })
}

private func universeCoordinate(_ input: [[Character]]) -> [(Int, Int)] {
    var res: [(Int, Int)] = []

    for i in (0..<input.count) {
        for j in (0..<input[i].count) {
            if input[i][j] == "#" {
                res.append((i, j))
            }
        }
    }

    return res
}

private func universeExpansion(_ input: [[Character]]) -> ([Int], [Int]) {
    let emptyRows: [Int] = input.enumerated().compactMap { (index, row) in
        guard row.allSatisfy({ $0 == "." }) else { return nil }
        return index
    }
    var emptyCols: [Int] = []

    for j in (0..<input.first!.count) {
        var isEmptyCol = true
        for i in (0..<input.count) {
            isEmptyCol = input[i][j] == "."
            if !isEmptyCol { break }
        }

        guard isEmptyCol else { continue }
        emptyCols.append(j)
    }

    return (emptyRows, emptyCols)
}
