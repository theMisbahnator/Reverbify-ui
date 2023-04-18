//
//  AllPlaylistsViewController.swift
//  Reverbify
//
//  Created by Pawan K Somavarpu on 3/25/23.
//
import UIKit
import FirebaseDatabase
import FirebaseAuth


class AllPlaylistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var loadCount = 0
    var database: DatabaseReference!
    @IBOutlet var tableView: UITableView!
    var allPlaylists : [Playlist] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.database = Database.database(url: "https://reverbify-b9e19-default-rtdb.firebaseio.com/").reference()
        let nib = UINib(nibName: "SongTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SongTableCell")
        
        // create dummy data
        allPlaylists.append(Playlist(title: "Playlist #1", thumbnail: "https://img.youtube.com/vi/V7UgPHjN9qE/sddefault.jpg", songs: []))
        allPlaylists[0].songs.append(Song(title: "Drake ft. 21 Savage - Jimmy Cooks (Official Audio)", author: "DrakeVEVO", duration: "3:38", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/bass_rev_6_misbah_2023-03-23_23%3A27%3A34.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T232805Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=36687a26d261dd1bc652a93bf9ac14dd869b951f71b2baba29c29add0d65a63a", fileName: "bass_rev_6_misbah_2023-03-23_23:27:34.mp3", timeStamp: "2023-03-23_23:28:05", thumbnail: "https://img.youtube.com/vi/V7UgPHjN9qE/sddefault.jpg"))
        allPlaylists[0].songs.append(Song(title: "Drake ft. 21 Savage - Jimmy Cooks (Official Audio)", author: "DrakeVEVO", duration: "3:38", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/bass_rev_6_misbah_2023-03-23_23%3A27%3A34.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T232805Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=36687a26d261dd1bc652a93bf9ac14dd869b951f71b2baba29c29add0d65a63a", fileName: "bass_rev_6_misbah_2023-03-23_23:27:34.mp3", timeStamp: "2023-03-23_23:28:05", thumbnail: "https://img.youtube.com/vi/V7UgPHjN9qE/sddefault.jpg"))
        allPlaylists[0].songs.append(Song(title: "Drake ft. 21 Savage - Jimmy Cooks (Official Audio)", author: "DrakeVEVO", duration: "3:38", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/bass_rev_6_misbah_2023-03-23_23%3A27%3A34.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T232805Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=36687a26d261dd1bc652a93bf9ac14dd869b951f71b2baba29c29add0d65a63a", fileName: "bass_rev_6_misbah_2023-03-23_23:27:34.mp3", timeStamp: "2023-03-23_23:28:05", thumbnail: "https://img.youtube.com/vi/V7UgPHjN9qE/sddefault.jpg"))
        
        allPlaylists.append(Playlist(title: "Playlist #2", thumbnail: "https://img.youtube.com/vi/r9_qDBnOuas/sddefault.jpg", songs: []))
        allPlaylists[1].songs.append(Song(title: "Drake ft. 21 Savage - Jimmy Cooks (Official Audio)", author: "DrakeVEVO", duration: "3:38", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/bass_rev_6_misbah_2023-03-23_23%3A27%3A34.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T232805Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=36687a26d261dd1bc652a93bf9ac14dd869b951f71b2baba29c29add0d65a63a", fileName: "bass_rev_6_misbah_2023-03-23_23:27:34.mp3", timeStamp: "2023-03-23_23:28:05", thumbnail: "https://img.youtube.com/vi/V7UgPHjN9qE/sddefault.jpg"))
        allPlaylists[0].songs.append(Song(title: "The Wishing Tree", author: "The Kings Singers this is a really long title let see if this is gonna wrap", duration: "4:19", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/rev_6_misbah_2023-03-23_23%3A25%3A46.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T232614Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=9e0e6cab6b7dd2e3cccb19433ed0c9c6db98193ec1fc1638ea45895d15c6aa26", fileName: "rev_6_misbah_2023-03-23_23:25:46.mp", timeStamp: "2023-03-23_23:26:14", thumbnail: "https://img.youtube.com/vi/r9_qDBnOuas/sddefault.jpg"))
        allPlaylists[0].songs.append(Song(title: "Juice WRLD - Lucid Dreams (Directed by Cole Bennett)", author: "Lyrical Lemonade", duration: "4:30", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/rev_6_misbah_2023-03-23_23%3A30%3A15.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T233042Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=1b91ed02a80ed7ba36561885531ad0498f308153f77b33c20a5fb96ffcd39a61", fileName: "rev_6_misbah_2023-03-23_23:30:15.mp3", timeStamp: "2023-03-23_23:30:42", thumbnail: "https://img.youtube.com/vi/mzB1VGEGcSU/sddefault.jpg"))
        
        
//        allSongs.append(Song(title: "The Wishing Tree", author: "The Kings Singers this is a really long title let see if this is gonna wrap", duration: "4:19", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/rev_6_misbah_2023-03-23_23%3A25%3A46.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T232614Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=9e0e6cab6b7dd2e3cccb19433ed0c9c6db98193ec1fc1638ea45895d15c6aa26", fileName: "rev_6_misbah_2023-03-23_23:25:46.mp", timeStamp: "2023-03-23_23:26:14", thumbnail: "https://img.youtube.com/vi/r9_qDBnOuas/sddefault.jpg"))
//
//        allSongs.append(Song(title: "Juice WRLD - Lucid Dreams (Directed by Cole Bennett)", author: "Lyrical Lemonade", duration: "4:30", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/rev_6_misbah_2023-03-23_23%3A30%3A15.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T233042Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=1b91ed02a80ed7ba36561885531ad0498f308153f77b33c20a5fb96ffcd39a61", fileName: "rev_6_misbah_2023-03-23_23:30:15.mp3", timeStamp: "2023-03-23_23:30:42", thumbnail: "https://img.youtube.com/vi/mzB1VGEGcSU/sddefault.jpg"))
//
//        allSongs.append(Song(title: "Bane", author: "Destroy Lonely - Topic", duration: "2:02", signedUrl: "https://reverbify.s3.us-east-2.amazonaws.com/rev_3_misbah_2023-03-23_23%3A32%3A09.mp3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYL6E4JFR23PADVVB%2F20230323%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20230323T233224Z&X-Amz-Expires=594720&X-Amz-SignedHeaders=host&X-Amz-Signature=1002d551e5770b3ddf8fc3a150c09966b5d2be4878729da82225e20d754f9fad", fileName: "rev_3_misbah_2023-03-23_23:32:09.mp3", timeStamp: "2023-03-23_23:32:24", thumbnail: "https://img.youtube.com/vi/fe-CdBzr9Kg/sddefault.jpg"))
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlaylists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableCell", for: indexPath as IndexPath) as! SongTableCell
        let row = indexPath.row
        
        cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        cell.title.text = allPlaylists[row].title
        if let url = URL(string: allPlaylists[row].thumbnailString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    cell.thumbnail.image = UIImage(named:"music-solid")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("Error creating image from downloaded data")
                    cell.thumbnail.image = UIImage(named:"music-solid")
                    return
                }
                
                DispatchQueue.main.async {
                    //print("GOT TO CORRECT COMPLETION")
                    cell.thumbnail.image = image
                }
            }
            task.resume()
        }
        else {
            cell.thumbnail.image = UIImage(named:"music-solid")
        }
        
        cell.author.text = "\(allPlaylists[row].songs.count) songs"
        cell.author.numberOfLines = 3
        
        print(allPlaylists[row].toString())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Present the next view controller
        let playlistVC = self.storyboard?.instantiateViewController(withIdentifier: "playlist") as! PlaylistViewController

        playlistVC.playlist = allPlaylists[indexPath.row]
        
        navigationController?.pushViewController(playlistVC, animated: true)
    }
    
    // Deleting Playlist from AllPlaylists
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            allPlaylists.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidLoad()
//        
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        
        let playlistsRef = self.database.child("users").child(currentUserID).child("playlists")
        self.allPlaylists = []
        // Now, you can read in the user's songs list
        playlistsRef.observeSingleEvent(of: .value, with: { snapshot in
            var playlistList: [[String: Any]] = []
            if let existingPlaylist = snapshot.value as? [[String: Any]] {
                // If the user's songs list already exists, append the new song to it
                playlistList = existingPlaylist
                var i = 0
                for playlist in playlistList {
                    self.allPlaylists.append(Playlist(body: playlist, index: i))
                    i = i + 1
                }
                self.tableView.reloadData()
            }
        }) { error in
            print(error.localizedDescription)
        }
        super.viewDidAppear(true);
        tableView.reloadData()
        
        
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
