//
//  OnboardingCollectionViewCell.swift
//  Wasafaty
//
//  Created by Macbook on 19/09/2021.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        setupViews()
    }
    
    // MARK: - Setup Views
    func setupViews() {
        // Nothing
    }
}
