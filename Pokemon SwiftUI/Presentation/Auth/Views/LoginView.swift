//
//  LoginView.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: AuthViewModel
    @State private var isRegistering = false

    init(databaseManager: CouchbaseManager) {
        self._viewModel = StateObject(wrappedValue: AuthViewModel(databaseManager: databaseManager))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: isRegistering ? 24 : 32) {

                    AuthHeaderView(isRegistering: isRegistering)

                    VStack(spacing: 20) {
                        if isRegistering {
                            PokemonTextField("Username", text: $viewModel.username)
                        }

                        PokemonTextField("Email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)

                        PokemonTextField("Password", text: $viewModel.password, isSecure: true)
                    }

                    PokemonButton(
                        title: isRegistering ? "Create Account" : "Sign In",
                        isLoading: viewModel.isLoading
                    ) {
                        if isRegistering {
                            viewModel.register()
                        } else {
                            viewModel.login()
                        }
                    }

                    // Toggle Mode
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isRegistering.toggle()
                            viewModel.errorMessage = ""
                        }
                    } label: {
                        HStack {
                            Text(isRegistering ? "Already have an account?" : "Don't have an account?")
                                .foregroundColor(PokemonTheme.textSecondary)
                            Text(isRegistering ? "Sign In" : "Sign Up")
                                .foregroundColor(PokemonTheme.primaryBlue)
                                .fontWeight(.medium)
                        }
                    }

                    if !viewModel.errorMessage.isEmpty {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(PokemonTheme.red)
                            Text(viewModel.errorMessage)
                                .foregroundColor(PokemonTheme.red)
                                .font(.caption)
                        }
                        .padding()
                        .background(PokemonTheme.red.opacity(0.1))
                        .cornerRadius(8)
                    }

                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 24)
            }
            .background(
                LinearGradient(
                    colors: [Color.white, PokemonTheme.lightBlue.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationBarHidden(true)
        }
    }
}
