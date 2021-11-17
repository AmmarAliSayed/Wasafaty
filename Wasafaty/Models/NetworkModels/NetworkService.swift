//
//  IngredientsService.swift
//  Wasafaty
//
//  Created by Macbook on 24/09/2021.
//

import Foundation
import Alamofire
import SDWebImage
class NetworkService {
    func searchForIngredients(from text: String, limit: Int = 8 , completion :@escaping ([Ingredient]?,Error?)->()) {
        
        let query = "?apiKey=\(URLs.apiKey)&query=\(text)&number=\(limit)"
        //let urlString = "\(URLs.baseURL)\(URLs.headline)&apikey=\(URLs.apiKey)"
        let urlString = "\(URLs.spoontacularEndpoint )\(query)"
        //?apiKey=805983fda8414080aeb4c5d069cd1733&query=r&number=8
        //https://api.spoonacular.com/food/ingredients/autocomplete?apiKey=805983fda8414080aeb4c5d069cd1733&query=r&number=8
        
        AF.request(urlString).validate().responseDecodable(of:[Ingredient].self) { (response) in
            switch response.result{
            case .success(_):
                guard let ingredientData = response.value else {return}
                completion(ingredientData,nil)
            case .failure(let error):
                completion(nil,error)
            }
        }
    }
    
    func fetchRecipes(from ingredient: String, completion :@escaping ([Recipe]?,Error?)->()){
        let query = "?apiKey=\(URLs.apiKey)&ingredients=\(ingredient)&number=5&ranking=1&ignorePantry=true"
        let urlString = "\(URLs.findByIngredientsEndpoint)\(query)"
        AF.request(urlString).validate().responseDecodable(of:[Recipe].self) { (response) in
            switch response.result{
            case .success(_):
                guard let recipeData = response.value else {return}
                completion(recipeData,nil)
            case .failure(let error):
                completion(nil,error)
            }
        }
    }
    func fetchAllRecipeInformation(from ingredientId: String, completion :@escaping ([Recipe]?,Error?)->()){
        let query = "?apiKey=\(URLs.apiKey)&ids=\(ingredientId)"
        let urlString = "\(URLs.informationBulkEndpoint)\(query)"
        AF.request(urlString).validate().responseDecodable(of:[Recipe].self) { (response) in
            switch response.result{
            case .success(_):
                guard let recipeData = response.value else {return}
                completion(recipeData,nil)
            case .failure(let error):
                completion(nil,error)
            }
        }
    }
    func returnImageUrl( imageName: String)  -> String {
        return  "\(URLs.ingredientImageURL + imageName)"
    }
}
