//
//  ErrorView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct ErrorView: View {
    let title: String
    let message: String
    let buttonTitle: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(PokemonTheme.orange.opacity(0.1))
                        .frame(width: 100, height: 100)

                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(PokemonTheme.orange)
                }

                VStack(spacing: 8) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(PokemonTheme.textPrimary)

                    Text(message)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(PokemonTheme.textSecondary)
                        .lineLimit(3)
                }
            }

            PokemonButton(title: buttonTitle, style: .primary) {
                retry()
            }
            .frame(maxWidth: 200)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.95))
    }
}
