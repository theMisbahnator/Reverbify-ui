//
//  AddPlaylistViewController.swift
//  Reverbify
//
//  Created by Pawan K Somavarpu on 4/17/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddPlaylistViewController: UIViewController {
    @IBOutlet var playlistName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addPlaylist(_ sender: Any) {
        var playlist = Playlist(title: playlistName.text!, thumbnail: "", songs: [])
        DatabaseClass.addNewPlaylist(newPlaylist: playlist) {
            self.navigationController?.popViewController(animated: true)
        }
    }

}
