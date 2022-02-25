//
//  ProductTableViewCell.swift
//  Klikdokter
//
//  Created by Hai Hoang on 24/02/2022.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var product: Product!
    weak var viewController: ProductViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWithProduct(_ product: Product, isLoggedIn: Bool) {
        self.product = product
        self.skuLabel.text = product.sku
        self.productNameLabel.text = product.productName
        
        self.editBtn.setBtnEnabled(isLoggedIn)
        self.deleteBtn.setBtnEnabled(isLoggedIn)
    }
    
    @IBAction func tapDeleteBtn(_ sender: Any) {
        viewController?.deleteRowAtCell(self)
    }
    
    @IBAction func tapEditBtn(_ sender: Any) {
        viewController?.editRowAtCell(self)
    }
}
