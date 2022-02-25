//
//  User.swift
//  Klikdokter
//
//  Created by Hai Hoang on 24/02/2022.
//

import Foundation

class User: Codable {
    var email: String
    var id: Int
}

class RegisterUserResponse: Codable {
    var success: Bool
    var message: String
    var data: User
}

class LoginResponse: Codable {
    var token: String
}

class ErrorResponse: Codable {
    var error: String
}
