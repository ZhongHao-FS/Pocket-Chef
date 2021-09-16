//
//  SettingsViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/15/21.
//

import UIKit
import FirebaseAuthUI
import FirebaseEmailAuthUI

class SettingsViewController: UIViewController, FUIAuthDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [FUIEmailAuth()]
        authUI!.providers = providers
        let emailProvider = authUI!.providers.first as! FUIEmailAuth
        emailProvider.signIn(withPresenting: self, email: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
