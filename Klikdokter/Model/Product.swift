//
//  Product.swift
//  Klikdokter
//
//  Created by Hai Hoang on 24/02/2022.
//

import UIKit
import RxDataSources

class Product: Codable {
    var id: Int
    var sku: String
    var productName: String
    var qty: Int
    var price: Int
    var unit: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case sku
        case productName = "product_name"
        case qty
        case price
        case unit
    }
    
    init(addedProduct: AddedProduct) {
        self.id = addedProduct.id
        self.sku = addedProduct.sku
        self.productName = addedProduct.productName
        self.qty = Int(addedProduct.qty) ?? 0
        self.price = Int(addedProduct.price) ?? 0
        self.unit = addedProduct.unit
    }
}

class AddedProduct: Codable {
    var id: Int
    var sku: String
    var productName: String
    var qty: String
    var price: String
    var unit: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case sku
        case productName = "product_name"
        case qty
        case price
        case unit
    }
}

extension Product: IdentifiableType, Equatable {
    typealias Identity = Int

    var identity: Int {
        return id
    }
}

func == (lhs: Product, rhs: Product) -> Bool {
    return lhs.id == rhs.id && lhs.sku == rhs.sku && lhs.productName == rhs.productName
}

struct ProductSection {
    var header: String
    var items: [Item]
}

extension ProductSection: AnimatableSectionModelType {
    typealias Item = Product
    
    var identity: String {
        return header
    }
    
    init(original: ProductSection, items: [Item]) {
        self = original
        self.items = items
    }
}

class ProductErrorResponse: Codable {
    var success: Bool
    var message: String
}

