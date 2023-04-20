//
//  AddPlaylistViewController.swift
//  Reverbify
//
//  Created by Pawan K Somavarpu on 4/17/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddPlaylistViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var playlistName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistName.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addPlaylist(_ sender: Any) {
        let playlist = Playlist(title: playlistName.text!, thumbnail: "", songs: [])
        DatabaseClass.addNewPlaylist(newPlaylist: playlist) {
            self.navigationController?.popViewController(animated: true)
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
