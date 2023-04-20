
//
//  PlaylistViewController.swift
//  Reverbify
//
//  Created by Pawan K Somavarpu on 3/25/23.
//
import UIKit
class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var playlistName: UILabel!
    @IBOutlet var numberSongs: UILabel!
    @IBOutlet weak var playlistImageView: UIImageView!
    
    var indexInDB: Int!
    var playlist: Playlist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SongTableCell", bundle: nil), forCellReuseIdentifier: "SongTableCell")
        everyLoad()
        
    }
    
    func everyLoad() {
        playlistName.text = playlist.title
        numberSongs.text = playlist.songs.count == 1 ? "\(playlist.songs.count) song" : "\(playlist.songs.count) songs"
        if self.playlist.songs.count >= 1 {
            self.playlist.thumbnailString = self.playlist.songs[0].thumbnail
        }
        if let url = URL(string: playlist.thumbnailString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    self.playlistImageView.image = UIImage(named:"music-solid")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("Error creating image from downloaded data")
                    self.playlistImageView.image = UIImage(named:"music-solid")
                    return
                }
                
                DispatchQueue.main.async {
                    //print("GOT TO CORRECT COMPLETION")
                    self.playlistImageView.image = image
                }
            }
            task.resume()
        }
        else {
            self.playlistImageView.image = UIImage(named:"music-solid")
        }
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        DatabaseClass.getAllPlaylists { playlistList in
            self.playlist = playlistList[self.playlist.indexInDB]
            self.everyLoad()
        }
        super.viewDidAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        DatabaseClass.saveThisPlaylist(playlist: self.playlist)
        super.viewWillDisappear(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? AddSongToPlaylistViewController {
            vc.playlist = self.playlist
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableCell", for: indexPath) as! SongTableCell
        let song = playlist.songs[indexPath.row]
        
        cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        cell.title.text = song.title
        cell.title.numberOfLines = 2
        cell.author.text = song.author
        cell.author.numberOfLines = 3

        //cell.thumbnail.image = image
        
        if let url = URL(string: playlist.songs[indexPath.row].thumbnail) {
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Present the next view controller
        let playSongVC = self.storyboard?.instantiateViewController(withIdentifier: "playSong") as! PlaySongController

        playSongVC.song = playlist.songs[indexPath.row]
        playSongVC.localSongQueue = SongPlayer(index: indexPath.row, songQueue: playlist.songs)
        playSongVC.localCurPlayList = playlist.title
        playlist.lastPlayed = Date().timeIntervalSinceReferenceDate
        
        
        navigationController?.pushViewController(playSongVC, animated: true)
    }
    
    // Deleting Song from Playlist, Does not Delete the Song from downloaded
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            playlist.songs.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            everyLoad()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func createErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Whoops", message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue(UIColor.red, forKey: "titleTextColor") // Set the text color to red
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        if playlist.songs.count == 0 {
            createErrorAlert(message: "Looks like you have no songs in your playlist")
        }
        else {
            tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
        }
    }
    
}
