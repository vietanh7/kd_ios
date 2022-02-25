//
//  UserRequest.swift
//  Klikdokter
//
//  Created by Hai Hoang on 24/02/2022.
//

import Foundation
import Alamofire

enum UserRequest {
    case register(_ email: String, _ password: String)
    case login(_ email: String, _ password: String)
}

extension UserRequest: Endpoint {
    var baseUrl: String {
        return Constants.Endpoint.BaseUrl
    }
    
    var path: String {
        switch self {
        case .register:
            return "register"
        case .login:
            return "auth/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register, .login:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        return [:]
    }
    
    var body: Parameters {
        var returnedBody: Parameters = Parameters()
        switch self {
        case .register(let email, let password):
            returnedBody = [
                "email": email,
                "password": password
            ]
        case .login(let email, let password):
            returnedBody = [
                "email": email,
                "password": password
            ]
        }
        return returnedBody
    }
}
