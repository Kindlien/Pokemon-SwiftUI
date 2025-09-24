//
//  PokemonDetailView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI
import Kingfisher

struct PokemonDetailContentView: View {
    let pokemon: PokemonDetail

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
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                colors: [pokemonTypeColor.opacity(0.3), pokemonTypeColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 200, height: 200)
                            .shadow(color: pokemonTypeColor.opacity(0.2), radius: 10, x: 0, y: 5)

                        if let imageURL = pokemon.sprites?.frontDefault,
                           let url = URL(string: imageURL) {
                            KFImage(url)
                                .placeholder {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: pokemonTypeColor))
                                        .scaleEffect(1.2)
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 160, height: 160)
                        } else {
                            Text(String(pokemon.name.prefix(3)).uppercased())
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }

                    VStack(spacing: 12) {
                        Text(pokemon.name.capitalized)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(PokemonTheme.textPrimary)

                        HStack(spacing: 12) {
                            Text("Pokemon #\(pokemon.id)")
                                .font(.title3)
                                .foregroundColor(PokemonTheme.textSecondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(pokemonTypeColor.opacity(0.15))
                                .cornerRadius(20)

                            if let types = pokemon.types, !types.isEmpty {
                                ForEach(types.sorted(by: { $0.slot < $1.slot }), id: \.slot) { typeWrapper in
                                    Text(typeWrapper.type.name.capitalized)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(getTypeColor(typeWrapper.type.name))
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 20)

                if let height = pokemon.height, let weight = pokemon.weight {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(pokemonTypeColor)
                            Text("Physical Stats")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(PokemonTheme.textPrimary)
                            Spacer()
                        }

                        HStack(spacing: 16) {
                            StatCard(
                                icon: "ruler",
                                title: "Height",
                                value: String(format: "%.1f m", Double(height) / 10),
                                color: PokemonTheme.green
                            )

                            StatCard(
                                icon: "scalemass",
                                title: "Weight",
                                value: String(format: "%.1f kg", Double(weight) / 10),
                                color: PokemonTheme.orange
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }

                if !pokemon.abilities.isEmpty {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Image(systemName: "star.circle.fill")
                                .foregroundColor(pokemonTypeColor)
                            Text("Abilities")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(PokemonTheme.textPrimary)
                            Spacer()
                        }

                        let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: min(pokemon.abilities.count, 2))

                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(pokemon.abilities, id: \.ability.name) { abilityWrapper in
                                AbilityCard(
                                    name: abilityWrapper.ability.name,
                                    isHidden: abilityWrapper.isHidden ?? false,
                                    color: pokemonTypeColor
                                )
                            }
                        }

                        // If there are many abilities, show them in a vertical list instead
                        if pokemon.abilities.count > 4 {
                            VStack(spacing: 12) {
                                ForEach(pokemon.abilities, id: \.ability.name) { abilityWrapper in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(abilityWrapper.ability.name.capitalized.replacingOccurrences(of: "-", with: " "))
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(PokemonTheme.textPrimary)

                                            if abilityWrapper.isHidden == true {
                                                Text("Hidden Ability")
                                                    .font(.caption2)
                                                    .foregroundColor(PokemonTheme.orange)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(PokemonTheme.orange.opacity(0.1))
                                                    .cornerRadius(4)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(pokemonTypeColor.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Spacer(minLength: 40)
            }
            .padding(.bottom, 20)
        }
        .background(
            LinearGradient(
                colors: [Color.white, pokemonTypeColor.opacity(0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }

    private func getTypeColor(_ typeName: String) -> Color {
        switch typeName.lowercased() {
        case "fire": return PokemonTheme.red
        case "water": return PokemonTheme.primaryBlue
        case "grass": return PokemonTheme.green
        case "electric": return PokemonTheme.yellow
        case "psychic": return PokemonTheme.purple
        case "dragon": return PokemonTheme.secondaryBlue
        case "fighting": return PokemonTheme.orange
        default: return pokemonTypeColor
        }
    }
}
