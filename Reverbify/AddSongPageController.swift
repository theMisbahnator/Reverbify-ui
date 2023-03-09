//
//  AddSongPageController.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 3/7/23.
//

import UIKit

class Song {
    var title: String
    var author: String
    var duration: String
    var timestamp: String

    init(title: String, author: String, duration: String, timestamp: String) {
        self.title = title
        self.author = author
        self.duration = duration
        self.timestamp = timestamp
    }
}

class AddSongPageController: UIViewController {

    let reverbDict = ["Small": "7", "Medium": "8", "Large": "9"]
    @IBOutlet weak var youtubeLinkField: UITextField!
    @IBOutlet weak var songNameOptional: UITextField!
    @IBOutlet weak var artistNameOptional: UITextField!
    @IBOutlet weak var bassBoostSwitch: UISwitch!
    @IBOutlet weak var reverbLabel: UILabel!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var pitchLabel: UILabel!

    var song:Song!

    override func viewDidLoad() {
        super.viewDidLoad()
        pitchSlider.minimumValue = 0.5
        pitchSlider.maximumValue = 1.5
        pitchSlider.value = 1.00
        self.song = Song(title: "", author: "", duration: "", timestamp:"")
    }
    
    
    @IBAction func onReverbSelect(_ sender: Any) {
                let alertController = UIAlertController(title: "Select Reverb", message: "Choose a reverb level:", preferredStyle: .actionSheet)
                let small = UIAlertAction(title: "Small", style: .default) { _ in
                    self.reverbLabel.text = "Small"
                    self.reverbLabel.textColor = UIColor.black
                }
                alertController.addAction(small)
        
                let medium = UIAlertAction(title: "Medium", style: .default) { _ in
                    self.reverbLabel.text = "Medium"
                    self.reverbLabel.textColor = UIColor.black
                }
                alertController.addAction(medium)
                let large = UIAlertAction(title: "Large", style: .default) { _ in
                    self.reverbLabel.text = "Large"
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
    
    
    @IBAction func onPitchChange(_ sender: Any) {
    }
    
    @IBAction func onBoostSelect(_ sender: Any) {
    }
    
    @IBAction func onSubmit(_ sender: Any) {
    }
    //    @IBAction func onReverbSelect(_ sender: Any) {
//        let alertController = UIAlertController(title: "Select Reverb", message: "Choose a reverb level:", preferredStyle: .actionSheet)
//
//        let small = UIAlertAction(title: "Small", style: .default) { _ in
//            self.reverbLabel.text = "Small"
//            self.reverbLabel.textColor = UIColor.black
//        }
//        alertController.addAction(small)
//
//        let medium = UIAlertAction(title: "Medium", style: .default) { _ in
//            self.reverbLabel.text = "Medium"
//            self.reverbLabel.textColor = UIColor.black
//        }
//        alertController.addAction(medium)
//        let large = UIAlertAction(title: "Large", style: .default) { _ in
//            self.reverbLabel.text = "Large"
//            self.reverbLabel.textColor = UIColor.black
//        }
//        alertController.addAction(large)
//
//        let none = UIAlertAction(title: "None", style: .default) { _ in
//            self.reverbLabel.text = "None"
//            self.reverbLabel.textColor = UIColor.gray
//        }
//        alertController.addAction(none)
//        present(alertController, animated: true, completion: nil)
//    }

//    @IBAction func onPitchChange(_ sender: Any) {
//        pitchLabel.text = String(round(pitchSlider.value * 100) / 100)
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AllSongsSegue" {
            // songsList.append(self.song)
        }
    }

//    @IBAction func onSubmit(_ sender: Any) {
//        if youtubeLinkField.text == "" {
//            errorLabel.text = "Youtube Link not entered. "
//            return
//        }
//        errorLabel.text = ""
//
//
//        let urlString = "https://reverbify-backend-klfqvexjrq-vp.a.run.app/reverb-song"
//
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//
//        // Define the request body data
//        let jsonObject: [String: Any] = [
//            "url": youtubeLinkField.text!,
//            "pitch": pitchLabel.text!,
//            "bass": [
//                "change": bassBoostSlider.isOn,
//                "centerFreq": "60",
//                "filterWidth": "50",
//                "gain": "8"
//            ],
//            "reverb": reverbDict[reverbLabel.text!] ?? "0"
//        ]
//
//        print(jsonObject)
//
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
//            print(jsonData)
//            print("hello")
//            // Create the request
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.httpBody = jsonData
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//            // Create the session
//            let session = URLSession.shared
//
//    //        let alertController = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
//    //        present(alertController, animated: true, completion: nil)
//
//            let task = session.dataTask(with: request) { data, response, error in
//    //            let alertController = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
//    //            self.present(alertController, animated: true, completion: nil)
//                if let error = error {
//                    print("Error: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    print("Invalid response")
//                    return
//                }
//
//                print("Response status code: \(httpResponse.statusCode)")
//                if let responseData = data {
//                    var resp = "Response data: \(String(data: responseData, encoding: .utf8) ?? "Unable to convert data to string")"
//                    print(resp)
//
//                    self.song.title = "title"
//                    self.song.author = "author"
//                    self.song.duration = "duration"
//                    self.song.timestamp = "timestamp"
//                    self.performSegue(withIdentifier: "AllSongsSegue", sender: nil)
//                }
//
//
//    //            alertController.dismiss(animated: true, completion: nil)
//            }
//
//            // Start the task
//            task.resume()
//        } catch {
//            errorLabel.text = "Invalid Request Body"
//        }
//    }
}
