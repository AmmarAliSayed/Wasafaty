//
//  RecipeCollectionViewCell.swift
//  Wasafaty
//
//  Created by Macbook on 09/10/2021.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //before selection
        titleLabel.alpha = 0.6
    }
    
    func setupCell(text: String) {
        titleLabel.text = text
    }
    
    override var isSelected: Bool {
        didSet{
            ////in  selection make titleLabel.alpha = 1
            titleLabel.alpha = isSelected ? 1.0 : 0.6
        }
    }
}
