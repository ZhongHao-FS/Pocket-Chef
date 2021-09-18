//
//  SettingsViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/15/21.
//

import UIKit
import FirebaseEmailAuthUI

class SettingsViewController: UIViewController, FUIAuthDelegate {
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
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
