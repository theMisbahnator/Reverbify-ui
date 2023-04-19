//
//  LoginViewController.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 2/28/23.
//

import UIKit
import FirebaseAuth

class LoginController : UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    //inSecureTextEntrry = true
    @IBOutlet weak var loginButton: UIButton!
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let underlineAttribute = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.foregroundColor: UIColor.red
        ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        let underlineAttributedString = NSAttributedString(string: "Sign up here", attributes: underlineAttribute)

        signUpButton.setAttributedTitle(underlineAttributedString, for: .normal)
        
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        
        let buttonWidth = loginButton.bounds.size.width
        let buttonHeight = loginButton.bounds.size.height

        let fontSize = min(buttonWidth, buttonHeight) * 0.5
        
        let attributedString = NSAttributedString(string: "Login", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)
        ])
        loginButton.setAttributedTitle(attributedString, for: .normal)
        
        
        passwordField.isSecureTextEntry = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // looking for change in login state
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
            }
        }
        emailField.delegate = self
        passwordField.delegate = self
    }
    func createErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue(UIColor.red, forKey: "titleTextColor") // Set the text color to red
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) {
            authResult, error in
            if let error = error as NSError? {
                self.createErrorAlert(message: "\(error.localizedDescription)")
        }
    }

    }
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
