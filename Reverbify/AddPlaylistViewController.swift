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
    var database: DatabaseReference!
    @IBOutlet var playlistName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.database = Database.database(url: "https://reverbify-b9e19-default-rtdb.firebaseio.com/").reference()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addPlaylist(_ sender: Any) {
        
        let newPlaylist: [String: Any] = [
            "title": playlistName.text!,
            "thumbnail": "",
            "songs": []
        ]

        // Then, you'll want to get a reference to the user's songs list
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        
        
        let playlistsRef = self.database.child("users").child(currentUserID).child("playlists")
        
        // Now, you can read in the user's songs list
        playlistsRef.observeSingleEvent(of: .value, with: { snapshot in
            var playlistList: [[String: Any]] = []
            if let existingPlaylist = snapshot.value as? [[String: Any]] {
                // If the user's songs list already exists, append the new song to it
                playlistList = existingPlaylist
            }
            playlistList.append(newPlaylist)

            // Finally, update the user's songs list in Firebase
            playlistsRef.setValue(playlistList)
        }) { error in
            print(error.localizedDescription)
        }
        
        
        self.navigationController?.popViewController(animated: true)
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
