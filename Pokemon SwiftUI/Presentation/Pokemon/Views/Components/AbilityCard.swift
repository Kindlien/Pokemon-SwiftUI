//
//  AbilityCard.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct AbilityCard: View {
    let name: String
    let isHidden: Bool
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 44, height: 44)

                Image(systemName: isHidden ? "eye.slash.fill" : "star.fill")
                    .font(.title3)
                    .foregroundColor(isHidden ? PokemonTheme.orange : color)
            }

            VStack(spacing: 4) {
                Text(name.capitalized.replacingOccurrences(of: "-", with: " "))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(PokemonTheme.textPrimary)
                    .lineLimit(2)

                if isHidden {
                    Text("Hidden")
                        .font(.caption2)
                        .foregroundColor(PokemonTheme.orange)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(PokemonTheme.orange.opacity(0.1))
                        .cornerRadius(4)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(0.2), lineWidth: 1.5)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
}
