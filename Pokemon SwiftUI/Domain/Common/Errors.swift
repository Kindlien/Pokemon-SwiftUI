//
//  Errors.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

enum AuthError: Error, LocalizedError {
    case invalidInput
    case invalidEmail
    case passwordTooShort
    case userExists
    case usernameExists
    case emailExists
    case databaseError
    case invalidCredentials
    case emptyEmail
    case emptyPassword
    case emptyUsername
    case incorrectEmail
    case incorrectPassword

    var errorDescription: String? {
        switch self {
        case .invalidInput: return "Please fill in all fields"
        case .invalidEmail: return "Please enter a valid email address"
        case .passwordTooShort: return "Password must be at least 6 characters"
        case .userExists: return "An account with this email already exists"
        case .usernameExists: return "This username is already taken"
        case .emailExists: return "An account with this email already exists"
        case .databaseError: return "Something went wrong. Please try again"
        case .invalidCredentials: return "Invalid email or password"
        case .emptyEmail: return "Please enter your email address"
        case .emptyPassword: return "Please enter your password"
        case .emptyUsername: return "Please enter a username"
        case .incorrectEmail: return "No account found with this email address"
        case .incorrectPassword: return "Incorrect password"
        }
    }
}

enum APIError: LocalizedError {
    case invalidResponse
    case pokemonNotFound
    case networkError

    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid server response"
        case .pokemonNotFound: return "Pokemon not found"
        case .networkError: return "Network connection error"
        }
    }
}
