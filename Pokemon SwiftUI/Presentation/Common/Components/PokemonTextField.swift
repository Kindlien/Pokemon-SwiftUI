//
//  PokemonTextField.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct PokemonTextField: View {
    let title: String
    @Binding var text: String
    let isSecure: Bool

    init(_ title: String, text: Binding<String>, isSecure: Bool = false) {
        self.title = title
        self._text = text
        self.isSecure = isSecure
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(PokemonTheme.textSecondary)
                .fontWeight(.medium)

            Group {
                if isSecure {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }
            .textFieldStyle(PlainTextFieldStyle())
            .padding()
            .background(PokemonTheme.cardBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(PokemonTheme.lightBlue, lineWidth: 1)
            )
        }
    }
}

