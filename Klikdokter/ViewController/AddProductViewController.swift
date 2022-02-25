//
//  AddProductViewController.swift
//  Klikdokter
//
//  Created by Hai Hoang on 25/02/2022.
//

import UIKit
import RxSwift
import RxCocoa

class AddProductViewController: UIViewController {

    @IBOutlet weak var skuTextField: UITextField!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    
    let disposeBag = DisposeBag()
    
    // Passed params
    var existingProduct: Product?
    var productViewModel: ProductViewModel!
    // End passed params
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupObservers()
        setupView()
    }
    
    private func setupObservers() {
        productViewModel.isLoadingValue.distinctUntilChanged().subscribe(onNext: { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.showLoadingValue(isLoading)
            }
        }).disposed(by: disposeBag)
        
        productViewModel.errorMessage.subscribe(onNext: { [weak self] errorMessage in
            if errorMessage != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self?.showAlert("Error", message: errorMessage!)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupView() {
        if let existingProduct = existingProduct {
            skuTextField.text = existingProduct.sku
            productNameTextField.text = existingProduct.productName
            quantityTextField.text = String(existingProduct.qty)
            priceTextField.text = String(existingProduct.price)
            unitTextField.text = existingProduct.unit
            skuTextField.isUserInteractionEnabled = false
            skuTextField.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func tapSubmitBtn(_ sender: Any) {
        self.view.endEditing(true)
        guard validate() else {
            return
        }
        
        guard let quantity = Int(quantityTextField.text!), let price = Int(priceTextField.text!) else {
            return
        }
        
        if existingProduct != nil {
            productViewModel.editProduct(skuTextField.text!, productName: productNameTextField.text!, quantity: quantity, price: price, unit: unitTextField.text!) { [weak self] status in
                if status {
                    DispatchQueue.main.async {
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            productViewModel.addProduct(skuTextField.text!, productName: productNameTextField.text!, quantity: quantity, price: price, unit: unitTextField.text!) { [weak self] status in
                if status {
                    DispatchQueue.main.async {
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func validate() -> Bool {
        if skuTextField.text!.isEmpty {
            showAlert("Error", message: "Please input SKU")
            return false
        }
        
        if productNameTextField.text!.isEmpty {
            showAlert("Error", message: "Please input Product Name")
            return false
        }
        
        if quantityTextField.text!.isEmpty, let _ = Int(quantityTextField.text!) {
            showAlert("Error", message: "Please input Quantity")
            return false
        }
        
        if priceTextField.text!.isEmpty, let _ = Int(priceTextField.text!) {
            showAlert("Error", message: "Please input Price")
            return false
        }
        
        if unitTextField.text!.isEmpty {
            showAlert("Error", message: "Please input Unit")
            return false
        }
        
        return true
    }
    
}
