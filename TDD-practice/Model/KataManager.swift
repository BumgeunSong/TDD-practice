//
//  KataManager.swift
//  TDD-practice
//
//  Created by 송범근 on 2023/08/05.
//

import Foundation
import Combine

final class KataManager {
    @Published var katas: [Kata] = [
        Kata(
            id: 0,
            name: "Christmas Lights",
            topic: "TDD | Software-Design",
            difficulty: .starter
        ),
        Kata(
            id: 1,
            name: "Configure your own Wardrobe",
            topic: "TDD | Software-Design",
            difficulty: .starter
        )
    ]
}
