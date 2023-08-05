//
//  KataDetail.swift
//  TDD-practice
//
//  Created by 송범근 on 2023/08/05.
//

import SwiftUI

struct KataDetail: View {
    init(kata: Kata) {
        self.kata = kata
    }

    private let kata: Kata


    var body: some View {
        VStack(alignment: .leading) {
            Text(kata.name)
                .font(.title)
            Divider()
            HStack {
                Text(kata.topic)
                Spacer()
                Text(kata.difficulty.rawValue)
            }
        }.padding()
    }
}

struct KataDetail_Previews: PreviewProvider {
    static var previews: some View {
        KataDetail(kata: Kata(
            id: 0,
            name: "Christmas Lights",
            topic: "TDD | Software-Design",
            difficulty: .starter
        ))
    }
}
