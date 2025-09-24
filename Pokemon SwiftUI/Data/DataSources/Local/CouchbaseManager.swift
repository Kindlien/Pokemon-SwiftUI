//
//  CouchbaseManager.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import Combine
import CouchbaseLiteSwift

// MARK: - Couchbase Database Manager
class CouchbaseManager: ObservableObject {
    private var database: Database?
    private let databaseName = "pokemon_app"
    private let databaseQueue = DispatchQueue(label: "com.pokemonapp.database", qos: .utility)

    @Published var currentUser: User?
    @Published var isLoggedIn = false

    init() {
        databaseQueue.async { [weak self] in
            self?.setupDatabase()
            DispatchQueue.main.async {
                self?.loadCurrentUser()
            }
        }
    }

    private func setupDatabase() {
        do {
            let config = DatabaseConfiguration()
            database = try Database(name: databaseName, config: config)
        } catch {
            print("Error setting up Couchbase database: \(error)")
        }
    }

    // MARK: - User Management
    func register(username: String, email: String, password: String) -> AppResult<User, AuthError> {
        if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .failure(.emptyUsername)
        }

        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .failure(.emptyEmail)
        }

        if password.isEmpty {
            return .failure(.emptyPassword)
        }

        guard isValidEmail(email) else {
            return .failure(.invalidEmail)
        }

        guard password.count >= 6 else {
            return .failure(.passwordTooShort)
        }

        if usernameExists(username: username) {
            return .failure(.usernameExists)
        }

        if userExists(email: email) {
            return .failure(.emailExists)
        }

        let newUser = User(username: username, email: email, password: password, createdAt: Date())

        do {
            let userDoc = MutableDocument(id: "user::\(newUser.email)")
            userDoc.setString(newUser.username, forKey: "username")
            userDoc.setString(newUser.email, forKey: "email")
            userDoc.setString(newUser.password, forKey: "password")
            userDoc.setDate(newUser.createdAt, forKey: "createdAt")

            try database?.saveDocument(userDoc)
            return .success(newUser)
        } catch {
            return .failure(.databaseError)
        }
    }

    func login(email: String, password: String) -> AppResult<User, AuthError> {
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .failure(.emptyEmail)
        }

        if password.isEmpty {
            return .failure(.emptyPassword)
        }

        do {
            guard let userDoc = database?.document(withID: "user::\(email)") else {
                return .failure(.incorrectEmail)
            }

            guard let storedPassword = userDoc.string(forKey: "password"),
                  storedPassword == password else {
                return .failure(.incorrectPassword)
            }

            guard let username = userDoc.string(forKey: "username"),
                  let createdAt = userDoc.date(forKey: "createdAt") else {
                return .failure(.databaseError)
            }

            let user = User(username: username, email: email, password: password, createdAt: createdAt)
            currentUser = user
            isLoggedIn = true
            saveCurrentUser(user)
            return .success(user)

        } catch {
            print("Login error: \(error)")
            return .failure(.databaseError)
        }
    }

    func logout() {
        currentUser = nil
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "CurrentUser")
    }

    private func userExists(email: String) -> Bool {
        return database?.document(withID: "user::\(email)") != nil
    }

    private func usernameExists(username: String) -> Bool {
        do {
            let query = QueryBuilder
                .select(SelectResult.all())
                .from(DataSource.database(database!))
                .where(Meta.id.like(Expression.string("user::%"))
                    .and(Expression.property("username").equalTo(Expression.string(username))))

            let result = try query.execute()
            return result.allResults().count > 0
        } catch {
            print("Error checking username existence: \(error)")
            return false
        }
    }

    private func saveCurrentUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: "CurrentUser")
        }
    }

    private func loadCurrentUser() {
        guard let data = UserDefaults.standard.data(forKey: "CurrentUser"),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return
        }
        currentUser = user
        isLoggedIn = true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func cachePokemon(_ pokemon: [Pokemon]) {
        do {
            for poke in pokemon {
                let doc = MutableDocument(id: "pokemon::\(poke.id)")
                doc.setInt(Int(poke.id), forKey: "id")
                doc.setString(poke.name, forKey: "name")
                doc.setString(poke.url ?? "", forKey: "url")
                doc.setDate(Date(), forKey: "cachedAt")

                try database?.saveDocument(doc)
            }
        } catch {
            print("Error caching pokemon: \(error)")
        }
    }

    func getCachedPokemon() -> [Pokemon] {
        do {
            let query = QueryBuilder
                .select(SelectResult.all())
                .from(DataSource.database(database!))
                .where(Meta.id.like(Expression.string("pokemon::%")))

            let result = try query.execute()
            var pokemon: [Pokemon] = []

            for row in result {
                if let dict = row.toDictionary()[databaseName] as? [String: Any],
                   let id = dict["id"] as? Int64,
                   let name = dict["name"] as? String,
                   let url = dict["url"] as? String {
                    pokemon.append(Pokemon(id: Int(id), name: name, url: url))
                }
            }

            return pokemon.sorted { $0.id < $1.id }
        } catch {
            print("Error getting cached pokemon: \(error)")
            return []
        }
    }

    func cachePokemonDetail(_ detail: PokemonDetail) {
        do {
            let doc = MutableDocument(id: "pokemon_detail::\(detail.id)")
            doc.setInt(Int(detail.id), forKey: "id")
            doc.setString(detail.name, forKey: "name")
            doc.setInt(Int(detail.height ?? 0), forKey: "height")
            doc.setInt(Int(detail.weight ?? 0), forKey: "weight")

            if let abilitiesData = try? JSONEncoder().encode(detail.abilities) {
                doc.setString(String(data: abilitiesData, encoding: .utf8) ?? "", forKey: "abilities")
            }

            if let typesData = try? JSONEncoder().encode(detail.types ?? []) {
                doc.setString(String(data: typesData, encoding: .utf8) ?? "", forKey: "types")
            }

            doc.setString(detail.sprites?.frontDefault ?? "", forKey: "imageURL")
            doc.setDate(Date(), forKey: "cachedAt")

            try database?.saveDocument(doc)
        } catch {
            print("Error caching pokemon detail: \(error)")
        }
    }

    func getCachedPokemonDetail(id: Int) -> PokemonDetail? {
        do {
            if let doc = database?.document(withID: "pokemon_detail::\(id)"),
               let pokemonId = doc.value(forKey: "id") as? Int64,
               let name = doc.string(forKey: "name") {

                let height = doc.value(forKey: "height") as? Int64
                let weight = doc.value(forKey: "weight") as? Int64
                let imageURL = doc.string(forKey: "imageURL") ?? ""
                let abilitiesJSON = doc.string(forKey: "abilities") ?? ""
                let typesJSON = doc.string(forKey: "types") ?? ""

                var abilities: [PokemonDetail.AbilityWrapper] = []
                if let abilitiesData = abilitiesJSON.data(using: .utf8) {
                    abilities = (try? JSONDecoder().decode([PokemonDetail.AbilityWrapper].self, from: abilitiesData)) ?? []
                }

                var types: [PokemonDetail.TypeWrapper] = []
                if let typesData = typesJSON.data(using: .utf8) {
                    types = (try? JSONDecoder().decode([PokemonDetail.TypeWrapper].self, from: typesData)) ?? []
                }

                let sprites = PokemonDetail.Sprites(frontDefault: imageURL.isEmpty ? nil : imageURL, frontShiny: nil)

                return PokemonDetail(
                    id: Int(pokemonId),
                    name: name,
                    height: height != nil ? Int(height!) : nil,
                    weight: weight != nil ? Int(weight!) : nil,
                    abilities: abilities,
                    sprites: sprites,
                    types: types
                )
            }
        } catch {
            print("Error getting cached pokemon detail: \(error)")
        }

        return nil
    }
}
