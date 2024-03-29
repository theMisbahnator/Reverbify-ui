//
//  ChangePasswordController.swift
//  Reverbify
//
//  Created by Ayush Patel on 4/2/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class ChangePasswordController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentPasswordField.text = ""
        confirmPasswordField.text = ""
        newPasswordField.text = ""
        
        currentPasswordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
        newPasswordField.isSecureTextEntry = true
        
        saveButton.layer.cornerRadius = 20
        saveButton.layer.masksToBounds = true
        
        var fontSize = min(saveButton.bounds.size.width, saveButton.bounds.size.height) * 0.5
        
        var attributedString = NSAttributedString(string: "Save", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)
        ])
        saveButton.setAttributedTitle(attributedString, for: .normal)
        
        cancelButton.layer.cornerRadius = 20
        cancelButton.layer.masksToBounds = true
        
        fontSize = min(cancelButton.bounds.size.width, cancelButton.bounds.size.height) * 0.5
        
        attributedString = NSAttributedString(string: "Cancel", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)
        ])
        cancelButton.setAttributedTitle(attributedString, for: .normal)
        
        
        NSLayoutConstraint.activate([
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            saveButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor)
        ])
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPasswordField.delegate = self
        newPasswordField.delegate = self
        confirmPasswordField.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    func createErrorAlert(message: String) {
        var title = "Error"
        if message == "Password updated successfully!" {
            title = "Congrats"
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue(UIColor.red, forKey: "titleTextColor") // Set the text color to red
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        // check if current password == actual current password
        guard let oldPassword = currentPasswordField.text else {
            createErrorAlert(message: "Please enter your current password")
            return
        }
        guard let newPassword = newPasswordField.text else {
            createErrorAlert(message: "Please enter a new password")
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: oldPassword)

        // Reauthenticate the user with their current password
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                self.createErrorAlert(message: "\(error.localizedDescription)")
                return
            }
        }
            
        guard let confirmPassword = confirmPasswordField.text else {
            createErrorAlert(message: "Please confirm your new password")
            return
        }
        
        if newPassword != confirmPassword {
            createErrorAlert(message: "New passwords do not match")
            return
        }
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error as NSError?  {
                self.createErrorAlert(message: "\(error.localizedDescription)")
            }
            else {
                self.createErrorAlert(message: "Password updated successfully!")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
