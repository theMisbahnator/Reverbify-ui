//
//  SettingsController.swift
//  Reverbify
//
//  Created by Ayush Patel on 3/7/23.
//

import UIKit
import FirebaseAuth

class SettingsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var sliderTable: UITableView!
    @IBOutlet weak var accountSettings: UITableView!
    
    @IBOutlet weak var settingBar: UINavigationItem!
    
    var sliderList:[SliderSettings] = [SliderSettings(sliderOn: false, settingName: "Notifications")]
    
    var accountList:[AccountSettings] = [AccountSettings(settingName: "Username", settingDescrip: "Actual Username", nextIdentifier: ""), AccountSettings(settingName: "Password", settingDescrip: "Change Password", nextIdentifier: "changePasswordIdentifier")]
    
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
        sliderTable.delegate = self
        sliderTable.dataSource = self
        accountSettings.delegate = self
        accountSettings.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    //changePasswordIdentifier
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected cell
        if tableView == accountSettings {
//            let selectedCell = tableView.cellForRow(at: indexPath)
            let id = accountList[indexPath.row].nextIdentifier
            if id != "" {
                self.performSegue(withIdentifier: id, sender: self)
            }
        }
     
        
        
        
//        // Do something with the selected cell, such as displaying more information or performing an action
//        // For example, you can push a new view controller onto the navigation stack to show more information
//        let detailViewController = DetailViewController()
//        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sliderTable {
            return sliderList.count
        }
        else if tableView == accountSettings {
            return accountList.count
        }
        return 0
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sliderTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCellIdentifier", for: indexPath as IndexPath) as! SliderTableViewCell
                    let row = indexPath.row
                    
                cell.slider.isOn = sliderList[row].sliderOn
            cell.settingLabel.text = sliderList[row].settingName
                    return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingIdentifier", for: indexPath as IndexPath) as! AccountTableViewCell
                    let row = indexPath.row
            cell.settingName.text = accountList[row].settingName
            cell.settingDescription.text = accountList[row].settingDescrip
                    return cell
        }
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
    
}
