//
//  RegisterController.swift
//  Reverbify
//
//  Created by Ayush Patel on 3/7/23.
//

import UIKit
import FirebaseAuth

class RegisterController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        let underlineAttribute = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.foregroundColor: UIColor.red
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
        
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func createErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue(UIColor.red, forKey: "titleTextColor") // Set the text color to red
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard let email = emailField.text else {
            createErrorAlert(message: "Please enter an email")
            return
        }
        guard let password = passwordField.text else {
            createErrorAlert(message: "Please enter a password")
            return
        }
        guard let confirmPassword = confirmPasswordField.text else {
            createErrorAlert(message: "Please confirm your password")
            return
        }
        
        if(!isValidEmail(email)) {
            createErrorAlert(message: "Please enter a valid email")
          
//            self.errorMessage.text = "Please enter a valid email"
            return
        }
        
        if password != confirmPassword {
            createErrorAlert(message: "Passwords do not match")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error in
            if let error = error as NSError? {
                self.createErrorAlert(message: "\(error.localizedDescription)")
            }
            else {
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
