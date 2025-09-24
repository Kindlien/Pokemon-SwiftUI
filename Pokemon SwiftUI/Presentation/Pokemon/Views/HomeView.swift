//
//  HomeView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: PokemonViewModel

    init(databaseManager: CouchbaseManager) {
        self._viewModel = StateObject(wrappedValue: PokemonViewModel(databaseManager: databaseManager))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        HStack {
                            if viewModel.isSearching {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: PokemonTheme.primaryBlue))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(PokemonTheme.textSecondary)
                                    .font(.system(size: 16))
                            }

                            TextField("Search Pokemon by name or ID", text: $viewModel.searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.body)
                                .submitLabel(.search)
                                .onSubmit {
                                    if !viewModel.searchText.isEmpty {
                                        viewModel.performSearch(viewModel.searchText)
                                    }
                                }
                        }
                        .padding()
                        .background(PokemonTheme.cardBackground)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.isSearching ? PokemonTheme.primaryBlue : PokemonTheme.lightBlue, lineWidth: viewModel.isSearching ? 2 : 1)
                        )

                        if !viewModel.searchText.isEmpty {
                            Button("Clear") {
                                viewModel.clearSearch()
                            }
                            .foregroundColor(PokemonTheme.primaryBlue)
                            .fontWeight(.medium)
                        }
                    }


                    if !viewModel.searchText.isEmpty {
                        HStack {
                            if viewModel.isSearching {
                                Text("Searching Pokemon...")
                                    .font(.caption)
                                    .foregroundColor(PokemonTheme.primaryBlue)
                            } else if viewModel.filteredPokemonList.isEmpty && !viewModel.errorMessage.isEmpty {
                                Text(viewModel.errorMessage)
                                    .font(.caption)
                                    .foregroundColor(PokemonTheme.red)
                            } else if !viewModel.filteredPokemonList.isEmpty {
                                Text("\(viewModel.filteredPokemonList.count) Pokemon found")
                                    .font(.caption)
                                    .foregroundColor(PokemonTheme.green)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color.white)

                ScrollView {
                    LazyVStack(spacing: 12) {
                        Spacer().frame(height: 4)

                        if viewModel.filteredPokemonList.isEmpty && !viewModel.searchText.isEmpty && !viewModel.isSearching {
                            NoResultsView(searchText: viewModel.searchText)
                                .padding(.top, 40)
                        } else {
                            ForEach(viewModel.filteredPokemonList.filter { $0.id > 0 }) { pokemon in
                                PokemonRowView(pokemon: pokemon) {
                                    viewModel.selectPokemon(pokemon)
                                }
                                .onAppear {
                                    if viewModel.searchText.isEmpty && pokemon.id == viewModel.filteredPokemonList.last?.id {
                                        viewModel.fetchNextPage()
                                    }
                                }
                            }
                        }

                        if viewModel.isLoading && !viewModel.filteredPokemonList.isEmpty && viewModel.searchText.isEmpty {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: PokemonTheme.primaryBlue))
                                Text("Loading more Pokemon...")
                                    .foregroundColor(PokemonTheme.textSecondary)
                                    .font(.caption)
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    .padding(.horizontal)
                }
                .background(Color(UIColor.systemGroupedBackground))
            }
            .navigationTitle("Pokemon")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            if !viewModel.hasInitiallyLoaded {
                viewModel.preloadEssentialData()
            }
        }
        .sheet(isPresented: $viewModel.showingDetail) {
            if let pokemon = viewModel.selectedPokemon {
                PokemonDetailBottomSheet(pokemon: pokemon, databaseManager: viewModel.databaseManager)
            }
        }
    }
}

