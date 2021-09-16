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
    var name: String
    var email: String
    var password: String
    var fav_Recipes = [Recipe]()
    var shoppingList = [String]()
    
    // Initializer
    init(userName: String, email: String, pwd: String) {
        self.user_ID = "0"
        self.name = userName
        self.email = email
        self.password = pwd
    }
}
