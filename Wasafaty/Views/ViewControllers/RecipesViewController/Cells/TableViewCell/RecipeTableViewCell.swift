//
//  RecipeTableViewCell.swift
//  Wasafaty
//
//  Created by Macbook on 10/10/2021.
//

import UIKit
import SDWebImage
//protocol  RecipeCellDelegate: class {
//    func selectedRecipe(recipe: Recipe)
//}
class RecipeTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var recipeImageView: UIImageView!
    // @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    //weak var delegate: RecipeCellDelegate?
    
    var disabledHighlightedAnimation = false
    var originalContentViewFrame: CGRect = .zero
    override func awakeFromNib() {
        super.awakeFromNib()
        //  contentView.backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.1176470588, blue: 0.1450980392, alpha: 1)
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        containerView.layer.masksToBounds = true
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = contentView.frame.size.width / 30
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    //    func setupCell(source: String , name: String ,image:String) {
    //        sourceLabel.text = source
    //        recipeNameLabel.text = name
    //        recipeImageView.sd_setImage(with: URL(string: (self.searchViewModel.getImgUrl(imageUrl: image ?? "") )), placeholderImage: UIImage(named: "noimg"))
    //    }
    
    //
    //    //space between cells in table view
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 2))
    //    }
}
