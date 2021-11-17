//
//  SearchViewController.swift
//  Wasafaty
//
//  Created by Macbook on 20/09/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
class SearchViewController: UIViewController{
    
    // MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var ingredientsView: UIView!
    @IBOutlet weak var autocompleteTableView: UITableView!
    @IBOutlet weak var basketCollectionView: UICollectionView!
    @IBOutlet weak var continueButton: UIButton!
    //  @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var basketCollectionViewHeightConstraint: NSLayoutConstraint!
    //MARK: - vars
    let searchViewModel = SearchViewModel()
    //We can use DisposeBag tool to properly dispose of Observers when the parent objects, which we define Observers with, are deallocated.
    let disposeBag = DisposeBag()
    let ingredientSearchTableViewCell = "IngredientSearchTableViewCell"
    let basketCollectionViewCell = "BasketCollectionViewCell"
    //var impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //As explained in previous chapters, observables are entities capable of notifying subscribers that some data has arrived or changed, pushing values to be processed.
        //  For this reason, the correct place to subscribe to an observable while working in view controllers is inside viewDidLoad. This is because you need to subscribe as early as possible, but only after the view has been loaded.
        // Subscribing in a different lifecycle event might lead to missed events, duplicate subscriptions, or parts of the UI that might be visible before you bind data to them.
        // Therefore, you have to create all subscriptions before the application creates or requests data that needs to be processed and displayed to the user.
        
        
        // basketCollectionView.dataSource = self
        // basketCollectionView.delegate = self
        
