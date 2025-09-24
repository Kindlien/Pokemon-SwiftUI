//
//  LoadingView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct LoadingView: View {
    let message: String
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .stroke(PokemonTheme.lightBlue.opacity(0.3), lineWidth: 4)
                    .frame(width: 60, height: 60)

                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [PokemonTheme.primaryBlue, PokemonTheme.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 1)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
            .onAppear {
                isAnimating = true
            }

            Text(message)
                .font(.subheadline)
                .foregroundColor(PokemonTheme.textSecondary)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.95))
    }
}
