//
//  Pokemon_SwiftUIApp.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 21/09/25.
//

import SwiftUI
import Kingfisher

@main
struct Pokemon_SwiftUIApp: App {

    init() {
        configureImageCache()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    func configureImageCache() {
        ImageCache.default.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024

        ImageCache.default.diskStorage.config.expiration = .days(7)

        let preloader = ImagePrefetcher(urls: [
            URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!,
            URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png")!,
            URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png")!
        ])
        preloader.start()
    }
}
