//
//  PokemonViewModel.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import Combine
import SwiftUI
import RxSwift

class PokemonViewModel: ObservableObject {
    @Published var allPokemonList: [Pokemon] = []
    @Published var filteredPokemonList: [Pokemon] = []
    @Published var searchResults: [Pokemon] = []
    @Published var isLoading = false
    @Published var isSearching = false
    @Published var errorMessage = ""
    @Published var searchText = "" {
        didSet {
            handleSearchTextChange(oldValue: oldValue)
        }
    }
    @Published var selectedPokemon: Pokemon?
    @Published var showingDetail = false

    var hasInitiallyLoaded = false
    let databaseManager: CouchbaseManager

    private let networkService = PokemonNetworkService()
    private let hudManager = HUDManager()
    private let disposeBag = DisposeBag()
    private var currentOffset = 0
    private let limit = 10
    private var canLoadMore = true
    private var searchDisposable: Disposable?

    init(databaseManager: CouchbaseManager) {
        self.databaseManager = databaseManager
        loadInitialData()
    }

    func performSearch(_ searchTerm: String) {
        guard !searchTerm.isEmpty else { return }

        isSearching = true
        errorMessage = ""

        let localResults = filterLocalPokemon(searchTerm)

        searchFromAPI(searchTerm, localResults: localResults)
    }

    private func handleSearchTextChange(oldValue: String) {
        searchDisposable?.dispose()

        if searchText.isEmpty {
            searchResults = []
            filteredPokemonList = allPokemonList
            isSearching = false
        } else if searchText != oldValue {
            searchDisposable = Observable.just(searchText)
                .delay(.milliseconds(500), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] searchTerm in
                    if self?.searchText == searchTerm {
                        self?.performSearch(searchTerm)
                    }
                })
            searchDisposable?.disposed(by: disposeBag)
        }
    }

    private func filterLocalPokemon(_ searchTerm: String) -> [Pokemon] {
        let lowercaseSearch = searchTerm.lowercased()
        return allPokemonList.filter { pokemon in
            pokemon.name.lowercased().contains(lowercaseSearch) ||
            String(pokemon.id).contains(searchTerm)
        }
    }

    private func searchFromAPI(_ searchTerm: String, localResults: [Pokemon]) {
        let exactNameSearch = networkService.searchPokemon(name: searchTerm)
            .map { Optional($0) }
            .catchAndReturn(nil)

        let idSearch: Observable<PokemonDetail?>
        if let pokemonId = Int(searchTerm) {
            idSearch = networkService.fetchPokemonDetail(id: pokemonId)
                .map { Optional($0) }
                .catchAndReturn(nil)
        } else {
            idSearch = Observable.just(nil)
        }

        let combinedSearch = Observable.merge(exactNameSearch, idSearch)
            .catchAndReturn(nil)
            .compactMap { $0 }

        combinedSearch
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] pokemonDetail in
                    guard let self = self else { return }

                    let pokemon = Pokemon(
                        id: pokemonDetail.id,
                        name: pokemonDetail.name,
                        url: "https://pokeapi.co/api/v2/pokemon/\(pokemonDetail.id)/"
                    )

                    self.databaseManager.cachePokemonDetail(pokemonDetail)

                    var updatedResults = localResults
                    if !updatedResults.contains(where: { $0.id == pokemon.id }) {
                        updatedResults.append(pokemon)
                        updatedResults.sort { $0.id < $1.id }
                    }

                    self.searchResults = updatedResults
                    self.filteredPokemonList = updatedResults

                    self.databaseManager.cachePokemon([pokemon])

                    if !self.allPokemonList.contains(where: { $0.id == pokemon.id }) {
                        self.allPokemonList.append(pokemon)
                        self.allPokemonList.sort { $0.id < $1.id }
                    }
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.searchResults = localResults
                    self.filteredPokemonList = localResults
                    if localResults.isEmpty {
                        self.errorMessage = "Pokemon '\(searchTerm)' not found"
                    }
                    self.isSearching = false
                },
                onCompleted: { [weak self] in
                    guard let self = self else { return }

                    if self.searchResults.isEmpty && !localResults.isEmpty {
                        self.searchResults = localResults
                        self.filteredPokemonList = localResults
                    }

                    if self.filteredPokemonList.isEmpty {
                        self.errorMessage = "Pokemon '\(searchTerm)' not found"
                    }

                    self.isSearching = false
                }
            )
            .disposed(by: disposeBag)
        searchResults = localResults
        filteredPokemonList = localResults
    }

    func loadInitialData() {
        let cachedPokemon = databaseManager.getCachedPokemon()
        if !cachedPokemon.isEmpty {
            allPokemonList = cachedPokemon
            filteredPokemonList = cachedPokemon
            hasInitiallyLoaded = true
        }

        if cachedPokemon.count < 10 {
            fetchAllPokemon()
        }
    }

    func fetchNextPage() {
        guard !isLoading && canLoadMore else { return }

        setLoading(true, message: "Loading more Pokemon...")

        networkService.fetchPokemonList(offset: currentOffset, limit: limit)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] response in
                    guard let self = self else { return }

                    let newPokemon = response.results.sorted { $0.id < $1.id }
                    self.allPokemonList.append(contentsOf: newPokemon)

                    if !self.searchText.isEmpty {
                        self.performSearch(self.searchText)
                    } else {
                        self.filteredPokemonList = self.allPokemonList
                    }

                    DispatchQueue.global(qos: .utility).async {
                        self.databaseManager.cachePokemon(newPokemon)
                    }

                    self.currentOffset += self.limit
                    self.canLoadMore = !newPokemon.isEmpty
                },
                onError: { [weak self] error in
                    self?.setLoading(false)
                },
                onCompleted: { [weak self] in
                    self?.setLoading(false)
                }
            )
            .disposed(by: disposeBag)
    }

    func fetchAllPokemon() {
        guard !isLoading else { return }

        setLoading(true, message: "Catching Pokemon...")
        errorMessage = ""

        networkService.fetchPokemonList(offset: 0, limit: limit)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] response in
                    guard let self = self else { return }

                    self.allPokemonList = response.results.sorted { $0.id < $1.id }

                    if !self.searchText.isEmpty {
                        self.performSearch(self.searchText)
                    } else {
                        self.filteredPokemonList = self.allPokemonList
                    }

                    self.databaseManager.cachePokemon(self.allPokemonList)
                    self.hasInitiallyLoaded = true
                },
                onError: { [weak self] error in
                    guard let self = self else { return }

                    if self.allPokemonList.isEmpty {
                        self.errorMessage = error.localizedDescription
                    }
                    self.setLoading(false)
                },
                onCompleted: { [weak self] in
                    self?.setLoading(false)
                }
            )
            .disposed(by: disposeBag)
    }

    private func setLoading(_ loading: Bool, message: String = "") {
        isLoading = loading

        if loading {
            hudManager.show(message)
        } else {
            hudManager.hide()
        }
    }

    func selectPokemon(_ pokemon: Pokemon) {
        selectedPokemon = pokemon
        showingDetail = true
    }

    func refreshData() {
        fetchAllPokemon()
    }

    func clearSearch() {
        searchText = ""
        searchResults = []
        filteredPokemonList = allPokemonList
        errorMessage = ""
        isSearching = false
        searchDisposable?.dispose()
    }

    func preloadEssentialData() {
        let cachedPokemon = databaseManager.getCachedPokemon()
        if !cachedPokemon.isEmpty {
            allPokemonList = cachedPokemon
            filteredPokemonList = cachedPokemon
            hasInitiallyLoaded = true
        }

        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.fetchAllPokemon()
        }
    }
}
