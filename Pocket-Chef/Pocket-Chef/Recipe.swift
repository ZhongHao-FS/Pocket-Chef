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
    let calories: Int? = nil
    let carbs: String? = nil
    let fat: String? = nil
    var image: UIImage
    let protein: String? = nil
    
    // Initializer
    init(id: Int, title: String, imageURL: String) {
        self.id = id
        self.title = title
        self.image = #imageLiteral(resourceName: "PocketChef")
        
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
