//
//  OrderSummaryPresenter.swift
//  StoreInventory
//
//  Created by Sanjit Shaw on 23/05/22.
//

import Foundation

class OrderSummaryPresenter {
    var savedProducts: [ProductListElement]? = nil
    var ordered_list: OrderList? = nil
    
    required init(addedProducts: [ProductListElement]?) {
        savedProducts = addedProducts
    }
    
    func getTotalAmount() -> String {
        var totalmt = 0.0
        if let productList = savedProducts {
            for item in productList {
                if let doublePrice = Double(item.price.rawValue.replacingOccurrences(of: "₹", with: "")) {
                    totalmt += Double(item.quantity) * doublePrice
                }
            }
        }
        return String(format: "%.2f", totalmt)
    }
    
    func prepareOrderedList(deliveryAddress: String) {
        if let product_List = savedProducts {
            let mappedList = product_List.map { item in
                return Product_List(name: item.name, id: item.id, categoryid: item.categoryid, price: Product_Price(rawValue: item.price.rawValue) ?? .the10000, quantity: item.quantity)
            }
            ordered_list = OrderList(Product_List: mappedList, deliveryAddress: deliveryAddress, totalamount: getTotalAmount())
            saveOrderListJson()
        }
        
    }
    
    func getDocumentsDirectoryUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func saveOrderListJson() {
        let filePath = self.getDocumentsDirectoryUrl().appendingPathComponent("PlacedOrder.json")
        print(filePath)
        do {
            let jsonData = try JSONEncoder().encode(ordered_list)
            try jsonData.write(to: filePath)
        } catch {
            print(error)
        }
    }
}
