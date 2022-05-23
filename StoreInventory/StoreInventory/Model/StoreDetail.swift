//
//  StoreDetail.swift
//  StoreInventory
//


import Foundation
//   let storeDetail = try? newJSONDecoder().decode(StoreDetail.self, from: jsonData)

import Foundation

// MARK: - StoreDetail
class StoreDetail: Codable {
    let storeDetail: [StoreDetailElement]

    init(storeDetail: [StoreDetailElement]) {
        self.storeDetail = storeDetail
    }
}

// MARK: - StoreDetailElement
class StoreDetailElement: Codable {
    let categoryname, categoryid: String

    init(categoryname: String, categoryid: String) {
        self.categoryname = categoryname
        self.categoryid = categoryid
    }
}
