//
//  OrderSummaryViewController.swift
//  StoreInventory
//
//  Created by Sanjit Shaw on 23/05/22.
//

import UIKit

class OrderSummaryViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var ordersummaryTable: UITableView!
    @IBOutlet var addresstxtbox: UITextView!
    @IBOutlet var amtLbl: UILabel!
    @IBOutlet var placeOrderBtn: UIButton!
    
    var selectedProducts: [ProductListElement]? = nil
    lazy var orderSummaryPresenter = OrderSummaryPresenter(addedProducts: selectedProducts)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUIElement()
        placeOrderBtn.isEnabled = false
        addresstxtbox.layer.borderColor = UIColor.black.cgColor
        addresstxtbox.layer.borderWidth = 1.0
        scrollView.contentSize = CGSize(width: 0.0, height: 1640.0)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupUIElement() {
        amtLbl.text = "Total Amount: ₹ \(orderSummaryPresenter.getTotalAmount())"
    }
    
    @IBAction func didtapPlaceOrder(_ sender: UIButton) {
        orderSummaryPresenter.prepareOrderedList(deliveryAddress: addresstxtbox.text)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
    }
    
    @objc func dismisskeyboard() {
        placeOrderBtn.isEnabled = addresstxtbox.text.count > 0
        addresstxtbox.resignFirstResponder()
        
    }

}

extension OrderSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedProducts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") else {
            return UITableViewCell(style: .default, reuseIdentifier: "productCell")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let productCell = cell as? ProductElementCell, let productlist = selectedProducts {
            let product = productlist[indexPath.row]
            productCell.updateCell(productModel: product)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension OrderSummaryViewController: UIScrollViewDelegate {
    
}

extension OrderSummaryViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let toolBar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismisskeyboard))]
        toolBar.sizeToFit()
        textView.inputAccessoryView = toolBar
        
        return true
    }
}
