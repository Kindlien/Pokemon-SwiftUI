//
//  NoResultsView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct NoResultsView: View {
    let searchText: String

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(PokemonTheme.orange.opacity(0.1))
                    .frame(width: 100, height: 100)

                Image(systemName: "magnifyingglass")
                    .font(.system(size: 50))
                    .foregroundColor(PokemonTheme.orange)
            }

            VStack(spacing: 8) {
                Text("No Pokemon Found")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(PokemonTheme.textPrimary)

                Text("No Pokemon match '\(searchText)'")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(PokemonTheme.textSecondary)
            }
        }
        .padding(40)
    }
}
