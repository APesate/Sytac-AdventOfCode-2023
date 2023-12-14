//
//  Day14Input.swift
//  AdventOfCode
//
//  Created by Andrés Pesate Temprano on 14/12/2023.
//

import Foundation

let day14TestInput =
"""
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
"""

let day14Input =
"""
O...#.O.OOO.OO.O.OOO...........OO#..##...#...#.O.#.O....#.##..#.#.OOO.O....#....O...O..OOOO.O#......
O#OO....#O....O..#..###....#.#..#.......#..#.#....O...O.#..O.O#.....#.O#...O.O..##..OO.#...O.O#.....
.O...#..#...##....##....O.OO#O....O.O..#O.....#O.O....#.#O#.#O......#O.....#.O..O.....O.....O...O##.
..O...#OO..O....OO.....OOOO#O.OO..#.........O.O........O..#.........##...O.........O#..O.....#O.OO##
OO.O....#O#..O..#.OO....OO.#.OO...##.O..O..O....OO...O....#.....#..O#OO....#....O.....OO.#.O......OO
#....O...O#..O.O...O...#O#O.#....O.##..#..........OO.#....O#O#..O.OOO.O....O.O.O.O#.O..O..O....O..O.
#.O#..O......OO.#.......O......#.#.O..##..OO..##O.#.O.O#...#.....O.#.O.OO#.O.O#...O.O.#....#.#OOO...
#..O.O.O..O.#.#.#..O#OO.O.O...#.......#...#.#....O.....OO..#.....O....#O...#O..##.O.#....O.....O.O#.
.#O..#........OO.OOO..O...O.O..#O#OO.O.#..#..O.....O.OO..O..#...O......O.O##.O.OO.#..O........#.....
.O.O.O........O..#.O.##....#.#.#..OO..#....O.O.O.O.....#.#..O....OO..O#..O###.OO.OO....#..#..O.##O..
O.O......#..##.O...#O.#OO.#..O..O...O.#OO...O..OO.O.O..OO....O.#.#.O#O#..O.#.#.OOOO..OO.O.O.O.O.#..O
O#.....#OO#....O..#..O##..OO.............#O#OO.##...O.......##......#O....O.#.O......##...........O.
...##.##..#O......#.......#.....#...#O.O.....#...O..O........O...OO.O..#....##....#O....#...O.O....#
..O.....OO.#..#O#.#OO..O.....O.......O.OOO#OOO.....O..O..O#...........##O..O.#...O.OOO..O.##O.#..#.O
.##...OOO.....#.O...#.O......#.O.O....O......#OOO...#..#.#.#.O...O.O.#.O.###.OO##O....O....#.##..#..
O..#.#.........O#...O...O.##..#....O.#..#O...##.OOOO#O#.......#..#.........#OO.##..#......O.##......
..#O...#......O.#.OO..#..O..O#....O.....#....O.#.#......####..##OO.O.O..O...#..#....#..#O#..#.#...O.
............O.......O.....O.#O...#.....###......O...#O....#.OO.##.....#.....O..O.O...O......#O#...OO
..#.O#.#.#..O.OO#.#..#.O.#..O.#.O.O...OO..OO.##..#.#O....O.......OO...O.....#..O..#....O.#...#...OO.
OO...#..#.#..O.OO#O#..##...#...O..#...........O.O.OO.O..#...OO.#.O..O#.#O#.O#.O...O..O...#O..#.O....
..O.O.#....#...#.O.#.O#...##.O#..#O...........O.##...#...#O..O.....#O.#O.....#..##.O..#.O.....#O.O..
.O..OO.O....#OO#....#.###O#..OO..##..#..##.....O.O.O........O.O.O.O#...O..#O#..O........#.O###..O.#.
O.#...O.O.OO#..##....OO...O.....O.O.#O....#...#....##.#..#OO...O#O....O...O.#O....#..#...OO..O.#....
..#...O......O#..O.#..#O#.#OO..#O.O..O..#...#........OOO#.OO.....O##O..#..OO.O##..O..#..O.O...O..O..
...##.#O.###.###...O..#.#O..#..O....O.#O......O.#....O..OOO..O..O..#..O.#.#.....O.#.#...O#.O..O...OO
...O.#....#..O##..#....O..O...O....OO.#.O..#O....#.....#.#........O....O#O.O....O...#.O..#..O.O#OO.O
.##O....#O#O.O.....#.O...........#..O.......#O...###....#O##O...##..OO.#O..#O.O..O.....#.OO#O..#O...
O.O..........O.#..OO.#...O.O..#..........#......O.......#..#O#...#O..##...O...O#.O..........##...#O.
..#..O..O..#O....O.O...#.O..O.#..O#O...O.#......O.#O..#O#....O#..#....##.#.O.#..##.....#.#.#.....O.#
.O##..#.#O.OOO...O.O..OOO..O..#.O..#..#..OO#..OO...O..O..O.O#O.#.....#O.#.#...#O#.O.O.OO..O.......#.
O..O#.OO.#O..O.##..O..OO#.O.....O.O..##....#O...#..#.#O.#O.O#..O...O.#OO#O.O..#.......O.......O.....
..#.#.##O...#.O.O..O...OO.....O#.....O.#...#O.#O.#....##O.....OOO.O..OO....O.O..##....O.O..#.....O.#
.....#.OO.O....O##..##..O...#......#..#..O..O...#O...#............O.#.......#O.O#......##.O.O.#....#
...#O#.#O.##..#.#...O.O...#..........O.O#....O.O..###.#..O...#.#OOO....OO.O.O#O##........#..O.O...O.
..OOO.O..O#..O#OO.#....O.............#....##.#O...O...O##.O..O..##.....O#....#O#...O.O#.O.#..OOO...#
.#.#..O.O.....#O#.....OO#..O.O..O.O............O..#.#.#.#......####.#O#..#..OO.O.OO#..O#.##....O#..O
........##O.#.......OO......O.OO.##..#..O......O#O...#...O.#......#OO..........O..OO...##..#..O.O.O.
..O#.O...#..O..O.##.....O..##....#...O..#.O..#..O.#.OO...###...#..O..O#..O.O..#.#....O#..#.#......O#
...#..#.#.#..#O..OO#..O.O#...........O.........#.O.OO..#.......O#....O.....#OO.....OO..OO...O.O.O.#.
...O#O......#...O...O..#.O.O#.#O.#....#.OO#.....O.O.#...O.#....O.#...#..O#..#..OOO.O..O.....O#....#O
..O..OO...O..#.#.O..#..#.O.#.O##O..OO..O........#....O##...#....#.#O.#..#......#....#.......O.......
#.........#.O#......OO............O.#......OO.O.#.OO.#..OO..O.##........#O#..OO.#...#.#.O.OO.#.O..#.
...O...#O...O....#..O#O#......#..OO#.O##OOO.#..#O.O#..O...O......O#......OOO..#...#O..OO#...........
.#.#..O#..O......#...O....OOO..#..........O....#..##..#...OO#...O.#.O.#.O......#....O##O..#OOO......
...O.##...#..O.......#.#.O..O..#.O.....OOOOOOO...#.....O.....#.....O...OOO.##...O#.OO.OO.#...#O#O...
....#.O..#.O.O..O..O#..O.#.......#....#.#....O.....O#....O##O..O..##.O#..OOO#..O.......#.O..O#OO..O.
##.O.............#.#....O...O.......#O#.....OO#O......O..#.......#.#..#...#.......O.O..O....O.#....#
..O..#O..#...#.........O..#.....O.O.#.....O..#..#O....O..O.....##.#...O..O.#..OO#O#...####.O.......#
.O#.#O#..O#...#.O......OOO.O.#..O.O#.#....####......##.O.O.#...#..#O..O........O.....#........O..#..
.O..O#....O.....O#.O.OOOO##.O..#OO.........##.O.##O...#O...#.O#OO##.....O....O###....###.#.........O
...O##O...O.O..........O#...O#.O...#O..O..##...O#.....O#.O....O...O#.##...#........OOO.O#....OO..###
O.O.O.....O.O..O....O#.OO.O.....O...#..#O#OO...OO..OO.O....#.O.OO....#..O.#O...O...#O#.O#...#.....OO
....#.....##.O#O..#O...OO...O#.#O..#.........OO..#......O..####OOO#...O#.............#.O....O.O..#OO
##O..O.O......O......OOOO..OO##..O........O.....O..O#..OO.O#.O#O#OO#O#..O.O.#..O...O.O.O......##....
..O.O.#..#.O...#.........O..###.#O..O.#..#......#...O##......O.#.O.O##.....O#..........O..O.....O.#.
....#...O.#...#.#.#.#.O.....O.OO#..O...O#..OOO.OO..O.#.........O.......OO..O..#.#...........#.......
O##...#......#OO..O...O..#O.#OO.##.O.O....#.....O.O.....#O.#....#....O.#.OO..##............#O...O.#.
.OO..##....#.OOO...O.O....O..O.........##..O#.O.OO.....#..OO#....O.O#.#..O.OOO...#.....O#...O.O..O.O
O.O...OO#...O.....O..#.O.........O.O.#...OO....#..O.O..OOO.O..#.O.#.##O#.#OOO.#..#O..O............#.
#..O.O..OO.#O.....#.O.#..O.........#.OO..##.O....#O..OO.O.O.O#.O...OO...O..O.O.O.#..O.....#.O.......
O##..O...##....#O..........O..#..O..O.#.#..O..#.O....#OO......##OOO.##......##.....O.#.........#....
..#.....#O..O.O......O..#.......#.OO#.....#.O.....O...O.....O#.......#.....#O...O#.#O.###..O.O..##.O
..O.OO.OO...OO.#.......#....#..#O............O.........O....#OO..O...##..O.O..O..OO..##.........O..O
#...O..#O.O..#O..O...#.O.#......O#....#.....O.##..OOO.....O...O.OO#......O...O..O.###OO...#OO.O.OO.#
O#..O....#O.....O#....O..#.O.###..O.OO.#....#...#.O..#O...O.O..O.O........O..#O.O.O..OOO.O..OO..O.#O
#O#.O....#..#......#.#........O...#......#..#.O........O..O.....#............O#..#O#OO#....O.OOOO#.O
...OOO.O........#..O...........#..#O...#.#OOO#....OO.O....#...##.#...#O...#.....OO.#...O..##.O....O.
O.O......#..#.#...OO..##O#..#O.OOO##...O.#O.......O....OOOO.O..O....#.OO#.O...#..O..O.#....#...O..#O
...O..OOO.#OO..O..#O.#O.O#.O..O....#OO.#..O.O.O.....##O...O.......#O..........##...#............O..#
...O.#......O##......#..#............#O#..O......##.#O.O.#OO....O.#..O...O.....O.O....#O.O.O##.#....
...OO......O#...#.O.#....O.OO.O.##.O..O......#.O.O.O...#O.O.O.O.....##....#...##...#....#OO..#OO#.##
....O....##..##.#.OO....##.....#.....O.O..OO..O...##...#..O##.##......OO.O...OO...OOO..O...##.#.#.O.
#.....O..O.....#.......#.O...........OO..O..O..#......O#.#.OO....#........#..#O.#O#...#..#OOO......O
.O###OO.O##......OO...##O....#..#.....##..#.#OO....#.O.O...#......O....#..O.O..O#O#.###......O....#.
.O..#OO...O#O.....O...#O.O..O..O..##.O..O#.O#.OO..O..O#....O.O.O...OO#....O....O.OOO.O....O...#.##..
.O........OO...#.OOO..O.#O.##..#..........O..........#.O...OO#.#..O.#O##O...#.....#O#.O#.......#....
OO.O.......##..O#OO...#.#.#.#.O..O......#..#OO.#...O............#.#.#.##....O.O..#...OO#.##..#O..O..
O..OO.....#..##.O.#O.....O.O.#...O#.#...#O.OO...O.O..#.##O..OO#..O...##..OO#..O##...O.....#.#..O#.OO
.O...#..#O#..OOO..O#.O#..#O...O.O#.....#...........O.##....O..O...#.OO............O.O#.....#O.O#..O.
..O.O.........#O...#...#..O#.#...#OO##..O#...#.OO#O....OO.O#O......OO...O#O.O....O#O..O#........O..O
#...O....OO.O#..#.#......#.....O#...O.#.O..O...#..O.O..O.O.#OO.O....#....#.......O......O...#.#..#..
.O..OO.O.#O....##O#..O.#O.#.#..#....##.#O...#.O......#.OO#...#O...O.#...O.OO.#.O.#.O...O....#...#...
..OO......O.O....O#..O..##.###.....O.#..##.#.O......O...#...#..O...O.O.#....#.#...O.O.#........#.#..
#...#..#.......#.O.O..#..OO..O.O..OOO.O..O..#......O..O..#OO##....O.#.#.O#O#..O#.##.O...#..#.O....#.
#.O#O.O.OOOO#...#..O#..#O#O..#....O...#.OO.#.###.O.......OO.O..O..OOO.#O.O.........#...#.O..O..O...#
.#.O..##..O...O....O......OO.............O.....OO#O..#.....#.OOO##O.OO........#..#.##..OO..........O
OOOOO....#O.O......O.#O#...#...#.#.#OO.O.#..O..##...##...O.....O...O...O##O..O.#O..O#.O...O.O...OOO.
.O..#..#.#..O.O.##O....#......O#.OOO..O....#O.#.###O.#.#.OO.O.#.OO.........#....#..OO.O.O.O##.#.##..
#O...O..O..O.O.O..........#.#...#O.O......O.O#...OO...#..O..O.....OO...#....#.##......O.........OO.O
..O..##..O.....O.O.....O.O.....O.O...##...O.......#...OO...#..O...#OO.O..#OO..#...#....OO###.O.....O
#...O......#.OO.....O......###..#...#...#.#.....OO#.#.O#..#......O....O.O...#..O#O#..##....#...#....
..O..#O...#.......O##..#.....O#..O#...OO.#..#.O.O..O..O#.#.OO.O.#..O..O..##...#.O....OO#O...........
.###.O.....#...#......#..#.....#..#....#..O.O....O.#..#..#O#.......#.O.O.....OO#.O...#OO.#..OO#.....
.#.....O...#O.........#....##.O......O.OO##...#.....#..#..O##.#...#..O..#O.O..#O...O..O.O...O.....O.
.#....##....O....O..OO....OO..#..#..OO...O..#.O.O..#..O###.O...#O.#.O.O.O.OO........###....OOO.....#
#.#..O..#.O#...#O.....#..O#.OO..O.#..OOO..O..#...O..O......O..#........#.#O#..O..O#OO.##.#.#.....#.O
......#.#.....O#....OO#...O#.#.O.O#.....O...##..###.....O#.....#..OO#.......OO....#...#.O......O....
.........O.#........O...O#.#....O..#..O#OOO..#...O.O.....#.#OO.O.OO......#.....OO#O...O...#...#O..OO
..O#..OO.OO#..O##.O..O.##O....#..O##.......#..O........#.O......#....#O..OOO#..OO.O...#...##O.O...OO
..#.....OOO..O.#O#.O##..##..O#.##..OO...#..O..O..#.OOO...O..O.#..O#..#.OO#..O.OO...OOO..O...O..#....
"""
