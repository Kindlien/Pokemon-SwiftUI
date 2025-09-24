//
//  AuthViewModel.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import Combine
import SwiftUI
import RxSwift

class AuthViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage = ""

    private let databaseManager: CouchbaseManager
    private let hudManager = HUDManager()
    private let disposeBag = DisposeBag()

    init(databaseManager: CouchbaseManager) {
        self.databaseManager = databaseManager
    }

    func register() {
        guard !isLoading else { return }

        setLoading(true, message: "Creating Account...")
        errorMessage = ""

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            let result = self.databaseManager.register(
                username: self.username,
                email: self.email,
                password: self.password
            )

            DispatchQueue.main.async {
                self.setLoading(false)

                switch result {
                case .success:
                    self.clearFields()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func login() {
        guard !isLoading else { return }

        setLoading(true, message: "Signing In...")
        errorMessage = ""

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            let result = self.databaseManager.login(email: self.email, password: self.password)

            DispatchQueue.main.async {
                self.setLoading(false)

                switch result {
                case .success:
                    self.clearFields()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func setLoading(_ loading: Bool, message: String = "") {
        isLoading = loading

        if loading {
            hudManager.show(message)
        } else {
            hudManager.hide()
        }
    }

    private func clearFields() {
        username = ""
        email = ""
        password = ""
        errorMessage = ""
    }
}
