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
    @FocusState private var focusedField: Field?

    enum Field: CaseIterable {
        case username, email, password
    }

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
                                .focused($focusedField, equals: .username)
                                .onSubmit {
                                    focusedField = .email
                                }
                        }

                        PokemonTextField("Email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .focused($focusedField, equals: .email)
                            .onSubmit {
                                focusedField = .password
                            }

                        PokemonTextField("Password", text: $viewModel.password, isSecure: true)
                            .focused($focusedField, equals: .password)
                            .onSubmit {
                                if isRegistering {
                                    viewModel.register()
                                } else {
                                    viewModel.login()
                                }
                            }
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

                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isRegistering.toggle()
                            viewModel.errorMessage = ""
                            focusedField = nil
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
            .onTapGesture {
                focusedField = nil
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
    }
}
