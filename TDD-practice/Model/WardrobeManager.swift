//
//  WardrobeManager.swift
//  TDD-practice
//
//  Created by 송범근 on 2023/08/05.
//

import Foundation

struct WardrobeManager {
    private let elements = [50, 75, 100, 120]
    private let wallLength = 250

    func combinations() -> [[Int]] {

        let maxCountOfCombination = wallLength / elements.min()!
        return (1...maxCountOfCombination).reduce(into: [[Int]](), { partialResult, count in
            partialResult += combinationsWithRepetition(elements: elements, count: count, sum: wallLength)
        }).filter { combination in
            combination.reduce(0, +) == wallLength
        }
    }

    func combinationsWithRepetition(elements: [Int], count: Int, sum: Int) -> [[Int]] {
        if sum < 0 { return [[]] }
        if count == 0 { return [[]] }
        if elements.isEmpty { return [] }

        var combinations = [[Int]]()

        for (i, element) in elements.enumerated() {
            let smallerCombinations = combinationsWithRepetition(
                elements: Array(elements.suffix(from: i)),
                count: count - 1,
                sum: sum - elements[i]
            )
            smallerCombinations.forEach { smallCombination in
                combinations.append([element] + smallCombination)
            }
        }
        return combinations
    }
}
