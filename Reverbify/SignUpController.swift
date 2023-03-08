//
//  SignUpController.swift
//  Reverbify
//
//  Created by Ayush Patel on 3/7/23.
//

import UIKit
import FirebaseAuth
class SignUpController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        errorMessage.text = ""
        let underlineAttribute = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.foregroundColor: UIColor.blue
        ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        let underlineAttributedString = NSAttributedString(string: "Login here", attributes: underlineAttribute)

        loginButton.setAttributedTitle(underlineAttributedString, for: .normal)
        
        signUpButton.layer.cornerRadius = 20
        signUpButton.layer.masksToBounds = true
        
        signUpButton.bounds.size.width = 206
        signUpButton.bounds.size.height = 65
        
        let fontSize = min(signUpButton.bounds.size.width, signUpButton.bounds.size.height) * 0.5
        
        let attributedString = NSAttributedString(string: "Sign Up", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)
        ])
        signUpButton.setAttributedTitle(attributedString, for: .normal)
        
        errorMessage.numberOfLines = 0
        
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.text = ""
        let underlineAttribute = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.foregroundColor: UIColor.blue
        ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        let underlineAttributedString = NSAttributedString(string: "Login here", attributes: underlineAttribute)

        loginButton.setAttributedTitle(underlineAttributedString, for: .normal)
        
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func isValidEmail(_ email: String) -> Bool {
       let emailRegEx =
           "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let emailPred = NSPredicate(format:"SELF MATCHES %@",
           emailRegEx)
       return emailPred.evaluate(with: email)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        guard let email = emailField.text else {
            self.errorMessage.text = "Please enter an email"
            return
        }
        guard let password = passwordField.text else {
            self.errorMessage.text = "Please enter a password"
            return
        }
        guard let confirmPassword = confirmPasswordField.text else {
            self.errorMessage.text = "Please confirm your password"
            return
        }
        
        if(!isValidEmail(email)) {
            self.errorMessage.text = "Please enter a valid email"
            return
        }
        
        if password != confirmPassword {
            self.errorMessage.text = "Passwords do not match"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error in
            if let error = error as NSError? {
                self.errorMessage.text = "\(error.localizedDescription)"
            }
            else {
                self.errorMessage.text = ""
                self.performSegue(withIdentifier: "signUpSegue", sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
                self.confirmPasswordField.text = nil
            }
        }
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
