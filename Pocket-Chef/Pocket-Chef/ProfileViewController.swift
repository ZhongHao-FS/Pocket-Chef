//
//  ProfileViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/28/21.
//

import UIKit
import FirebaseEmailAuthUI

class ProfileViewController: UIViewController, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            return editEmail()
        case 2:
            return editPwd()
        default:
            return editName()
        }
    }
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    
    var currentUser: User? = nil
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = currentUser {
            nameField.text = user.name
            emailField.text = user.email
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({
            auth, user in
            if let user = user {
                let uid = user.uid
                let name = user.displayName!
                let email = user.email!
                
                self.currentUser = User(id: uid, name: name, email: email)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func editName() -> Bool {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = nameField.text
        changeRequest?.commitChanges(completion: nil)
        displayAlert("Username updated successfully!")
        return true
    }
    
    func editEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if emailPred.evaluate(with: emailField.text) {
            Auth.auth().currentUser?.updateEmail(to: emailField.text!, completion: nil)
            displayAlert("Email updated successfully!")
            return true
        } else {
            displayAlert("Please enter a valid email")
            return false
        }
    }
    
    func editPwd() -> Bool {
        guard let length = pwdField.text?.count
        else {
            displayAlert("Invalid entry!")
            return false
        }
        
        if length < 6 {
            displayAlert("Password should be at least 6 characters")
            return false
        } else {
            Auth.auth().currentUser?.updatePassword(to: pwdField.text!, completion: nil)
            displayAlert("Password updated successfully!")
            return true
        }
    }
    
    func displayAlert(_ message: String) {
        let alert = UIAlertController(title: "Profile Update", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
