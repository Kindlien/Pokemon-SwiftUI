//
//  PokemonButton.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct PokemonButton: View {
    let title: String
    let action: () -> Void
    let isLoading: Bool
    let style: ButtonStyle

    enum ButtonStyle {
        case primary, secondary

        var backgroundColor: Color {
            switch self {
            case .primary: return PokemonTheme.primaryBlue
            case .secondary: return PokemonTheme.cardBackground
            }
        }

        var foregroundColor: Color {
            switch self {
            case .primary: return .white
            case .secondary: return PokemonTheme.textPrimary
            }
        }
    }

    init(title: String, isLoading: Bool = false, style: ButtonStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
                        .scaleEffect(0.8)
                }

                Text(title)
                    .fontWeight(.semibold)
            }
            .foregroundColor(style.foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(style.backgroundColor)
            .cornerRadius(12)
            .shadow(color: style.backgroundColor.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .disabled(isLoading)
    }
}

