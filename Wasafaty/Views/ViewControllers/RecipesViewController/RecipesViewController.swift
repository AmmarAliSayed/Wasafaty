//
//  RecipesViewController.swift
//  Wasafaty
//
//  Created by Macbook on 05/10/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import SafariServices

class RecipesViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var recipesTableView: UITableView!
    //@IBOutlet weak var recipesTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    // @IBOutlet weak var ingredientsCollectionViewHeightConstraint: NSLayoutConstraint!
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    //MARK: - vars
    let recipesViewModel = RecipesViewModel()
    //We can use DisposeBag tool to properly dispose of Observers when the parent objects, which we define Observers with, are deallocated.
    let disposeBag = DisposeBag()
    let recipeCollectionViewCell = "RecipeCollectionViewCell"
    let recipeTableViewCell = "RecipeTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        // subscribeToResponseCollectionView()
        subscribeToResponseCollectionView()
        subscribeToResponseTableView()
        subscribeToIngredientSelection()
        subscribeToLoading()
        subscribeToRecipeSelection()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        selectFristTab()
        
    }
    /// Present action sheet and ask user if they really want to leave (and clear basket) or to cancel (if they made a mistake).
    @IBAction func close(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Are you sure you want to leave?", message: "You will lose your current basket and would have to start again.", preferredStyle: .actionSheet)
        let leaveAction = UIAlertAction(title: "Leave and Clear Basket", style: .destructive) { [weak self] (action) in
            // Empty Basket
            self?.recipesViewModel.EmptyBasket()
            self?.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(leaveAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    //make first tab selected when user open the app
    func selectFristTab() {
        //select frist tab
        ingredientsCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        //bind data to table view
        let cell = self.ingredientsCollectionView.cellForItem(at: selectedIndexPath) as! RecipeCollectionViewCell
        let title = cell.titleLabel.text
        recipesViewModel.getRecipesFromApi(recipeName: title ?? "")
        //        ingredientsCollectionView
        //                .rx
        //                .modelSelected(Ingredient.self)
        //                .subscribe(onNext: { (ingredient) in
        //                    //Your code
        //                    self.recipesViewModel.getRecipesFromApi(recipeName: ingredient.name ?? "")
        //                }).disposed(by: disposeBag)
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
        self.recipesViewModel.basketOfIngredientsModelObservable
            .bind(to: self.ingredientsCollectionView
                    .rx
                    .items(cellIdentifier: recipeCollectionViewCell,
                           cellType:RecipeCollectionViewCell.self)) { [weak self] row, ingredient, cell in
                
                // self?.basketCollectionViewHeightConstraint.constant = 37
                //   self?.reloadViews()
                
                // cell.delegate = self
                // cell.ingredient = ingredient
                //row -> indexPath.row
                //print(row)
                //  guard let self = self else { return }
                // print(ingredient.name)
                // cell.isDarkMode = true
                cell.setupCell(text: ingredient.name ?? "")
                
                //use configreCell() method in custom cell case
                // cell.textLabel?.text = branch.name
                //cell.ingredientNameLabel.text = ingredient.name
                // cell.ingredientImageView.image = ingredient.image
                //cell.ingredientImageView.sd_setImage(with: URL(string: (self.searchViewModel.getImgUrl(imageUrl: ingredient.image ?? "") )), placeholderImage: UIImage(named: "noimg"))
            }
            .disposed(by: disposeBag)
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
        self.recipesViewModel.recipesModelObservable
            .bind(to: self.recipesTableView
                    .rx
                    .items(cellIdentifier: recipeTableViewCell,
                           cellType:RecipeTableViewCell.self)) { [weak self] row, recipe, cell in
                //row -> indexPath.row
                //print(row)
                guard let self = self else { return }
                // cell.delegate = self
                // cell.ingredient = ingredient
                //use configreCell() method in custom cell case
                // cell.textLabel?.text = branch.name
                cell.recipeNameLabel.text = recipe.title
                //  cell.sourceLabel.text = recipe.sourceName
                // cell.sourceLabel.text = "mmmmmmmmm"
                // cell.ingredientImageView.image = ingredient.image
                //cell.recipeImageView.sd_setImage(with: URL(string:recipe.displayImage)), placeholderImage: UIImage(named: "noimg"))
                
                cell.recipeImageView.sd_setImage(with: URL(string: (recipe.displayImage)), placeholderImage: UIImage(named: "noimg"))
                
            }
            .disposed(by: disposeBag)
    }
    //handle cell selection
    func subscribeToIngredientSelection() {
        //itemSelected = didSelectRow() func in tableView
        Observable
            .zip(ingredientsCollectionView.rx.itemSelected, ingredientsCollectionView.rx.modelSelected(Ingredient.self))
            .bind { [weak self] selectedIndex, ingredient in
                // print(selectedIndex, ingredient.name ?? "")
                self?.recipesViewModel.getRecipesFromApi(recipeName: ingredient.name ?? "")
            }
            .disposed(by: disposeBag)
    }
    //handle cell selection
    func subscribeToRecipeSelection() {
        //itemSelected = didSelectRow() func in tableView
        Observable
            .zip(recipesTableView.rx.itemSelected, recipesTableView.rx.modelSelected(Recipe.self))
            .bind { [weak self] selectedIndex, recipe in
                //  print(selectedIndex, recipe.sourceUrl ?? "mmm")
                // self?.animateCell(indexPath: selectedIndex)
                
                //                guard let destinationVC = self?.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailViewController") as? RecipeDetailViewController else {
                //                    return
                //                }
                //                destinationVC.recipeDetailsViewModel =  self?.recipesViewModel.getRecipesViewModel(recipe: recipe)
                //                self?.navigationController?.modalPresentationStyle = .custom
                //                self?.navigationController?.pushViewController(destinationVC, animated: true)
                
                let recipeId = recipe.id
                self?.recipesViewModel.getRecipeInformation(recipeId:"\(recipeId)")
                self?.recipesViewModel.recipeInfoModelObservable.subscribe({ (event) in
                    // print(event.element?.spoonacularSourceUrl ?? "mmmmmmmm")
                    // print(event.element?[0].spoonacularSourceUrl ?? "nnnnnnnn")
                    
                    if  let sourceURL = event.element?[0].spoonacularSourceUrl, let url = URL(string: sourceURL) {
                        
                        let config = SFSafariViewController.Configuration()
                        let safariController = SFSafariViewController(url: url, configuration: config)
                        safariController.modalPresentationStyle = .formSheet
                        
                        self?.present(safariController, animated: true, completion: nil)
                        
                    }else{
                        self?.displayURLError()
                    }
                })
            }
            .disposed(by: disposeBag)
    }
    func subscribeToLoading() {
        self.recipesViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showIndicator(withTitle: "", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    
    /// If a recipe does not have a URL for some reason, the user should know why the website is not opening or why they can't share a recipe.
    func displayURLError() {
        let alert = UIAlertController(title: "This recipe does not have it's own page", message: "Our apologies! But it seems like this recipe's webpage was lost.", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(dismissAction)
        
        present(alert, animated: true, completion: nil)
    }
}
//extension RecipesViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = collectionView.frame.height
//
//        return CGSize(width: 200, height: height)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.view.frame.width / CGFloat(menuTitles.count), height: collectionView.bounds.height)
//    }
//}
// MARK: - UINavigationControllerDelegate
//extension RecipesViewController: UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController,
//                              animationControllerFor operation: UINavigationController.Operation,
//                              from fromVC: UIViewController,
//                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        switch operation {
//        case .push:
//            return AnimationManager(animationDuration: 1.3, animationType: .present)
//        case .pop:
//            return AnimationManager(animationDuration: 1.3, animationType: .dismiss)
//        default:
//            return nil
//        }
//    }
//}
