//
//  OrderList.swift
//  StoreInventory
//
//  Created by Sanjit Shaw on 24/05/22.
//

import Foundation

// MARK: - OrderList
class OrderList: Codable {
    let Product_List: [Product_List]
    let deliveryAddress, totalamount: String

    enum CodingKeys: String, CodingKey {
        case Product_List = "Product_List"
        case deliveryAddress, totalamount
    }

    init(Product_List: [Product_List], deliveryAddress: String, totalamount: String) {
        self.Product_List = Product_List
        self.deliveryAddress = deliveryAddress
        self.totalamount = totalamount
    }
}

// MARK: - Product_List
class Product_List: Codable {
    let name, id, categoryid: String
    let price: Product_Price
    let quantity: Int

    init(name: String, id: String, categoryid: String, price: Product_Price, quantity: Int) {
        self.name = name
        self.id = id
        self.categoryid = categoryid
        self.price = price
        self.quantity = quantity
    }
}

enum Product_Price: String, Codable {
    case the10000 = "₹100.00"
    case the2000 = "₹20.00"
    case the20000 = "₹200.00"
    case the3000 = "₹30.00"
}
