//
//  PokemonDetailSheet.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct PokemonDetailBottomSheet: View {
    let pokemon: Pokemon
    @StateObject private var viewModel: PokemonDetailViewModel
    @Environment(\.presentationMode) var presentationMode

    init(pokemon: Pokemon, databaseManager: CouchbaseManager) {
        self.pokemon = pokemon
        self._viewModel = StateObject(wrappedValue: PokemonDetailViewModel(databaseManager: databaseManager))
    }

    var body: some View {
        NavigationView {
            Group {
                if let pokemonDetail = viewModel.pokemonDetail {
                    PokemonDetailContentView(pokemon: pokemonDetail)
                } else if viewModel.isLoading {
                    LoadingView(message: "Loading Pokemon details...")
                } else if !viewModel.errorMessage.isEmpty {
                    ErrorView(
                        title: "Failed to Load",
                        message: viewModel.errorMessage,
                        buttonTitle: "Retry"
                    ) {
                        viewModel.fetchPokemonDetail(id: pokemon.id)
                    }
                } else {
                    LoadingView(message: "Preparing Pokemon data...")
                }
            }
            .navigationTitle(pokemon.name.capitalized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(PokemonTheme.primaryBlue)
                }
            }
        }
        .onAppear {
            viewModel.fetchPokemonDetail(id: pokemon.id)
        }
        .onDisappear {
            viewModel.clearDetail()
        }
    }
}
