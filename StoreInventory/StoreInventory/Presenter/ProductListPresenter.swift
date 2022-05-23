//
//  ProductListPresenter.swift
//  StoreInventory
//
//  Created by Sanjit Shaw on 23/05/22.
//

import Foundation

class ProductListPresenter {
    private var product_List: ProductList? = nil
    var selectedProducts: [ProductListElement] = []
    
    func fetchProductDetail(completionHandler: @escaping (ProductList) -> Void) {
        do {
            if let filePath = Bundle.main.path(forResource: "Productlist", ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let jsonData = try Data(contentsOf: fileUrl)
                let decoder = JSONDecoder()
                let productInfo = try decoder.decode(ProductList.self, from: jsonData)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.product_List = productInfo
                    completionHandler(productInfo)
                }
            }
        } catch {
                print("error: \(error)")
        }
    }
    
    func getProductsInfo() -> ProductList? {
        return product_List
    }
    
    func getProductsInfo(categoryid: String) -> [ProductListElement] {
        return product_List?.productList.filter({ element in
            return element.categoryid == categoryid
        }) ?? []
    }
    
    func update(product: ProductListElement, with quantity: Int) {
        if let savedProduct = selectedProducts.filter({ element in
            return element.id == product.id && element.categoryid == product.categoryid
        }).first {
            if quantity == 0 {
                selectedProducts.removeAll { prod in
                    return prod.id == product.id && prod.categoryid == product.categoryid
                }
            } else {
                savedProduct.quantity = quantity
            }
        } else {
            let newProduct = ProductListElement(name: product.name, id: product.id, categoryid: product.categoryid, price: product.price, quantity: quantity)
            selectedProducts.append(newProduct)
        }
    }
    
    func isProductSaved(prod: ProductListElement) -> (Bool, ProductListElement?) {
        if selectedProducts.count > 0 {
            if let savedProduct = selectedProducts.filter({ element in
                return element.id == prod.id && element.categoryid == prod.categoryid
            }).first {
                return (true, savedProduct)
            }
        }
        return (false, nil)
    }
    
    
}
