//
//  User.swift
//  Pokemon SwiftUI
//
//  Created by William Kindlien Gunawan on 24/09/25.
//

import SwiftUI

struct User: Codable, Identifiable {
    let id = UUID()
    let username: String
    let email: String
    let password: String
    let createdAt: Date
}
