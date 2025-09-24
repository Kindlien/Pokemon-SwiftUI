//
//  PokemonListResponse.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}
