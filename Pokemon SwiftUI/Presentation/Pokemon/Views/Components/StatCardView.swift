//
//  StatCardView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }

            VStack(spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(PokemonTheme.textSecondary)
                    .fontWeight(.medium)

                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(PokemonTheme.textPrimary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}
