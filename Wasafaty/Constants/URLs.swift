//
//  URLs.swift
//  Wasafaty
//
//  Created by Macbook on 20/09/2021.
//

import Foundation
struct URLs {
    //static let baseURL = "https://newsapi.org/v2/"
    // static let headline = "top-headlines?country=eg"
    //static let apiKey = "3ff93ea6b02c4760aa7080f4550b0820"
    
    // API Endpoint - find recipes given ingredients
    static let findByIngredientsEndpoint = "https://api.spoonacular.com/recipes/findByIngredients"
    
    // API Endpoint - extract details froom a specific recipe
    static let informationBulkEndpoint = "https://api.spoonacular.com/recipes/informationBulk"
    
    // Base URL - base url for ingredient images
    static let ingredientImageURL = "https://spoonacular.com/cdn/ingredients_500x500/"
    
    // let apiKey = "7845152a156345c9b7ffb9ea93a0b4ae"
    static  let apiKey = "805983fda8414080aeb4c5d069cd1733"
    
    // Spoontacular API - needed here for autocomplete functionality
    static let spoontacularEndpoint = "https://api.spoonacular.com/food/ingredients/autocomplete"
    //    let spoontacularAPIKey = "7845152a156345c9b7ffb9ea93a0b4ae"
    //  let spoontacularAPIKey = "805983fda8414080aeb4c5d069cd1733"
}
