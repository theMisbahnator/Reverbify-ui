
//
//  ViewController.swift
//  GridView
//
//  Created by Vu Bui on 3/7/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

var songLists:[SongData] = []
var playlistLists:[PlaylistData] = []
class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTable: UITableView!
    
    var database: DatabaseReference!


    override func viewDidLoad() {
        self.database = Database.database(url: "https://reverbify-b9e19-default-rtdb.firebaseio.com/").reference()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        cell.myCollectionView.tag = indexPath.section
        cell.myCollectionView.reloadData()
        cell.parentViewController = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return songLists.count + playlistLists.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section >= songLists.count {
            return playlistLists[section - songLists.count].sectionType
        }
        return songLists[section].sectionType
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Create a Dispatch Group
        let dispatchGroup = DispatchGroup()
        
        // Enter the Dispatch Group
//        dispatchGroup.enter()
        
        // pull data
        let section_titles = ["Recently Played Songs", "Recently Downloaded", "Recently Played Playlist"]
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        songLists = []
        for section_title in section_titles {
            if section_title == "Recently Played Playlist" {
                dispatchGroup.enter()
                let playlistsRef = self.database.child("users").child(currentUserID).child("playlists")
                var playListData = PlaylistData(sectionType: section_title, playlistLst: [])
                
               playlistLists = []
                // Now, you can read in the user's songs list
                playlistsRef.observeSingleEvent(of: .value, with: { snapshot in
                    var playlistList: [[String: Any]] = []
                    if let existingPlaylist = snapshot.value as? [[String: Any]] {
                        // If the user's songs list already exists, append the new song to it
                        playlistList = existingPlaylist
                        var i = 0
                        for playlist in playlistList {
                            playListData.playlistLst.append(Playlist(body: playlist, index: i))
                            i = i + 1
                        }
                        playListData.playlistLst.sort(by: {$0.lastPlayed > $1.lastPlayed })
                        playlistLists.append(playListData)
                        
                    }
                    dispatchGroup.leave()
                }) { error in
                    dispatchGroup.leave() // leave
                    print(error.localizedDescription)
                }
            }
            else {
                let songsRef = self.database.child("users").child(currentUserID).child("songs")
                
                var songlist:[Song] = []
                // Now, you can read in the user's songs list
                dispatchGroup.enter() // enter the Dispatch Group
                songsRef.observeSingleEvent(of: .value, with: { snapshot in
                    if let existingSongs = snapshot.value as? [[String: Any]] {
                        for song in existingSongs {
                            songlist.append(Song(body: song))
                        }
                        if section_title == "Recently Downloaded" {
                            songlist.reverse()
                        }
                        else if section_title == "Recently Played Songs"{
                            songlist.sort(by: {$0.lastPlayed > $1.lastPlayed })
                        }
                        songLists.append(SongData(sectionType: section_title, songlst: songlist))
                    }
                    dispatchGroup.leave() // leave the Dispatch Group
                }) { error in
                    print(error.localizedDescription)
                    dispatchGroup.leave() // leave the Dispatch Group in case of an error
                }
            }
//        let section_title = "Recently Played Playlist"
            
        }
        // Wait for the Dispatch Group to finish
        dispatchGroup.notify(queue: DispatchQueue.main) {
            // All async tasks are done
            if playlistLists.count == 0 && songLists.count == 0 {
                let alertController = UIAlertController(title: "Welcome To Reverbify!", message: "Would you like to download your first song?", preferredStyle: .alert)
                
                let stayHereAction = UIAlertAction(title: "Nope, stay here", style: .default) { (action:UIAlertAction!) in
                    // Handle "Stay Here" button tap
                }
                stayHereAction.setValue(UIColor.darkGray, forKey: "titleTextColor")
                
                let letsGoAction = UIAlertAction(title: "Yes let's go!", style: .destructive) { (action:UIAlertAction!) in
                    self.performSegue(withIdentifier: "addSongId", sender: self)
                }
                
                alertController.addAction(stayHereAction)
                alertController.addAction(letsGoAction)

                self.present(alertController, animated: true, completion:nil)
            }
            self.myTable.reloadData()
        }
        
        super.viewDidAppear(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playSong" {
            if let nextVC = segue.destination as? PlaySongController {
                let song = sender as! Song
                let singleSong : [Song] = [song]
                nextVC.song = song
                nextVC.localSongQueue = SongPlayer(index: 0, songQueue: singleSong)
                nextVC.localCurPlayList = "home page"
            }
        }
        if segue.identifier == "playPlaylist" {
            if let nextVC = segue.destination as? PlaylistViewController {
                nextVC.playlist = sender as? Playlist
            }
        }
    }

}

