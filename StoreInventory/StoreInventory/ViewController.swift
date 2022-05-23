//
//  ViewController.swift
//  StoreInventory
//
//  Created by Sanjit Shaw on 23/05/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var storeInventoryList: UITableView!
    @IBOutlet var orderSummaryBtn: UIButton!
    var customIndicator: ActivityLoader = ActivityLoader(typeOfIndicator: .eCustomLarge, displayMessage: "Loading....")
    var storedetailPresenter = StoreDetailPresenter()
    var productListPresenter = ProductListPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        orderSummaryBtn.isEnabled = false
        showIndicator()
        storedetailPresenter.fetchStoreDetail { [weak self] storeDetailObj in
            DispatchQueue.main.async {
                self?.customIndicator.removeIndicator()
                self?.storeInventoryList.reloadData()
                self?.pullProductList()
            }
        }
    }
    
    func pullProductList() {
        showIndicator()
        productListPresenter.fetchProductDetail { [weak self] list in
            DispatchQueue.main.async {
                self?.customIndicator.removeIndicator()
                self?.storeInventoryList.reloadData()
            }
        }
    }
    
    func showIndicator() {
        customIndicator.gradientColorSet = [UIColor(red: 255.0/255.0, green: 206.0/255.0, blue: 10.0/255.0, alpha: 1.0).cgColor, UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 120.0/255.0, alpha: 1.0).cgColor]
        customIndicator.showLoader(overView: view)
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? OrderSummaryViewController)?.selectedProducts = productListPresenter.selectedProducts
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") else {
            return UITableViewCell(style: .default, reuseIdentifier: "productCell")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let productCell = cell as? ProductElementCell, let categoryId = storedetailPresenter.getStoreInfo()?.storeDetail[indexPath.section].categoryid {
            let product = productListPresenter.getProductsInfo(categoryid: categoryId)[indexPath.row]
            productCell.delegate = self
            let value = productListPresenter.isProductSaved(prod: product)
            if value.0 == true {
                if let savedProduct = value.1 {
                    print(#function)
                    print("Product id \(savedProduct.id)-- Name \(savedProduct.name) -- quantity \(savedProduct.quantity)")
                    productCell.updateCell(productModel: savedProduct)
                } else {
                    productCell.updateCell(productModel: product)
                }
            } else {
                productCell.updateCell(productModel: product)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return storedetailPresenter.getStoreInfo()?.storeDetail.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let categoryId = storedetailPresenter.getStoreInfo()?.storeDetail[section].categoryid {
            return productListPresenter.getProductsInfo(categoryid: categoryId).count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title  = "  \(storedetailPresenter.getStoreInfo()?.storeDetail[section].categoryname ?? "--")"
        
        let lbl  = UILabel()
        lbl.text = title
        lbl.backgroundColor = .lightGray
        return lbl
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}

extension ViewController: ProductCellDelegate {
    func productQuantityDidUpdate(qty: String, for product: ProductListElement?, at cell: ProductElementCell) {
        cell.qtyLbl.text = "Qty: \(qty)"
        if let aproduct = product {
            productListPresenter.update(product: aproduct, with: Int(qty) ?? 0)
        }
        orderSummaryBtn.isEnabled = productListPresenter.selectedProducts.count > 0
    }
}
