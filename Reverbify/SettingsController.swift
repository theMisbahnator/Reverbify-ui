//
//  SettingsController.swift
//  Reverbify
//
//  Created by Ayush Patel on 3/7/23.
//

import UIKit
import FirebaseAuth

class SettingsController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        logoutButton.layer.cornerRadius = 20
        logoutButton.layer.masksToBounds = true
        
        let fontSize = min(logoutButton.bounds.size.width, logoutButton.bounds.size.height) * 0.5
        
        let attributedString = NSAttributedString(string: "Logout", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)
        ])
        logoutButton.setAttributedTitle(attributedString, for: .normal)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        // signout mechanism
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        } catch {
            print("Sign out error")
        }
        
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
