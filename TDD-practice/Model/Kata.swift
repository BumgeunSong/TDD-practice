//
//  Kata.swift
//  TDD-practice
//
//  Created by 송범근 on 2023/08/05.
//

import Foundation

struct Kata: Hashable, Identifiable {
    let id: Int
    let name: String
    let topic: String
    let difficulty: Difficulty
}

enum Difficulty: String {
    case starter
}
