//
//  ProfileView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var databaseManager: CouchbaseManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    if let user = databaseManager.currentUser {
                        VStack(spacing: 24) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(
                                        colors: [PokemonTheme.primaryBlue, PokemonTheme.purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 120, height: 120)
                                    .shadow(color: PokemonTheme.primaryBlue.opacity(0.3), radius: 15, x: 0, y: 8)

                                Text(String(user.username.prefix(2)).uppercased())
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            VStack(spacing: 8) {
                                Text(user.username)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(PokemonTheme.textPrimary)

                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(PokemonTheme.textSecondary)

                                Text("Trainer since \(user.createdAt, style: .date)")
                                    .font(.caption)
                                    .foregroundColor(PokemonTheme.textSecondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(PokemonTheme.lightBlue.opacity(0.5))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.top, 40)

                        VStack(spacing: 16) {
                            ProfileInfoCard(
                                icon: "envelope.fill",
                                iconColor: PokemonTheme.red,
                                title: "Email Address",
                                value: user.email
                            )

                            ProfileInfoCard(
                                icon: "person.fill",
                                iconColor: PokemonTheme.primaryBlue,
                                title: "Username",
                                value: user.username
                            )

                            ProfileInfoCard(
                                icon: "calendar",
                                iconColor: PokemonTheme.green,
                                title: "Member Since",
                                value: DateFormatter.longDate.string(from: user.createdAt)
                            )
                        }
                        .padding(.horizontal, 20)

                        PokemonButton(title: "Sign Out", style: .tertiary) {
                            databaseManager.logout()
                        }
                        .padding(.horizontal, 20)
                    } else {
                        VStack(spacing: 20) {
                            Image(systemName: "person.crop.circle.badge.exclamationmark")
                                .font(.system(size: 60))
                                .foregroundColor(PokemonTheme.textSecondary)

                            Text("No user logged in")
                                .font(.title2)
                                .foregroundColor(PokemonTheme.textSecondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .background(
                LinearGradient(
                    colors: [Color.white, PokemonTheme.lightBlue.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
    }
}
