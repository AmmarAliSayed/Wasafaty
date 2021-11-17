//
//  SearchViewModel.swift
//  Wasafaty
//
//  Created by Macbook on 25/09/2021.
//

import Foundation
import RxCocoa
import RxSwift
import CoreData
class SearchViewModel {
    //property from model
    var ingredientsService : NetworkService!
    var tempBasket : [Ingredient] = []
    // var tempBasket2 : [String] = []
    //var tempBasket2 = BehaviorRelay<[String]>(value: [])
    //let dataDriver: Driver<[Ingredient]>!
    var BasketCoreData: [NSManagedObject] = []
    let manageContext: NSManagedObjectContext
    // value = false  -> mean deafult value = false
    // loadingBehavior used to control loading satus
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var animationBehavior = BehaviorRelay<Bool>(value: false)
    private var isTableHidden = BehaviorRelay<Bool>(value: false)
    private var isContinueButtonEnabled = BehaviorRelay<Bool>(value: false)
    // var reloadCollectionViewBehavior = BehaviorRelay<Bool>(value: false)
    private var ContinueButtonBackground = BehaviorRelay<UIColor>(value: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    private var basketCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0.0)
    // ingredientsModelSubject varible used for carry the response from api [succuess or fail]
    // and we used PublishSubject rather than BehaviorRelay beacause BehaviorRelay need a defualt value
    //and make it private to apply encapsulation beacuse PublishSubject work as oservable and observer
    // so any one can write or modifay the data ,so we need to lock it to be read only
    //so we will recive  the login model data from api and add it to loginModelSubject
    //then lock it by make it private  then pass it to loginModelObservable and loginModelObservable
    // work as only Observable so will be read only .
    private var ingredientsModelSubject = PublishSubject<[Ingredient]>()
    var ingredientsModelObservable: Observable<[Ingredient]> {
        return ingredientsModelSubject
    }
    
    
    //   private  var basketOfIngredientsModelSubject: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    //    // private  var basketOfIngredientsModelSubject: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    //    var basketOfIngredientsModelObservable: Observable<[String]> {
    //        return basketOfIngredientsModelSubject.asObservable()
    //      }
    
    //    private var basketOfIngredientsModelSubject = PublishSubject<[Ingredient]>()
    //    var basketOfIngredientsModelObservable: Observable<[Ingredient]> {
    //        return basketOfIngredientsModelSubject
    //    }
    private  var basketOfIngredientsModelSubject: BehaviorRelay<[Ingredient]> = BehaviorRelay(value: [])
    var basketOfIngredientsModelObservable: Observable<[Ingredient]> {
        return basketOfIngredientsModelSubject.asObservable()
    }
    
    
    //    private var basketOfIngredientsModelSubject = ReplaySubject<[String]>.create(bufferSize: 1)
    //    //let recipeImage: Observable<UIImage?>
    //    var basketOfIngredientsModelObservable: Observable<[String]> {
    //        return basketOfIngredientsModelSubject
    //    }
    
    
    
    var isTableHiddenObservable: Observable<Bool> {
        //The magic of BehaviorRelay comes from a method called asObservable(). Instead of manually checking value every time, you can add an Observer to keep an eye on the value for you. When the value changes, the Observer lets you know so you can react to any updates.
        return isTableHidden.asObservable()
    }
    var isContinueButtonEnabledObservable: Observable<Bool> {
        return isContinueButtonEnabled.asObservable()
    }
    var ContinueButtonBackgroundObservable: Observable<UIColor> {
        return ContinueButtonBackground.asObservable()
    }
    var basketCollectionViewHeightObservable: Observable<CGFloat> {
        return basketCollectionViewHeight.asObservable()
    }
    
    
    // change the arr to the array of the model you want
    // var arr =    [ "1"]
    // var arr: [String] = []
    
    // change the type of [Int] to the type of [the model you want]
    
