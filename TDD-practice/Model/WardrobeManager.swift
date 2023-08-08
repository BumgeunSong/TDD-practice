//
//  WardrobeManager.swift
//  TDD-practice
//
//  Created by 송범근 on 2023/08/05.
//

import Foundation

struct WardrobeManager {
    private let elements = [50, 75, 100, 120]

    func combinations() -> [[Int]] {
        var result = [[Int]]()

        let maxCountOfCombination = 250 / elements.min()!
        for i in (1...maxCountOfCombination) {
            result += combinationsWithRepetition(elements: elements, count: i, sum: 250)
        }

        return result.filter { combination in
            combination.reduce(0, +) == 250
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
