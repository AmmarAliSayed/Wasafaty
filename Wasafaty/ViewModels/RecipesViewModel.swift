//
//  RecipesViewModel.swift
//  Wasafaty
//
//  Created by Macbook on 05/10/2021.
//

import Foundation
import RxCocoa
import RxSwift
import CoreData
class RecipesViewModel{
    //property from model
    var networkService : NetworkService!
    
    private var recipesModelSubject = PublishSubject<[Recipe]>()
    var recipesModelObservable: Observable<[Recipe]> {
        return recipesModelSubject
    }
    // private var basketOfIngredientsModelSubject = PublishSubject<[Ingredient]>()
    private  var basketOfIngredientsModelSubject: BehaviorRelay<[Ingredient]> = BehaviorRelay(value: [])
    var basketOfIngredientsModelObservable: Observable<[Ingredient]> {
        return basketOfIngredientsModelSubject.asObservable()
    }
    
    private var recipeInfoModelSubject = PublishSubject<[Recipe]>()
    var recipeInfoModelObservable: Observable<[Recipe]> {
        return recipeInfoModelSubject
    }
    // value = false  -> mean deafult value = false
    // loadingBehavior used to control loading satus
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    // var tempBasket : [Ingredient] = [Ingredient(name: "rice", image: ""),Ingredient(name: "bbb", image: "")]
    var tempBasket : [Ingredient] = []
    var BasketCoreData: [NSManagedObject]!
    let manageContext: NSManagedObjectContext
    
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.manageContext = mainContext
        self.networkService = NetworkService()
        fetchBasketItems()
        //self.basketOfIngredientsModelSubject.onNext(tempBasket)
    }
    //    init(){
    //        self.basketOfIngredientsModelSubject.accept(tempBasket)
    //    }
    func fetchBasketItems(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "IngredientCoreData")
        do{
            BasketCoreData = try manageContext.fetch(fetchRequest)
            for object in BasketCoreData {
                let ingredientName = object.value(forKey: "name") as! String
                let ingredient = Ingredient(name: ingredientName, image: "")
                tempBasket.append(ingredient)
            }
            if BasketCoreData.count > 0{
                self.basketOfIngredientsModelSubject.accept(tempBasket)
            }
        }catch let error{
            print(error)
        }
    }
    func getRecipesFromApi(recipeName : String) {
        loadingBehavior.accept(true)
        networkService.fetchRecipes(from: recipeName) { [weak self] (recipes, error) in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            if let error :Error = error{
                let message = error.localizedDescription
                print(message)
            }else{
                if recipes?.count ?? 0 > 0 {
                    self.recipesModelSubject.onNext(recipes ?? [])
                    //   self.isTableHidden.accept(false)
                } else {
                    // self.isTableHidden.accept(true)
                    // self.emptyTableText.accept("There are no ingredients matching \"\(text)\"")
                }
            }
        }
    }
    func getRecipeInformation(recipeId : String) {
        //  loadingBehavior.accept(true)
        networkService.fetchAllRecipeInformation(from: recipeId) { [weak self] (recipes, error) in
            guard let self = self else { return }
            //  self.loadingBehavior.accept(false)
            if let error :Error = error{
                let message = error.localizedDescription
                print(message)
            }else{
                if let recs = recipes {
                    self.recipeInfoModelSubject.onNext(recs)
                }else{
                    
                }
            }
        }
    }
    func getImgUrl(imageUrl: String) -> String {
        networkService.returnImageUrl(imageName: imageUrl)
    }
    func EmptyBasket(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "IngredientCoreData")
        //  let predicate = NSPredicate(format: "name == %@", ingredient.name!)
        //  fetchRequest.predicate = predicate
        
        if let result = try? manageContext.fetch(fetchRequest) {
            for object in result {
                manageContext.delete(object)
                try? manageContext.save()
            }
            // tempBasket = tempBasket.filter { $0.name != ingredient.name }
            //self.basketOfIngredientsModelSubject.onNext(tempBasket)
        }
        
    }
    
    //    func getRecipesViewModel(recipe : Recipe) -> RecipeDetailsViewModel {
    //        return RecipeDetailsViewModel(item: recipe)
    //    }
}
