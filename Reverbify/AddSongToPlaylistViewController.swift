//
//  AddSongToPlaylistViewController.swift
//  Reverbify
//
//  Created by Pawan K Somavarpu on 4/17/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddSongToPlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var database: DatabaseReference!
    var allSongs : [Song] = []
    var loadCount = 0
    var selectedSongs : [Song] = []
    
    var playlist : Playlist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SongTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SongTableCell")
        
        self.database = Database.database(url: "https://reverbify-b9e19-default-rtdb.firebaseio.com/").reference()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {

        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        
        let songsRef = self.database.child("users").child(currentUserID).child("songs")
        self.allSongs = []
        // Now, you can read in the user's songs list
        songsRef.observeSingleEvent(of: .value, with: { snapshot in
            var songsList: [[String: Any]] = []
            if let existingSongs = snapshot.value as? [[String: Any]] {
                // If the user's songs list already exists, append the new song to it
                songsList = existingSongs
                print(songsList)
                for song in songsList {
                    self.allSongs.append(Song(body: song))
                }
                if self.loadCount != self.allSongs.count {
                    self.loadCount = self.allSongs.count
                    self.tableView.reloadData()
                }
                
                        
            }

        }) { error in
            print(error.localizedDescription)
        }
        super.viewDidAppear(true)
    }
    
    @IBAction func addSongsToPlaylist(_ sender: Any) {
        // Add Songs to Playlist in DB
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        
        playlist.songs.append(contentsOf: selectedSongs)
        
        let playlistsRef = self.database.child("users").child(currentUserID).child("playlists")
        // Now, you can read in the user's songs list
        playlistsRef.observeSingleEvent(of: .value, with: { snapshot in
            var playlistsList: [[String: Any]] = []
            if let existingPlaylist = snapshot.value as? [[String: Any]] {
                // If the user's songs list already exists, append the new song to it
                playlistsList = existingPlaylist
                let currPlaylist = playlistsList[self.playlist.indexInDB]
                var currSongs = []
                if let songs = currPlaylist["songs"] as? Array<[String: Any]> {
                    currSongs = songs
                }
               
                for song in self.selectedSongs {
                    currSongs.append(song.convertToJSON())
                }
                
                playlistsList[self.playlist.indexInDB]["songs"] = currSongs
                
            }
            print(playlistsList)
            playlistsRef.setValue(playlistsList)
            
        }) { error in
            print(error.localizedDescription)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableCell", for: indexPath as IndexPath) as! SongTableCell
        let row = indexPath.row
        
        cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        cell.title.text = self.allSongs[row].title
        cell.title.numberOfLines = 2
        
        if let url = URL(string: self.allSongs[row].thumbnail) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("Error creating image from downloaded data")
                    return
                }
                
                DispatchQueue.main.async {
                    cell.thumbnail.image = image
                }
            }
            task.resume()
        }
        
        
        cell.author.text = self.allSongs[row].author
        cell.author.numberOfLines = 3
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.selectionStyle = .default
        selectedSongs.append(allSongs[indexPath.row])
        
        print("SELECTING")
        print(allSongs[indexPath.row].title)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        let index = selectedSongs.firstIndex(of: allSongs[indexPath.row])
        
        print("DESELECTING")
        print(selectedSongs[index!].title)
        
        selectedSongs.remove(at: index!)
        
        
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
