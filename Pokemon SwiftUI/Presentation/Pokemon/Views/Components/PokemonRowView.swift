//
//  PokemonRowView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI
import Kingfisher

struct PokemonRowView: View {
    let pokemon: Pokemon
    let onTap: () -> Void

    private var pokemonTypeColor: Color {
        let colorIndex = pokemon.id % 6
        switch colorIndex {
        case 0: return PokemonTheme.red
        case 1: return PokemonTheme.primaryBlue
        case 2: return PokemonTheme.green
        case 3: return PokemonTheme.purple
        case 4: return PokemonTheme.orange
        default: return PokemonTheme.yellow
        }
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [pokemonTypeColor.opacity(0.3), pokemonTypeColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 60, height: 60)

                    let imageURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.id).png")

                    KFImage(imageURL)
                        .placeholder {
                            Text(String(pokemon.name.prefix(2)).uppercased())
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .resizable()
                        .cacheOriginalImage()
                        .fade(duration: 0.25)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45, height: 45)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(pokemon.name.capitalized)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(PokemonTheme.textPrimary)

                    Text("Pokemon #\(pokemon.id)")
                        .font(.caption)
                        .foregroundColor(PokemonTheme.textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(pokemonTypeColor.opacity(0.1))
                        .cornerRadius(8)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(PokemonTheme.textSecondary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
