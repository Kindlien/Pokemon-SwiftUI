//
//  PokemonDetailViewModel.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI
import RxSwift

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemonDetail: PokemonDetail?
    @Published var isLoading = false
    @Published var errorMessage = ""

    private let networkService = PokemonNetworkService()
    private let databaseManager: CouchbaseManager
    private let hudManager = HUDManager()
    private let disposeBag = DisposeBag()

    init(databaseManager: CouchbaseManager) {
        self.databaseManager = databaseManager
    }

    func fetchPokemonDetail(id: Int) {
        guard !isLoading else { return }

        if let cachedDetail = databaseManager.getCachedPokemonDetail(id: id) {
            pokemonDetail = cachedDetail
        }

        setLoading(true, message: "Loading Pokemon Details...")
        errorMessage = ""

        networkService.fetchPokemonDetail(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] detail in
                    guard let self = self else { return }
                    self.pokemonDetail = detail
                    self.databaseManager.cachePokemonDetail(detail)
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    if self.pokemonDetail == nil {
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

    func clearDetail() {
        pokemonDetail = nil
        errorMessage = ""
        setLoading(false)
    }
}
