//
//  DetailView.swift
//  swifui-mvvm-list
//
//  Created by Amini on 22/04/25.
//
import SwiftUI

struct DetailView: View {
    let claim: Claim

    var body: some View {
        VStack(alignment: .leading) {
            Text(claim.body).font(.body)
            Spacer()
        }
        .padding()
        .navigationTitle(claim.title)
    }
}
