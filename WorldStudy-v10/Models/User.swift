//
//  User.swift
//  Login
//
//  Created by 이다은 on 5/27/25.
//

import Foundation

struct User: Codable, Identifiable, Hashable, Equatable {
    let id: Int
    let email: String?
    let password: String?
    let name: String
    let role: String
}
