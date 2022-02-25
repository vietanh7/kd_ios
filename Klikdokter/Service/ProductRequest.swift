//
//  ProductRequest.swift
//  Klikdokter
//
//  Created by Hai Hoang on 24/02/2022.
//

import Foundation
import Alamofire

enum ProductRequest {
    case getProductList
    case addProduct(_ sku: String, _ productName: String, _ quantity: Int, _ price: Int, _ unit: String)
    case editProduct(_ sku: String, _ productName: String, _ quantity: Int, _ price: Int, _ unit: String)
    case deleteProduct(_ sku: String)
}

extension ProductRequest: Endpoint {
    var baseUrl: String {
        return Constants.Endpoint.BaseUrl
    }
    
    var path: String {
        switch self {
        case .getProductList:
            return "items"
        case .addProduct:
            return "item/add"
        case .editProduct:
            return "item/update"
        case .deleteProduct:
            return "item/delete"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProductList:
            return .get
        case .addProduct, .editProduct, .deleteProduct:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getProductList:
            return [
                "Content-Type": "application/json"
            ]
        default:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer " + currentLoggedInToken.value
            ]
        }
    }
    
    var body: Parameters {
        var returnedBody: Parameters = Parameters()
        switch self {
        case .addProduct(let sku, let productName, let quantity, let price, let unit):
            returnedBody = [
                "sku": sku,
                "product_name": productName,
                "qty": quantity,
                "price": price,
                "unit": unit,
                "status": 1
            ]
        case .editProduct(let sku, let productName, let quantity, let price, let unit):
            returnedBody = [
                "sku": sku,
                "product_name": productName,
                "qty": quantity,
                "price": price,
                "unit": unit,
                "status": 1
            ]
        case .deleteProduct(let sku):
            returnedBody = [
                "sku": sku
            ]
        default:
            break
        }
        return returnedBody
    }
}
