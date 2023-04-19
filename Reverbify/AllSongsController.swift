//
//  AllSongsController.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 3/18/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class AllSongsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var loadCount = 0
    var database: DatabaseReference!
    var allSongs : [Song] = []
    var filteredSongs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SongTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SongTableCell")
        
        self.database = Database.database(url: "https://reverbify-b9e19-default-rtdb.firebaseio.com/").reference()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
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
                    let thisSong = Song(body: song)
                    self.allSongs.append(thisSong)
                    self.filteredSongs.append(thisSong)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        
        let songsRef = self.database.child("users").child(currentUserID).child("songs")
        // Now, you can read in the user's songs list
        songsRef.observeSingleEvent(of: .value, with: { snapshot in
            var songsList: [[String: Any]] = []
            for song in self.allSongs {
                songsList.append(song.convertToJSON())
            }
            songsRef.setValue(songsList)
        }) { error in
            print(error.localizedDescription)
        }
   
        super.viewWillDisappear(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableCell", for: indexPath as IndexPath) as! SongTableCell
        let row = indexPath.row
        
        cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        cell.title.text = self.filteredSongs[row].title
        cell.title.numberOfLines = 2
        
        if let url = URL(string: self.filteredSongs[row].thumbnail) {
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
        
        
        cell.author.text = self.filteredSongs[row].author
        cell.author.numberOfLines = 3

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Present the next view controller
        let playSongVC = self.storyboard?.instantiateViewController(withIdentifier: "playSong") as! PlaySongController

        let thisSong = self.filteredSongs[indexPath.row]
        playSongVC.song = thisSong
        var index = 0
        for song in allSongs {
            if song.title == thisSong.title && song.author == thisSong.author {
                break
            }
            index += 1
        }
        playSongVC.localSongQueue = SongPlayer(index: index, songQueue: allSongs)
        playSongVC.localCurPlayList = "allSongs"
        playSongVC.song?.lastPlayed = Date().timeIntervalSinceReferenceDate
        navigationController?.pushViewController(playSongVC, animated: true)
    }
    
    // Deleting Song from downloaded
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            filteredSongs.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredSongs = allSongs.filter({ song in
            let titleMatch = song.title.lowercased().contains(searchText.lowercased())
            let authorMatch = song.author.lowercased().contains(searchText.lowercased())
            return titleMatch || authorMatch || searchText == ""
        })
        
        tableView.reloadData()
    }
    
}
