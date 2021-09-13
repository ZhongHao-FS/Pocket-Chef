//
//  Recipe.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/12/21.
//

import Foundation
import UIKit

class Recipe {
    // Stored Properties
    let id: Int
    let title: String
    let calories: Int
    let carbs: String
    let fat: String
    var image: UIImage
    let protein: String
    
    // Initializer
    init(id: Int, title: String, calories: Int, carbs: String, fat: String, imageURL: String, protein: String) {
        self.id = id
        self.title = title
        self.calories = calories
        self.carbs = carbs
        self.fat = fat
        self.image = #imageLiteral(resourceName: "PocketChef")
        self.protein = protein
        
        if let url = URL(string: imageURL) {
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    self.image = image
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
