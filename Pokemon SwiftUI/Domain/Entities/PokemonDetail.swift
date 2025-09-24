//
//  PokemonDetail.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let height: Int?
    let weight: Int?
    let abilities: [AbilityWrapper]
    let sprites: Sprites?
    let types: [TypeWrapper]?

    struct AbilityWrapper: Codable {
        let ability: Ability
        let isHidden: Bool?

        enum CodingKeys: String, CodingKey {
            case ability
            case isHidden = "is_hidden"
        }

        struct Ability: Codable {
            let name: String
            let url: String?
        }
    }

    struct TypeWrapper: Codable {
        let slot: Int
        let type: PokemonType

        struct PokemonType: Codable {
            let name: String
        }
    }

    struct Sprites: Codable {
        let frontDefault: String?
        let frontShiny: String?

        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
            case frontShiny = "front_shiny"
        }
    }
}
