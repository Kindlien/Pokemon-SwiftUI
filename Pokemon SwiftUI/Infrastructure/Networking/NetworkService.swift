//
//  NetworkService.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI
import RxSwift
import Alamofire

class PokemonNetworkService: ObservableObject {
    private let baseURL = "https://pokeapi.co/api/v2"
    private let disposeBag = DisposeBag()

    func fetchPokemonList(offset: Int = 0, limit: Int = 100) -> Observable<PokemonListResponse> {
        let url = "\(baseURL)/pokemon?offset=\(offset)&limit=\(limit)"

        return Observable.create { observer in
            AF.request(url)
                .validate()
                .responseDecodable(of: PokemonListResponse.self) { response in
                    switch response.result {
                    case .success(let pokemonList):
                        observer.onNext(pokemonList)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }

            return Disposables.create()
        }
    }

    func fetchPokemonDetail(id: Int) -> Observable<PokemonDetail> {
        let url = "\(baseURL)/pokemon/\(id)"

        return Observable.create { observer in
            AF.request(url)
                .validate()
                .responseDecodable(of: PokemonDetail.self) { response in
                    switch response.result {
                    case .success(let pokemonDetail):
                        observer.onNext(pokemonDetail)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }

            return Disposables.create()
        }
    }

    func searchPokemon(name: String) -> Observable<PokemonDetail> {
        let url = "\(baseURL)/pokemon/\(name.lowercased())"

        return Observable.create { observer in
            AF.request(url)
                .validate()
                .responseDecodable(of: PokemonDetail.self) { response in
                    switch response.result {
                    case .success(let pokemonDetail):
                        observer.onNext(pokemonDetail)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }

            return Disposables.create()
        }
    }
}


