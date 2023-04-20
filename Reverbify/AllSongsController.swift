//
//  AllSongsController.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 3/18/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import OrderedCollections

class AllSongsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var loadCount = 0
    var filteredSongs: OrderedDictionary<String, Song> = [:]
    private var tapGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SongTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SongTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
//        // Add a tap gesture recognizer to the view
//       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//       view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let searchBarTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchBarTextField.text = ""
        }
        DatabaseClass.getAllSongs { songs in
            let sortedArray = songs.sorted(by: {$0.key > $1.key})
            let orderedDict = OrderedDictionary(uniqueKeysWithValues: sortedArray)
            SongReference.allSongs = songs
            self.filteredSongs = orderedDict
            self.tableView.reloadData()
        }

        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DatabaseClass.saveAllSongs(songList: SongReference.allSongs)
        super.viewWillDisappear(true)
    }
    
    private func addTapGesture() {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture!)
        }

    private func removeTapGesture() {
        if let tapGesture = tapGesture {
            view.removeGestureRecognizer(tapGesture)
            self.tapGesture = nil
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        addTapGesture()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        removeTapGesture()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // Dismiss the keyboard when the user taps outside of the search bar
    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableCell", for: indexPath as IndexPath) as! SongTableCell
        let row = indexPath.row
        let currSong = SongReference.getSong(key: self.filteredSongs.elements[row].key)
        cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        cell.title.text = currSong.title
        cell.title.numberOfLines = 2
        
        if let url = URL(string: currSong.thumbnail) {
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
        
        
        cell.author.text = currSong.author
        cell.author.numberOfLines = 3

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Present the next view controller
        let playSongVC = self.storyboard?.instantiateViewController(withIdentifier: "playSong") as! PlaySongController
        let thisSong = SongReference.getSong(key: self.filteredSongs.elements[indexPath.row].key)
        playSongVC.song = thisSong
        var index = 0
        for key in SongReference.allSongs.keys {
            if key == "count" {
                continue
            }
            let song = SongReference.getSong(key: key)
            if song.title == thisSong.title && song.author == thisSong.author {
                break
            }
            index += 1
        }
        playSongVC.localSongQueue = SongPlayer(index: index, songQueue: Array(SongReference.allSongs.keys))
        playSongVC.localCurPlayList = "allSongs"
        playSongVC.song?.setLastPlayed()
        navigationController?.pushViewController(playSongVC, animated: true)
    }
    
    // Deleting Song from downloaded
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let keyForSongToDelete = filteredSongs.elements[indexPath.row].key
            filteredSongs.removeValue(forKey: keyForSongToDelete)
            SongReference.allSongs.removeValue(forKey: keyForSongToDelete)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredSongs = [:]
        for key in SongReference.allSongs.keys {
            if key == "count" {
                continue
            }
            let song = SongReference.getSong(key: key)
            let titleMatch = song.title.lowercased().contains(searchText.lowercased())
            let authorMatch = song.author.lowercased().contains(searchText.lowercased())
            if titleMatch || authorMatch || searchText == "" {
                filteredSongs[key] = song
            }
            
        }
        tableView.reloadData()
    }
    
}
