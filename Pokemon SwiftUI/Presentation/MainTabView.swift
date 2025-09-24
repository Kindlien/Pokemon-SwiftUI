//
//  MainTabView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var databaseManager: CouchbaseManager

    var body: some View {
        TabView {
            HomeView(databaseManager: databaseManager)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            ProfileView(databaseManager: databaseManager)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(PokemonTheme.primaryBlue)
        .onAppear {
            setupTabBarAppearance()
        }
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.shadowColor = UIColor.lightGray

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
