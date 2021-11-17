//
//  BasketCollectionViewCell.swift

import UIKit

class BasketCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    //   @IBOutlet weak var blurView: UIVisualEffectView!
    
    var ingredientName: String?
    var ingredient: Ingredient?
    
    var delegate: BasketCellDelegate?
    var isDarkMode: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupViews()
    }
    
    // MARK: - Setup Views
    func setupViews() {
        //self.makeCircular()
        self.layer.cornerRadius = self.frame.size.width / 8
        self.layer.masksToBounds = true // Clips off anything overflowing edges
        
        //toggleDisplayMode()
    }
    
    
    /// Remove ingredient from basket
    @IBAction func removeFromBasket(_ sender: Any) {
        if let ingredient = ingredient {
            delegate?.didRemoveIngredient(ingredient: ingredient)
        }
    }
    
    
}
