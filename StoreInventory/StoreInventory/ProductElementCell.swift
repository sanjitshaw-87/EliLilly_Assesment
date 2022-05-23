//
//  ProductElementCell.swift
//  StoreInventory
//
//  Created by Sanjit Shaw on 23/05/22.
//

import UIKit

protocol ProductCellDelegate: AnyObject {
    func productQuantityDidUpdate(qty: String, for product: ProductListElement?, at cell: ProductElementCell)
}

class ProductElementCell: UITableViewCell {
    @IBOutlet var productThumbimage: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var subtitleLbl: UILabel!
    @IBOutlet var qtyStepper: UIStepper!
    @IBOutlet var qtyLbl: UILabel!
    
    private var product: ProductListElement? = nil
    
    weak var delegate: ProductCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(productModel: ProductListElement) {
        product = productModel
        
        self.titleLbl.text = product?.name
        self.subtitleLbl.text = product?.price.rawValue
        self.qtyLbl.text = "Qty: \(productModel.quantity)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        if let aDelegate = delegate {
            aDelegate.productQuantityDidUpdate(qty: String(format: "%.0f", sender.value), for: product, at: self)
        }
    }
    
}
