//
//  ProductList.swift
//  StoreInventory
//
//  Created by Sanjit Shaw on 23/05/22.
//

import Foundation

// MARK: - ProductList
class ProductList: Codable {
    let productList: [ProductListElement]

    enum CodingKeys: String, CodingKey {
        case productList = "ProductList"
    }

    init(productList: [ProductListElement]) {
        self.productList = productList
    }
}

// MARK: - ProductListElement
class ProductListElement: Codable {
    let name, id, categoryid: String
    let price: Price
    var quantity: Int

    init(name: String, id: String, categoryid: String, price: Price, quantity: Int) {
        self.name = name
        self.id = id
        self.categoryid = categoryid
        self.price = price
        self.quantity = quantity
    }
}

enum Price: String, Codable {
    case the10000 = "₹100.00"
    case the2000 = "₹20.00"
    case the20000 = "₹200.00"
    case the3000 = "₹30.00"
}
