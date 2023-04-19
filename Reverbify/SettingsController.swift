//
//  SettingsController.swift
//  Reverbify
//
//  Created by Ayush Patel on 3/7/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import UserNotifications


class SettingsController: UIViewController, UITableViewDataSource, UITableViewDelegate, SliderCellDelegate {
   
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var sliderTable: UITableView!
    @IBOutlet weak var accountSettings: UITableView!
    @IBOutlet weak var settingBar: UINavigationItem!
    @IBOutlet weak var saveButton: UIButton!
    
    var database: DatabaseReference!
    var sliderList:[SliderSettings] = []
    var accountList:[AccountSettings] = []
    
    override func viewWillAppear(_ animated: Bool) {

        
        logoutButton.layer.cornerRadius = 20
        logoutButton.layer.masksToBounds = true
        
        var fontSize = min(logoutButton.bounds.size.width, logoutButton.bounds.size.height) * 0.5
        
        var attributedString = NSAttributedString(string: "Logout", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)
        ])
        logoutButton.setAttributedTitle(attributedString, for: .normal)
        
        saveButton.layer.cornerRadius = 20
        saveButton.layer.masksToBounds = true
        
        fontSize = min(saveButton.bounds.size.width, saveButton.bounds.size.height) * 0.5
        
        attributedString = NSAttributedString(string: "Save", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)
        ])
        saveButton.setAttributedTitle(attributedString, for: .normal)
        
        
        NSLayoutConstraint.activate([
            saveButton.widthAnchor.constraint(equalTo: logoutButton.widthAnchor),
            saveButton.heightAnchor.constraint(equalTo: logoutButton.heightAnchor)
        ])
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        self.sliderList = [SliderSettings(sliderOn: false, settingName: "Notifications"), SliderSettings(sliderOn: false, settingName: "Autoplay")]
        let notifRef = self.database.child("users").child(currentUserID).child("notifOn")
      
        // Now, you can read in the user's songs list
        notifRef.observeSingleEvent(of: .value, with: { snapshot in
                if let value = snapshot.value as? Bool {
                    // Handle the boolean value here
                    self.sliderList[0].sliderOn = value
                    self.sliderTable.reloadData()
                    // Check the boolean value and enable or disable the notification accordingly
                    if self.sliderList[0].sliderOn {
                        self.scheduleNotification()
                    } else {
                        self.removeNotification()
                    }
                }
            }) { error in
                print(error.localizedDescription)
            }
        let autoplayRef = self.database.child("users").child(currentUserID).child("autoplayOn")
      
        // Now, you can read in the user's songs list
        autoplayRef.observeSingleEvent(of: .value, with: { snapshot in
                if let value = snapshot.value as? Bool {
                    // Handle the boolean value here
                    self.sliderList[1].sliderOn = value
                    self.sliderTable.reloadData()
                }
            }) { error in
                print(error.localizedDescription)
            }

        super.viewWillAppear(true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.database = Database.database(url: "https://reverbify-b9e19-default-rtdb.firebaseio.com/").reference()
        sliderTable.delegate = self
        sliderTable.dataSource = self
        accountSettings.delegate = self
        accountSettings.dataSource = self
        // get actual email
        let user = Auth.auth().currentUser
        let userEmail = user?.email
        self.accountList = [AccountSettings(settingName: "Email", settingDescrip: userEmail ?? "No email found", nextIdentifier: ""), AccountSettings(settingName: "Password", settingDescrip: "Click here to change your password", nextIdentifier: "changePasswordIdentifier")]
        // Request permission to display notifications (usually done in app delegate)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    //changePasswordIdentifier
    func sliderValueChanged(_ value: Bool, forCell cell: SliderTableViewCell) {
        guard let indexPath = sliderTable.indexPath(for: cell) else { return }
        sliderList[indexPath.row].sliderOn = value

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected cell
        if tableView == accountSettings {
//            let selectedCell = tableView.cellForRow(at: indexPath)
            let id = accountList[indexPath.row].nextIdentifier
            if id != "" {
                self.performSegue(withIdentifier: id, sender: self)
            }
        }
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
            cell.delegate = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingIdentifier", for: indexPath as IndexPath) as! AccountTableViewCell
                let row = indexPath.row
            cell.settingName.text = accountList[row].settingName
            cell.settingDescription.text = accountList[row].settingDescrip
            cell.tintColor = UIColor.lightGray
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
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        print("GOT HERE")
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        
        let notifRef = self.database.child("users").child(currentUserID).child("notifOn")
        // Now, you can read in the user's songs list
        notifRef.observeSingleEvent(of: .value, with: { snapshot in
            notifRef.setValue(self.sliderList[0].sliderOn)
            
        }) { error in
            print(error.localizedDescription)
        }
        
        let autoplayRef = self.database.child("users").child(currentUserID).child("autoplayOn")
        // Now, you can read in the user's songs list
        autoplayRef.observeSingleEvent(of: .value, with: { snapshot in
            autoplayRef.setValue(self.sliderList[1].sliderOn)
            
        }) { error in
            print(error.localizedDescription)
        }
   
        // Check the boolean value and enable or disable the notification accordingly
        if sliderList[0].sliderOn {
            scheduleNotification()
        } else {
            removeNotification()
        }

        createSaveAlert(message: "Save Successful!")
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reverbify"
        content.body = "Your free music player awaits!"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 15
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 8, repeats: false)
        
        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
        
        // Check if the notification has already been scheduled
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            let hasScheduledNotification = requests.contains { $0.identifier == request.identifier }
            guard !hasScheduledNotification else { return }
            
            // Schedule the notification
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    // Remove the notification request with the specified identifier
    func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyNotification"])
    }
    
    func createSaveAlert(message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue(UIColor.red, forKey: "titleTextColor") // Set the text color to red
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
