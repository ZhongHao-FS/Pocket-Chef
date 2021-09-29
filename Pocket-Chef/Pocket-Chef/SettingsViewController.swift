//
//  SettingsViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/15/21.
//

import UIKit
import FirebaseEmailAuthUI

class SettingsViewController: UIViewController {
    var currentUser: User!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({
            auth, user in
            if let user = user {
                let id = user.uid
                let name = user.displayName
                let email = user.email
                self.currentUser = User(id: id, name: name ?? "", email: email!)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if let destination = segue.destination as? FrequentListViewController {
            // Pass the selected object to the new view controller.
            destination.currentUid = self.currentUser.user_ID
        } else if let destination = segue.destination as? FavRecipesCollectionViewController {
            destination.currentUid = self.currentUser.user_ID
        }
    }
    

}