    // In RxSwift, cell's count = dataSource.elementArray.count
    // lazy var dataSource = BehaviorSubject<[String]>(value: [])
    
    
    
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.manageContext = mainContext
        self.ingredientsService = NetworkService()
        // fetchBasketItems()
        // self.dataDriver
    }
    func getSearchResult(text : String) {
        loadingBehavior.accept(true)
        ingredientsService.searchForIngredients(from: text) { [weak self] (ingredients, error) in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            if let error :Error = error{
                let message = error.localizedDescription
                print(message)
            }else{
                if ingredients?.count ?? 0 > 0 {
                    self.ingredientsModelSubject.onNext(ingredients ?? [])
                    self.isTableHidden.accept(false)
                } else {
                    self.isTableHidden.accept(true)
                    // self.emptyTableText.accept("There are no ingredients matching \"\(text)\"")
                }
            }
        }
    }
    
    func addToBasket(ingredient: Ingredient){
        
        //1-save values
        let entity = NSEntityDescription.entity(forEntityName: "IngredientCoreData", in: manageContext)
        
        let ingredientCoreData = NSManagedObject(entity: entity!, insertInto: manageContext)
        
        let name  = ingredient.name
        ingredientCoreData.setValue(name, forKey: "name")
        do{
            try manageContext.save()
            // BasketCoreData = BasketCoreData.filter { $0.value(forKey: "name") as? String != ingredientCoreData.value(forKey: "name") as? String }
            BasketCoreData.append(ingredientCoreData)
        }catch let error{
            print(error)
        }
        
        //2-fetch values
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "IngredientCoreData")
        //var ingredientName = fetchRequest.value(forKey: "name") as! String
        do{
            BasketCoreData = try manageContext.fetch(fetchRequest)
            for object in BasketCoreData {
                let ingredientName = object.value(forKey: "name") as! String
                let ingredient = Ingredient(name: ingredientName, image: "")
                self.tempBasket = tempBasket.filter { $0.name != ingredient.name }
                tempBasket.append(ingredient)
                //  tempBasket.append(ingredient)
            }
            if BasketCoreData.count > 0{
                // tempBasket.append(ingredient)
                //self.tempBasket = tempBasket.filter { $0.name != ingredient.name }
                self.basketOfIngredientsModelSubject.accept(tempBasket)
                //self.basketOfIngredientsModelSubject.accept(tempBasket)
                //self.reloadCollectionViewBehavior.accept(true)
                self.isContinueButtonEnabled.accept(true)
                self.ContinueButtonBackground.accept(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                self.basketCollectionViewHeight.accept(37)
                self.animationBehavior.accept(true)
            }
        }catch let error{
            print(error)
        }
    }
    
    
    func removeFromBasket( ingredient: Ingredient) {
        // Set value of basket array to a copy of basket array where the
        // specified ingredient to be removed is removed from the array itself
        // tempBasket = tempBasket.filter { $0.name != ingredient.name }
        //self.basketOfIngredientsModelSubject.onNext(tempBasket)
        if tempBasket.count > 1{
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "IngredientCoreData")
            let predicate = NSPredicate(format: "name == %@", ingredient.name!)
            fetchRequest.predicate = predicate
            
            if let result = try? manageContext.fetch(fetchRequest) {
                for object in result {
                    manageContext.delete(object)
                    try? manageContext.save()
                }
                tempBasket = tempBasket.filter { $0.name != ingredient.name }
                //self.basketOfIngredientsModelSubject.onNext(tempBasket)
                self.basketOfIngredientsModelSubject.accept(tempBasket)
            }
        }else{
            //when we removed last item we need to to make ContinueButtonEnabled  = false
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "IngredientCoreData")
            let predicate = NSPredicate(format: "name == %@", ingredient.name!)
            fetchRequest.predicate = predicate
            
            if let result = try? manageContext.fetch(fetchRequest) {
                for object in result {
                    manageContext.delete(object)
                    try? manageContext.save()
                }
                tempBasket = tempBasket.filter { $0.name != ingredient.name }
                //self.basketOfIngredientsModelSubject.onNext(tempBasket)
                self.basketOfIngredientsModelSubject.accept(tempBasket)
                self.isContinueButtonEnabled.accept(false)
                self.ContinueButtonBackground.accept(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1))
            }
        }
        
    }
    
    func getImgUrl(imageUrl: String) -> String {
        ingredientsService.returnImageUrl(imageName: imageUrl)
    }
}
