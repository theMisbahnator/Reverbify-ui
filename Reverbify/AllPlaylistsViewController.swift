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
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        
        let playlistsRef = self.database.child("users").child(currentUserID).child("playlists")
        // Now, you can read in the user's songs list
        playlistsRef.observeSingleEvent(of: .value, with: { snapshot in
            var playlistList: [[String: Any]] = []
            for playlist in self.allPlaylists {
                playlistList.append(playlist.convertToJSON())
            }
            playlistsRef.setValue(playlistList)
        }) { error in
            print(error.localizedDescription)
        }
   
        super.viewWillDisappear(true)
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
