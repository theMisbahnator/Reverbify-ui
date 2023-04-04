
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
var playlistLists:[PlaylistData] = [
    PlaylistData(sectionType: "Recently Played Playlist", playlistLst: [Playlist(title: "Playlist #1", thumbnail: "https://img.youtube.com/vi/V7UgPHjN9qE/sddefault.jpg", songs: [])
    ]
    )

]

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTable: UITableView!
    
    var database: DatabaseReference!


    override func viewDidLoad() {
        self.database = Database.database(url: "https://reverbify-b9e19-default-rtdb.firebaseio.com/").reference()
        playlistLists[0].playlistLst[0].songs.append(Song(title: "Drake ft. 21 Savage - Jimmy Cooks (Official Audio)", author: "DrakeVEVO", duration: "3:38", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/bass_rev_6_misbah_2023-03-23_23%3A27%3A34.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T232805Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=36687a26d261dd1bc652a93bf9ac14dd869b951f71b2baba29c29add0d65a63a", fileName: "bass_rev_6_misbah_2023-03-23_23:27:34.mp3", timeStamp: "2023-03-23_23:28:05", thumbnail: "https://img.youtube.com/vi/V7UgPHjN9qE/sddefault.jpg"))
        playlistLists[0].playlistLst[0].songs.append(Song(title: "Drake ft. 21 Savage - Jimmy Cooks (Official Audio)", author: "DrakeVEVO", duration: "3:38", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/bass_rev_6_misbah_2023-03-23_23%3A27%3A34.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T232805Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=36687a26d261dd1bc652a93bf9ac14dd869b951f71b2baba29c29add0d65a63a", fileName: "bass_rev_6_misbah_2023-03-23_23:27:34.mp3", timeStamp: "2023-03-23_23:28:05", thumbnail: "https://img.youtube.com/vi/V7UgPHjN9qE/sddefault.jpg"))
        playlistLists[0].playlistLst[0].songs.append(Song(title: "Drake ft. 21 Savage - Jimmy Cooks (Official Audio)", author: "DrakeVEVO", duration: "3:38", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/bass_rev_6_misbah_2023-03-23_23%3A27%3A34.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T232805Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=36687a26d261dd1bc652a93bf9ac14dd869b951f71b2baba29c29add0d65a63a", fileName: "bass_rev_6_misbah_2023-03-23_23:27:34.mp3", timeStamp: "2023-03-23_23:28:05", thumbnail: "https://img.youtube.com/vi/V7UgPHjN9qE/sddefault.jpg"))
        
        playlistLists[0].playlistLst.append(Playlist(title: "Playlist #2", thumbnail: "https://img.youtube.com/vi/r9_qDBnOuas/sddefault.jpg", songs: []))
        
        playlistLists[0].playlistLst[1].songs.append(Song(title: "Drake ft. 21 Savage - Jimmy Cooks (Official Audio)", author: "DrakeVEVO", duration: "3:38", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/bass_rev_6_misbah_2023-03-23_23%3A27%3A34.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T232805Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=36687a26d261dd1bc652a93bf9ac14dd869b951f71b2baba29c29add0d65a63a", fileName: "bass_rev_6_misbah_2023-03-23_23:27:34.mp3", timeStamp: "2023-03-23_23:28:05", thumbnail: "https://img.youtube.com/vi/V7UgPHjN9qE/sddefault.jpg"))
        playlistLists[0].playlistLst[1].songs.append(Song(title: "The Wishing Tree", author: "The Kings Singers this is a really long title let see if this is gonna wrap", duration: "4:19", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/rev_6_misbah_2023-03-23_23%3A25%3A46.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T232614Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=9e0e6cab6b7dd2e3cccb19433ed0c9c6db98193ec1fc1638ea45895d15c6aa26", fileName: "rev_6_misbah_2023-03-23_23:25:46.mp", timeStamp: "2023-03-23_23:26:14", thumbnail: "https://img.youtube.com/vi/r9_qDBnOuas/sddefault.jpg"))
        playlistLists[0].playlistLst[1].songs.append(Song(title: "Juice WRLD - Lucid Dreams (Directed by Cole Bennett)", author: "Lyrical Lemonade", duration: "4:30", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/rev_6_misbah_2023-03-23_23%3A30%3A15.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T233042Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=1b91ed02a80ed7ba36561885531ad0498f308153f77b33c20a5fb96ffcd39a61", fileName: "rev_6_misbah_2023-03-23_23:30:15.mp3", timeStamp: "2023-03-23_23:30:42", thumbnail: "https://img.youtube.com/vi/mzB1VGEGcSU/sddefault.jpg"))
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        // Create a Dispatch Group
        let dispatchGroup = DispatchGroup()
        
        // Enter the Dispatch Group
//        dispatchGroup.enter()
        
        // pull data
        let section_titles = ["Recently Played Playlist", "Recently Played Songs", "Recently Downloaded"]
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        songLists = []
        for section_title in section_titles {
            if section_title == "Recently Played Playlist" {
                continue
            }
//        let section_title = "Recently Played Playlist"
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
                    songLists.append(SongData(sectionType: section_title, songlst: songlist))
                }
                dispatchGroup.leave() // leave the Dispatch Group
            }) { error in
                print(error.localizedDescription)
                dispatchGroup.leave() // leave the Dispatch Group in case of an error
            }
        }
        // Wait for the Dispatch Group to finish
        dispatchGroup.notify(queue: DispatchQueue.main) {
            // All async tasks are done
            self.myTable.reloadData()
        }
        
        super.viewWillAppear(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playSong" {
            if let nextVC = segue.destination as? PlaySongController {
                nextVC.song = sender as? Song
            }
        }
        if segue.identifier == "playPlaylist" {
            if let nextVC = segue.destination as? PlaylistViewController {
                nextVC.playlist = sender as? Playlist
            }
        }
    }

}

