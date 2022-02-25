//
//  ProductViewModel.swift
//  Klikdokter
//
//  Created by Hai Hoang on 24/02/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ProductViewModel: BaseViewModel {
    
    var sections = BehaviorRelay<[ProductSection]>(value: [])
    var searchText = BehaviorRelay<String>(value: "")
    
    var originalProductList: [Product] = []
    var displayedProductList: [Product] = []

    func getProductList() {
        isLoadingValue.accept(true)
        
        _ = NetworkService().request(ProductRequest.getProductList, completion: { [weak self] response in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingValue.accept(false)
            guard let statusCode = response?.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                do {
                    let productListResponse = try JSONDecoder().decode([Product].self, from: (response?.data)!)
                    strongSelf.originalProductList = productListResponse
                    strongSelf.applyFiltering()
                    
                } catch {
                    print("Format fail")
                }
            case 400:
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self , from: (response?.data)!)
                    strongSelf.errorMessage.accept(errorResponse.error)
                    if errorResponse.error.lowercased().contains("token") {
                        currentLoggedInToken.accept("")
                    }
                } catch let errorText {
                    print(errorText)
                }
            default:
                print("Cannot load product list. Something is wrong")
            }
        })
    }
    
    func addProduct(_ sku: String, productName: String, quantity: Int, price: Int, unit: String, completion: @escaping(_ status: Bool) -> Void) {
        isLoadingValue.accept(true)
        
        _ = NetworkService().request(ProductRequest.addProduct(sku, productName, quantity, price, unit), completion: { [weak self] response in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingValue.accept(false)
            
            guard let statusCode = response?.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                do {
                    let product = try JSONDecoder().decode(Product.self, from: (response?.data)!)
                    strongSelf.originalProductList.append(product)
                    strongSelf.applyFiltering()
                    completion(true)
                } catch {
                    do {
                        let errorResponse = try JSONDecoder().decode(ProductErrorResponse.self, from: (response?.data)!)
                        strongSelf.errorMessage.accept(errorResponse.message)
                    } catch {
                        
                    }
                    completion(false)
                }
            case 400:
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self , from: (response?.data)!)
                    strongSelf.errorMessage.accept(errorResponse.error)
                    if errorResponse.error.lowercased().contains("token") {
                        currentLoggedInToken.accept("")
                    }
                    completion(false)
                } catch let errorText {
                    print(errorText)
                    completion(false)
                }
                
            default:
                completion(false)
            }
        })
    }
    
    func editProduct(_ sku: String, productName: String, quantity: Int, price: Int, unit: String, completion: @escaping(_ status: Bool) -> Void) {
        isLoadingValue.accept(true)
        
        _ = NetworkService().request(ProductRequest.editProduct(sku, productName, quantity, price, unit), completion: { [weak self] response in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingValue.accept(false)
            
            guard let statusCode = response?.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                do {
                    let product = try JSONDecoder().decode(Product.self, from: (response?.data)!)
                    for (index, checkProduct) in strongSelf.originalProductList.enumerated() {
                        if checkProduct.id == product.id {
                            strongSelf.originalProductList[index] = product
                            break
                        }
                    }
                    strongSelf.applyFiltering()
                    completion(true)
                } catch let errorText {
                    print(errorText)
                    do {
                        let errorResponse = try JSONDecoder().decode(ProductErrorResponse.self, from: (response?.data)!)
                        strongSelf.errorMessage.accept(errorResponse.message)
                    } catch {
                        
                    }
                    completion(false)
                }
            case 400:
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self , from: (response?.data)!)
                    strongSelf.errorMessage.accept(errorResponse.error)
                    if errorResponse.error.lowercased().contains("token") {
                        currentLoggedInToken.accept("")
                    }
                    completion(false)
                } catch let errorText {
                    print(errorText)
                    completion(false)
                }
                
            default:
                completion(false)
            }
        })
    }
    
    func deleteProduct(_ sku: String) {
        isLoadingValue.accept(true)
        
        _ = NetworkService().request(ProductRequest.deleteProduct(sku), completion: { [weak self] response in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingValue.accept(false)
            
            guard let statusCode = response?.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                do {
                    let product = try JSONDecoder().decode(Product.self, from: (response?.data)!)
                    for (index, checkProduct) in strongSelf.originalProductList.enumerated() {
                        if checkProduct.id == product.id {
                            strongSelf.originalProductList.remove(at: index)
                            break
                        }
                    }
                    strongSelf.applyFiltering()
                } catch {
                    do {
                        let errorResponse = try JSONDecoder().decode(ProductErrorResponse.self, from: (response?.data)!)
                        strongSelf.errorMessage.accept(errorResponse.message)
                    } catch {
                        
                    }
                }
            case 400:
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self , from: (response?.data)!)
                    strongSelf.errorMessage.accept(errorResponse.error)
                    if errorResponse.error.lowercased().contains("token") {
                        currentLoggedInToken.accept("")
                    }
                } catch  {
                }
                
            default:
                break
            }
        })
    }
    
    func deleteRowAtIndex(_ index: Int) {
        let deletedItem = displayedProductList[index]
        deleteProduct(deletedItem.sku)
    }
    
    func applyFiltering() {
        if searchText.value.isEmpty {
            // Load all
            self.displayedProductList = originalProductList
        } else {
            // Filter
            self.displayedProductList = originalProductList.filter({ product in
                return product.sku.lowercased().contains(self.searchText.value.lowercased())
            })
        }
        
        self.sections.accept([
            ProductSection(header: "", items: self.displayedProductList)
        ])
    }
}
