//
//  Pokemon.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct Pokemon: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let url: String?

    init(id: Int, name: String, url: String? = nil) {
        self.id = id
        self.name = name
        self.url = url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decodeIfPresent(String.self, forKey: .url)

        if let urlString = url {
            let components = urlString.split(separator: "/").filter { !$0.isEmpty }
            if let lastComponent = components.last, let extractedId = Int(lastComponent) {
                id = extractedId
            } else {
                id = 0
            }
        } else {
            id = 0
        }
    }
}
