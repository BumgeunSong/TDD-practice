//
//  KataRow.swift
//  TDD-practice
//
//  Created by 송범근 on 2023/08/05.
//

import Foundation
import SwiftUI

struct KataRow: View {
    var kata: Kata

    var body: some View {
        Text("\(kata.name)")
    }
}

struct KataRow_Previews: PreviewProvider {
    static var previews: some View {
        KataRow(kata: Kata(
            id: 0,
            name: "Christmas Lights",
            topic: "TDD | Software-Design",
            difficulty: .starter
        ))
    }
}
