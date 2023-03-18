//
//  AddSongController.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 3/9/23.
//

import UIKit

//class Song {
//    var title : String
//    var author : String
//    var duration : String
//    var signedUrl : String
//    var fileName : String
//    var timeStamp : String
//    var thumbnail: String
//    init(title: String, author: String, duration: String, signedUrl: String, fileName: String, timeStamp: String, thumbnail: String) {
//        self.title = title
//        self.author = author
//        self.duration = duration
//        self.signedUrl = signedUrl
//        self.fileName = fileName
//        self.timeStamp = timeStamp
//        self.thumbnail = thumbnail
//    }
//
//    func toString() -> String {
//        return "\n\(title)\n\(author)\n\(duration)\n\(signedUrl)\n\(fileName)\n\(timeStamp)\n\(thumbnail)"
//    }
//}

class AddSongController: UIViewController {
    
    let reverbDict = ["Light": "7", "Medium": "8", "Heavy": "9"]
    
    @IBOutlet weak var optionalName: UITextField!
    @IBOutlet weak var optionalArtist: UITextField!
    @IBOutlet weak var youtubeLinkField: UITextField!
    @IBOutlet weak var reverbLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var bassSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pitchSlider.minimumValue = 0.5
        pitchSlider.maximumValue = 1.5
        pitchSlider.value = 1.00
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
        // clearFields()
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
    
}
