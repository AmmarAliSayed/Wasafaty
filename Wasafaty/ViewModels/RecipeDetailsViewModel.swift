//
//  RecipeDetailsViewModel.swift
//  Wasafaty
//
//  Created by Macbook on 16/10/2021.
//

import Foundation
import RxCocoa
import RxSwift
import CoreData
class RecipeDetailsViewModel {
 //   var selectedItem :Recipe!
     //var recipeModelSubject = PublishSubject<Recipe>()
    
    private var recipeModelSubject = ReplaySubject<Recipe>.create(bufferSize: 1)
    //let recipeImage: Observable<UIImage?>
    var recipeModelObservable: Observable<Recipe> {
        return recipeModelSubject
    }
     var extendedIngredientModelSubject  = PublishSubject<[ExtendedIngredient]>()
    var extendedIngredientModelObservable: Observable<[ExtendedIngredient]> {
        return extendedIngredientModelSubject.asObservable()
    }
    init(item : Recipe){
        //selectedItem = item
        recipeModelSubject.onNext(item)
        //extendedIngredientModelSubject.onNext(item.extendedIngredients ?? [])
        //self.recipeImage = Observable.just(UIImage(data: item.displayImage))
    }
}
