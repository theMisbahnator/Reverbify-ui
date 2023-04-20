//
//  AddSongController.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 3/9/23.
//

import UIKit

class AddSongController: UIViewController, UITextFieldDelegate {
    
    let reverbDict = ["Light": "7", "Medium": "8", "Heavy": "9"]
    
    @IBOutlet weak var optionalName: UITextField!
    @IBOutlet weak var optionalArtist: UITextField!
    @IBOutlet weak var youtubeLinkField: UITextField!
    @IBOutlet weak var reverbLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var bassSwitch: UISwitch!
    
    var tapGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pitchSlider.minimumValue = 0.5
        pitchSlider.maximumValue = 1.5
        pitchSlider.value = 1.00
        
        youtubeLinkField.delegate = self
        optionalName.delegate = self
        optionalArtist.delegate = self
    }
    
    
    @IBAction func onPitchChange(_ sender: Any) {
        pitchLabel.text = String(round(pitchSlider.value * 100) / 100)
    }
    
    
    @IBAction func onBassClick(_ sender: Any) {
        bassSwitch.setOn(!bassSwitch.isOn, animated: true)
    }
    
    @IBAction func changeReverb(_ sender: Any) {
        let alertController = UIAlertController(title: "Select Reverb", message: "Choose a reverb level:", preferredStyle: .actionSheet)

        let small = UIAlertAction(title: "Light", style: .default) { _ in
            self.reverbLabel.text = "Light"
            self.reverbLabel.textColor = UIColor.black
        }
        alertController.addAction(small)

        let medium = UIAlertAction(title: "Medium", style: .default) { _ in
            self.reverbLabel.text = "Medium"
            self.reverbLabel.textColor = UIColor.black
        }
        alertController.addAction(medium)
        let large = UIAlertAction(title: "Heavy", style: .default) { _ in
            self.reverbLabel.text = "Heavy"
            self.reverbLabel.textColor = UIColor.black
        }
        alertController.addAction(large)

        let none = UIAlertAction(title: "None", style: .default) { _ in
            self.reverbLabel.text = "None"
            self.reverbLabel.textColor = UIColor.gray
        }
        alertController.addAction(none)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        let postController = ReverbifyAPIHandler(userName: "misbah", view: self, controller: self)
        
        if youtubeLinkField.text == "" {
            postController.createErrorPopup(msg: "Please enter a Youtube link.")
            return
        }
        
        postController.postReverbRequest(youtubeLink: youtubeLinkField.text!, pitch: pitchLabel.text!, bass: bassSwitch.isOn, reverb: reverbDict[reverbLabel.text!] ?? "0", optionalName: optionalName.text!, optionalAuthor: optionalArtist.text!)
    }
    
    func clearFields() {
        youtubeLinkField.text = ""
        pitchLabel.text = "1.00"
        bassSwitch.isOn = false
        self.reverbLabel.text = "None"
        pitchSlider.value = 1.00
        optionalName.text = ""
        optionalArtist.text = ""
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
          addTapGesture()
      }
    
    // Called when the user clicks on the view outside of the UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            youtubeLinkField.resignFirstResponder()
            optionalName.resignFirstResponder()
            optionalArtist.resignFirstResponder()
           removeTapGesture()
           return true
       }
       
       @objc func dismissKeyboard() {
           youtubeLinkField.resignFirstResponder()
           optionalName.resignFirstResponder()
           optionalArtist.resignFirstResponder()
           removeTapGesture()
       }
       
       func addTapGesture() {
           if tapGesture == nil {
               tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
               view.addGestureRecognizer(tapGesture!)
           }
       }
       
       func removeTapGesture() {
           if let gesture = tapGesture {
               view.removeGestureRecognizer(gesture)
               tapGesture = nil
           }
       }
    
}