        setupViews()
        subscribeToAnimation()
        subscribeToResponseTableView()
        subscribeToResponseCollectionView()
        subscribeToLoading()
        bindToHiddenTable()
        bindToEnabledContinueButton()
        bindToContinueButtonBackground()
        bindTobasketCollectionViewHeightConstraint()
        // subscribeToReloadCollection()
        // ContinueButtonPressedAlert()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.autocompleteTableView.reloadData()
    }
    /// API search for recipes to populate table view with suggestions
    /// - Parameter sender: Data source of text, like a text field (searchTextField, in this case)
    @IBAction func searchChanged(_ sender: Any) {
        // Remove all ingredients and reload right after to avoid fatal errors
        //Ingredients.sharedInstance.searchResults.removeAll()
        // self.autocompleteTableView.reloadData()
        
        if let sender = sender as? UITextField, let searchText = sender.text {
            //            Ingredients.sharedInstance.autocompleteIngredients(from: search) { (success) in
            //                if success {
            //                    DispatchQueue.main.async {
            //                        UIView.performWithoutAnimation {
            //                            self.autocompleteTableView.reloadData()
            //
            //                            // Bottom two methods should help with preventing flicker when loading new images
            //                            self.autocompleteTableView.beginUpdates()
            //                            self.autocompleteTableView.endUpdates()
            //                        }
            //                    }
            //                    return
            //                } else {
            //                    print("Error")
            //                }
            //            }
            
            searchViewModel.getSearchResult(text: searchText)
        }
    }
    // MARK: - Setup Views
    /// Setups constraints and relavent design aspects
    func setupViews() {
        // basketCollectionViewHeightConstraint.constant = 0
        // self.reloadViews()
        
        
        //        // If empty, disable continue button
        //        if Ingredients.sharedInstance.basket.count == 0 {
        //            self.continueButton.disable()
        //        } else {
        //            self.continueButton.enable()
        //        }
        //
        continueButton.layer.cornerRadius = 8
        autocompleteTableView.showsVerticalScrollIndicator = false
        autocompleteTableView.allowsSelection = false
        autocompleteTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: continueButton.frame.height + 40, right: 0)
        
        basketCollectionView.backgroundColor = UIColor.clear
        //basketCollectionView.backgroundColor = UIColor.blue
        basketCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        //  basketCollectionView.register(UINib(nibName: basketCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: basketCollectionViewCell)
    }
    
    //Reload views with smooth animation
    func reloadViews() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
        }
    }
    
    
    //bind items to tableView
    func subscribeToResponseTableView() {
        //bind the array [the arary in branchesModelObservable] with cells [items]
        //so we do not use  -> branchesTableView.dataSource = self
        // so these lines = 2 methods
        // 1- numberOfRowsInSection()
        //2- dequeueReusableCell()
        // and this bind opertion do not need  branchesTableView.reloadData() so
        // any change in data we will listen to it
        self.searchViewModel.ingredientsModelObservable
            .bind(to: self.autocompleteTableView
                    .rx
                    .items(cellIdentifier: ingredientSearchTableViewCell,
                           cellType:IngredientSearchTableViewCell.self)) { [weak self] row, ingredient, cell in
                //row -> indexPath.row
                //print(row)
                guard let self = self else { return }
                cell.delegate = self
                cell.ingredient = ingredient
                //use configreCell() method in custom cell case
                // cell.textLabel?.text = branch.name
                cell.ingredientNameLabel.text = ingredient.name
                // cell.ingredientImageView.image = ingredient.image
                cell.ingredientImageView.sd_setImage(with: URL(string: (self.searchViewModel.getImgUrl(imageUrl: ingredient.image ?? "") )), placeholderImage: UIImage(named: "noimg"))
            }
            .disposed(by: disposeBag)
    }
    //bind items to collectionView
    func subscribeToResponseCollectionView() {
        //bind the array [the arary in basketOfIngredientsModelObservable] with cells [items]
        //so we do not use  -> basketCollectionView.dataSource = self
        // so these lines = 2 methods
        // 1- numberOfRowsInSection()
        //2- dequeueReusableCell()
        // and this bind opertion do not need  basketCollectionView.reloadData() so
        // any change in data we will listen to it
        self.searchViewModel.basketOfIngredientsModelObservable
            .bind(to: self.basketCollectionView
                    .rx
                    .items(cellIdentifier: basketCollectionViewCell,
                           cellType:BasketCollectionViewCell.self)) { [weak self] row, ingredient, cell in
                
                // self?.basketCollectionViewHeightConstraint.constant = 37
                //   self?.reloadViews()
                
                cell.delegate = self
                cell.ingredient = ingredient
                //row -> indexPath.row
                //print(row)
                //  guard let self = self else { return }
                // print(ingredient.name)
                // cell.isDarkMode = true
                cell.ingredientLabel.text = ingredient.name
                
                //use configreCell() method in custom cell case
                // cell.textLabel?.text = branch.name
                //cell.ingredientNameLabel.text = ingredient.name
                // cell.ingredientImageView.image = ingredient.image
                //cell.ingredientImageView.sd_setImage(with: URL(string: (self.searchViewModel.getImgUrl(imageUrl: ingredient.image ?? "") )), placeholderImage: UIImage(named: "noimg"))
            }
            .disposed(by: disposeBag)
        
        
    }
    
    
    func bindToHiddenTable() {
        //Thanks to isHidden, one of the extensions of RxCocoa, we can reach the isHidden parameter of tableView as an Observable variable.
        self.searchViewModel.isTableHiddenObservable.bind(to: self.ingredientsView.rx.isHidden).disposed(by: disposeBag)
    }
    func bindToEnabledContinueButton() {
        //bind(to:) function allows us to connect the Observable variable with the same type. (It turns the isEnabled variable of the rx.isEnabled button, one of the extensions of RxCocoa, to an Observable variable.)
        self.searchViewModel.isContinueButtonEnabledObservable.bind(to: self.continueButton.rx.isEnabled).disposed(by: disposeBag)
    }
    //    func ContinueButtonPressedAlert() {
    //        //bind(to:) function allows us to connect the Observable variable with the same type. (It turns the isEnabled variable of the rx.isEnabled button, one of the extensions of RxCocoa, to an Observable variable.)
    //        self.searchViewModel.isContinueButtonEnabledObservable.subscribe(onNext: { (isEnabled) in
    //            if isEnabled {
    //                //
    //            } else {
    //                self.showAlert()
    //            }
    //        }).disposed(by: disposeBag)
    //    }
    func bindToContinueButtonBackground() {
        self.searchViewModel.ContinueButtonBackgroundObservable.bind(to: self.continueButton.rx.backgroundColor).disposed(by: disposeBag)
    }
    func bindTobasketCollectionViewHeightConstraint() {
        self.searchViewModel.basketCollectionViewHeightObservable.bind(to: self.basketCollectionViewHeightConstraint.rx.constant).disposed(by: disposeBag)
    }
    func subscribeToLoading() {
        self.searchViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showIndicator(withTitle: "", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    func subscribeToAnimation() {
        self.searchViewModel.animationBehavior.subscribe(onNext: { (isAnimate) in
            if isAnimate {
                self.reloadViews()
            }
        }).disposed(by: disposeBag)
    }
    //    func subscribeToReloadCollection() {
    //        self.searchViewModel.reloadCollectionViewBehavior.subscribe(onNext: { (isReload) in
    //            if isReload {
    //                self.basketCollectionView.reloadData()
    //            }
    //        }).disposed(by: disposeBag)
    //    }
    
    //    func showAlert(){
    //        let action = UIAlertController(title: "Alert!", message: "Add items frist.", preferredStyle: .alert)
    //
    //        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    //
    //        action.addAction(cancelAction)
    //
    //        present(action, animated: true, completion: nil)
    //    }
}
// MARK: - IngredientCellDelegate
extension SearchViewController: BasketCellDelegate {
    
    func didAddIngredient(ingredient: Ingredient) {
        // subscribeToResponse2()
        self.searchViewModel.addToBasket(ingredient: ingredient)
        //   impactGenerator.impactOccurred()
        // self.autocompleteTableView.reloadData()
        // self.basketCollectionView.reloadData()
        //  self.resignFirstResponder()
    }
    
    func didRemoveIngredient(ingredient: Ingredient) {
        self.searchViewModel.removeFromBasket(ingredient: ingredient)
        //  impactGenerator.impactOccurred()
        // self.autocompleteTableView.reloadData()
        // self.basketCollectionView.reloadData()
        //self.resignFirstResponder()
    }
    
}
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        let height = collectionView.frame.height
    //        let width = collectionView.frame.width
    //        return CGSize(width: width, height: height)
    //    }
}
//extension SearchViewController:UICollectionViewDelegate, UICollectionViewDataSource  {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        DispatchQueue.main.async {
////            self.basketCollectionViewHeightConstraint.constant = Ingredients.sharedInstance.basket.count == 0 ? 0 : 37
////            self.reloadViews()
////
////            // If empty, disable continue button
////            if Ingredients.sharedInstance.basket.count == 0 {
////                self.continueButton.disable()
////            } else {
////                self.continueButton.enable()
////            }
////        }
//        if searchViewModel.BasketCoreData != nil{
//            return searchViewModel.BasketCoreData.count
//        }else{
//            return 0
//        }
//        
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier:basketCollectionViewCell, for: indexPath) as? BasketCollectionViewCell {
//            
//            cell.delegate = self
//          //  cell.ingredient = ingredient
//            //row -> indexPath.row
//            //print(row)
//          //  guard let self = self else { return }
//           // print(ingredient.name)
//           // cell.isDarkMode = true
//            cell.ingredientLabel.text = searchViewModel.BasketCoreData[indexPath.row].value(forKey: "name") as? String
//            
//            return cell
//        }
//
//        return UICollectionViewCell()
//    }
//
//
//
//}
