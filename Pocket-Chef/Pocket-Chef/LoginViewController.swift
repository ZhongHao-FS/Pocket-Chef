//
//  LoginViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/16/21.
//

import UIKit
import FirebaseEmailAuthUI

class LoginViewController: UIViewController, FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        guard error == nil,
              currentUser != nil
        else {
            print(error!.localizedDescription)
            return
        }
        
        performSegue(withIdentifier: "ToSettings", sender: self)
    }
    
    @IBOutlet weak var loginButton: UIButton!
    
    var currentUser: User? = nil
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginTapped(loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ auth, user in
            if let user = user {
                let uid = user.uid
                let email = user.email!
                
                self.currentUser = User(id: uid, email: email)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let authUI = FUIAuth.defaultAuthUI()
        guard authUI != nil else {
            print("Error loading Firebase AuthUI!")
            return
        }
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [FUIEmailAuth()]
        authUI!.providers = providers
        let emailProvider = authUI!.providers.first as! FUIEmailAuth
        emailProvider.signIn(withPresenting: self, email: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSettings" {
            // Get the new view controller using segue.destination.
            let destination = segue.destination as! SettingsViewController
            // Pass the selected object to the new view controller.
            destination.currentUser = self.currentUser!
        }
        
    }
    

}
