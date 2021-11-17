//
//  BasketCellDelegate.swift
//  Wasafaty
//
//  Created by Macbook on 27/09/2021.
//

import Foundation
protocol BasketCellDelegate {
    func didAddIngredient(ingredient : Ingredient)
    func didRemoveIngredient(ingredient : Ingredient)
}
