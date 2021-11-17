//
//  ViewController.swift
//  Wasafaty
//
//  Created by Macbook on 10/06/2021.
//

import UIKit

class IntroViewController: UIViewController {
    // MARK: - Outlets
    //@IBOutlet weak var startScanningButton: UIButton!
    @IBOutlet weak var addIngredientsManuallyButton: UIButton!
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // Onboarding collection view content
    let images: [String] = ["search", "cook", "eat"]
    let titles: [String] = [ "Find Recipes.", "Cook.", "Enjoy."]
    let descriptions: [String] = ["Using this app, use the limited ingredients you have (you don't want to go and buy stuff right now, do you?) and find out what you can make with it!", "Get in the kitchen! Follow the recipes and make something amazing.", "Eat your creation. If you didn't undercook, overcook, or drop the food, it should be great! If it was a fail, tweet about it and you'll go trending. Win win!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    // MARK: - Setup Views
    /// Setups constraints and relavent design aspects
    func setupViews() {
        //  startScanningButton.layer.cornerRadius = 8
        
        addIngredientsManuallyButton.layer.cornerRadius = 8
        addIngredientsManuallyButton.layer.borderWidth = 2.0
        addIngredientsManuallyButton.layer.borderColor = UIColor.black.cgColor
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero
        
        onboardingCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        onboardingCollectionView.collectionViewLayout = flowLayout
        
        pageControl.numberOfPages = titles.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension IntroViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Cells for onboarding on the main view
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardingCell", for: indexPath) as! OnboardingCollectionViewCell
        
        cell.onboardingImageView.image = UIImage(named: images[indexPath.row])
        cell.titleLabel.text = titles[indexPath.row]
        cell.descriptionTextView.text = descriptions[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}

