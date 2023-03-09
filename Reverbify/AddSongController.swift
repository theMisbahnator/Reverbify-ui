//
//  AddSongController.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 3/9/23.
//

import UIKit

class AddSongController: UIViewController {
    
    
    @IBOutlet weak var youtubeLinkField: UITextField!
    @IBOutlet weak var reverbLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var pitchSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pitchSlider.minimumValue = 0.5
        pitchSlider.maximumValue = 1.5
        pitchSlider.value = 1.00
    }
    
    
    @IBAction func onPitchChange(_ sender: Any) {
        pitchLabel.text = String(round(pitchSlider.value * 100) / 100)
    }
    
    @IBAction func changeReverb(_ sender: Any) {
        let alertController = UIAlertController(title: "Select Reverb", message: "Choose a reverb level:", preferredStyle: .actionSheet)

        let small = UIAlertAction(title: "Soft", style: .default) { _ in
            self.reverbLabel.text = "Soft"
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
    
}
