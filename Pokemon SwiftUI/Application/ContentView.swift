//
//  ContentView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 21/09/25.
//

import SwiftUI
import Combine
import Foundation
import Alamofire
import Kingfisher
import RxSwift
import RxCocoa
import MBProgressHUD
import CouchbaseLiteSwift

struct ContentView: View {
    @StateObject private var databaseManager = CouchbaseManager()
    @State private var showSplash = true

    var body: some View {
        ZStack {
            Group {
                if databaseManager.isLoggedIn {
                    MainTabView(databaseManager: databaseManager)
                } else {
                    LoginView(databaseManager: databaseManager)
                }
            }
            .opacity(showSplash ? 0 : 1)
            .animation(.easeInOut(duration: 0.5), value: showSplash)

            if showSplash {
                SplashScreenView(showSplash: $showSplash)
                    .transition(.opacity)
            }
        }
        .onAppear {
            setupApp()
        }
    }

    private func setupApp() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.white
        navBarAppearance.shadowColor = UIColor.lightGray.withAlphaComponent(0.3)
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(PokemonTheme.textPrimary)
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(PokemonTheme.textPrimary)
        ]

        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = UIColor(PokemonTheme.primaryBlue)
    }
}
