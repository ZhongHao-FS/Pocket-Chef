//
//  User.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/14/21.
//

import Foundation

class User {
    // Stored Properties
    let user_ID: String
    var email: String
    var fav_Recipes = [Recipe]()
    var shoppingList = [String]()
    
    // Initializer
    init(id: String, email: String) {
        self.user_ID = id
        self.email = email
    }
}
