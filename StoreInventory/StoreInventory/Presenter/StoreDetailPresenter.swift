//
//  StoreDetailPresenter.swift
//  StoreInventory
//
//  Created by Sanjit Shaw on 23/05/22.
//

import Foundation

class StoreDetailPresenter {
    
    private var store_detail: StoreDetail? = nil
    
    
    func fetchStoreDetail(completionHandler: @escaping (StoreDetail) -> Void) {
        do {
            if let filePath = Bundle.main.path(forResource: "storeDetail", ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let jsonData = try Data(contentsOf: fileUrl)
                let decoder = JSONDecoder()
                let storeDetail = try decoder.decode(StoreDetail.self, from: jsonData)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.store_detail = storeDetail
                    completionHandler(storeDetail)
                }
            }
        } catch {
                print("error: \(error)")
        }
    }
    
    func getStoreInfo() -> StoreDetail? {
        return store_detail
    }
    
    
    
}
