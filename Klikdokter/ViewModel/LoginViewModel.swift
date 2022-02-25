//
//  LoginViewModel.swift
//  Klikdokter
//
//  Created by Hai Hoang on 24/02/2022.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewModel: BaseViewModel {
    
    func loginWithEmailAndPassword(_ email: String, password: String, completion: @escaping(_ status: Bool) -> Void) {
        isLoadingValue.accept(true)
        
        _ = NetworkService().request(UserRequest.login(email, password), completion: { [weak self] response in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingValue.accept(false)
            guard let statusCode = response?.response?.statusCode else {
                completion(false)
                return
            }
            
            switch statusCode {
            case 200:
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self , from: (response?.data)!)
                    currentLoggedInToken.accept(loginResponse.token)
                    completion(true)
                } catch {
                    completion(false)
                }
                
            case 400:
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self , from: (response?.data)!)
                    strongSelf.errorMessage.accept(errorResponse.error)
                    completion(false)
                } catch let errorText {
                    print(errorText)
                    completion(false)
                }
            case 422:
                strongSelf.errorMessage.accept("Something is wrong")
                completion(false)
            default:
                completion(false)
            }
        })
    }
    
    func registerWithEmailAndPassword(_ email: String, password: String, completion: @escaping(_ status: Bool) -> Void) {
        isLoadingValue.accept(true)
        
        _ = NetworkService().request(UserRequest.register(email, password), completion: { [weak self] response in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingValue.accept(false)
            guard let statusCode = response?.response?.statusCode else {
                completion(false)
                return
            }
            
            switch statusCode {
            case 200:
                do {
                    let registerResponse = try JSONDecoder().decode(RegisterUserResponse.self , from: (response?.data)!)
                    if registerResponse.success {
                        // Automatically login user after register successfully
                        strongSelf.loginWithEmailAndPassword(email, password: password, completion: completion)
                    } else {
                        strongSelf.errorMessage.accept(registerResponse.message)
                        completion(false)
                    }
                } catch {
                    completion(false)
                }
            case 400:
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self , from: (response?.data)!)
                    strongSelf.errorMessage.accept(errorResponse.error)
                    completion(false)
                } catch {
                    completion(false)
                }
            case 422:
                strongSelf.errorMessage.accept("Something is wrong")
                completion(false)
            default:
                completion(false)
                
            }
        })
    }
}
