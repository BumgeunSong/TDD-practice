//
//  KataList.swift
//  TDD-practice
//
//  Created by 송범근 on 2023/08/05.
//

import SwiftUI

struct KataList: View {
    init() {}

    private let kataManager = KataManager()

    var body: some View {
        NavigationView {
            List(kataManager.katas) { kata in
                NavigationLink {
                    KataDetail(kata: kata)
                } label: {
                    KataRow(kata: kata)
                }
            }
            .navigationTitle("Katas")
        }
    }
}

struct KataList_Previews: PreviewProvider {
    static var previews: some View {
        KataList()
    }
}
