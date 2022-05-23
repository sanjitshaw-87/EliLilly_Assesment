//
//  StoreInventoryTests.swift
//  StoreInventoryTests
//
//  Created by Sanjit Shaw on 23/05/22.
//

import XCTest
@testable import StoreInventory

class StoreInventoryTests: XCTestCase {
    var storedetailPresenter = StoreDetailPresenter()
    var productListPresenter = ProductListPresenter()
    var orderSummaryPresenter: OrderSummaryPresenter? = nil

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storedetailPresenter.fetchStoreDetail { item in
            
        }
        productListPresenter.fetchProductDetail { item in
            
        }
        orderSummaryPresenter = OrderSummaryPresenter(addedProducts: productListPresenter.selectedProducts)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func teststoredetil() {
        XCTAssertNotNil(storedetailPresenter)
        XCTAssertNil(storedetailPresenter.getStoreInfo())
        let exp = expectation(description: "fetchStore")
        storedetailPresenter.fetchStoreDetail { item in
            exp.fulfill()
            XCTAssertNotNil(self.storedetailPresenter.getStoreInfo())
        }
        wait(for: [exp], timeout: 7)
    }
    
    func testProductListPresenter() {
        XCTAssertNotNil(productListPresenter)
        XCTAssertNil(productListPresenter.getProductsInfo())
        let exp = expectation(description: "fetchProd")
        productListPresenter.fetchProductDetail { item in
            exp.fulfill()
            XCTAssertNotNil(self.productListPresenter.getProductsInfo())
        }
        wait(for: [exp], timeout: 7)
        print(productListPresenter.getProductsInfo(categoryid:"1"))
        XCTAssertNotNil(productListPresenter.getProductsInfo(categoryid:"1"))
        productListPresenter.update(product: ProductListElement(name: "aaa", id: "1", categoryid: "1", price: .the10000, quantity: 1), with: 2)
        XCTAssertTrue(productListPresenter.isProductSaved(prod: ProductListElement(name: "aaa", id: "1", categoryid: "1", price: .the10000, quantity: 1)).0)
        XCTAssertFalse(productListPresenter.isProductSaved(prod: ProductListElement(name: "aaa", id: "1", categoryid: "10", price: .the2000, quantity: 1)).0)
        XCTAssertNotNil(productListPresenter.isProductSaved(prod: ProductListElement(name: "aaa", id: "1", categoryid: "1", price: .the10000, quantity: 1)).1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
