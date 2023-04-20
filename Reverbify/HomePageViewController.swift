
//
//  ViewController.swift
//  GridView
//
//  Created by Vu Bui on 3/7/23.
//

import UIKit
import OrderedCollections
import FirebaseAuth

var songLists:[SongData] = []
var playlistLists:[PlaylistData] = []

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
//        do {
//            try Auth.auth().signOut()
//            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
//        } catch {
//            print("Sign out error")
//        }
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
        dispatchGroup.enter()
        
        // pull data
        let section_titles = ["Recently Played Songs", "Recently Downloaded", "Recently Played Playlist"]
        songLists = []
        playlistLists = []
        for section_title in section_titles {

            if section_title == "Recently Played Playlist" {
                var playListData = PlaylistData(sectionType: section_title, playlistLst: [])
                DatabaseClass.getAllPlaylists { playlistList in
                    print("GOT TO 72")
                    print(playlistList)
                    if playlistList.isEmpty {
                        return
                        
                    }
                    var lst = playlistList
                    lst.sort(by: {$0.lastPlayed > $1.lastPlayed })
                    playListData.playlistLst = lst
                    playlistLists.append(playListData)
                    self.myTable.reloadData()
                }
            }
            else {
                dispatchGroup.enter()
                DatabaseClass.getAllSongs { songs in
                    let actualSongDict = songs
                    var orderedDict:OrderedDictionary<String, Song> = [:]
                    SongReference.allSongs = songs
                    print("GOT TO 86")
                    print(songs)
                    if songs.isEmpty {
                        dispatchGroup.leave()
                        return
                    }
                    if section_title == "Recently Downloaded" {
                       let sortedArray = actualSongDict.sorted(by: {Int($0.key)! > Int($1.key)!})
                       orderedDict =  OrderedDictionary(uniqueKeysWithValues: sortedArray)
                    
                    }
                    else if section_title == "Recently Played Songs"{
                       let sortedArray = actualSongDict.sorted(by: {$0.value.lastPlayed > $1.value.lastPlayed })
                       orderedDict = OrderedDictionary(uniqueKeysWithValues: sortedArray)
                       
                    }
                    songLists.append(SongData(sectionType: section_title, songlst: orderedDict))
                    dispatchGroup.leave()
                    self.myTable.reloadData()
                }
            }
            
        }
        
        dispatchGroup.leave()
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
                let song = sender as! String
                let singleSong : [String] = [song]
                nextVC.song = SongReference.getSong(key: song)
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

