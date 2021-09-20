//
//  RecipeCard.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/18/21.
//

import Foundation
import UIKit

class RecipeCard {
    // Stored Properties
    let id: Int
    let title: String
    var image: UIImage
    let type: String
    
    // Initializer
    init(id: Int, title: String, imageURL: String, type: String = "") {
        self.id = id
        self.title = title
        self.image = #imageLiteral(resourceName: "PocketChef")
        self.type = type
        
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
