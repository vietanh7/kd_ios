//
//  LoginViewController.swift
//  Klikdokter
//
//  Created by Hai Hoang on 24/02/2022.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mainBtn: UIButton!
    
    var forRegister = false
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if forRegister {
            mainBtn.setTitle("Register", for: .normal)
        } else {
            mainBtn.setTitle("Login", for: .normal)
        }
        
        setupObservers()
    }
    
    private func setupObservers() {
        viewModel.isLoadingValue.distinctUntilChanged().subscribe(onNext: { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.showLoadingValue(isLoading)
            }
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.subscribe(onNext: { [weak self] errorMessage in
            if errorMessage != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self?.showAlert("Error", message: errorMessage!)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    @IBAction func tapMainBtn(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        guard !email.isEmpty && !password.isEmpty else {
            return
        }
        
        if forRegister {
            viewModel.registerWithEmailAndPassword(email, password: password) { [weak self] status in
                if status {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            viewModel.loginWithEmailAndPassword(email, password: password) { [weak self] status in
                if status {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}
