//
//  AuthHeaderView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct AuthHeaderView: View {
    let isRegistering: Bool

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [PokemonTheme.primaryBlue, PokemonTheme.purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 120, height: 120)

                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
            }

            VStack(spacing: 8) {
                Text(isRegistering ? "Create Account" : "Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(PokemonTheme.textPrimary)

                Text(isRegistering ? "Join the Pokemon community" : "Sign in to continue your journey")
                    .foregroundColor(PokemonTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 40)
    }
}

