//
//  Ingredient.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/26/21.
//

import Foundation

class Ingredient {
    // Stored Properties
    let name: String
    var amount: Double
    let unit: String
    
    // Initializer
    init(name: String, quantity: Double, unit: String = "") {
        self.name = name
        self.amount = quantity
        self.unit = unit
    }
}
