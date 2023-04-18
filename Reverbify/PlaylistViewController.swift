
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
    
    
    var playlist: Playlist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SongTableCell", bundle: nil), forCellReuseIdentifier: "SongTableCell")
        
        playlistName.text = playlist.title
        numberSongs.text = playlist.songs.count == 1 ? "\(playlist.songs.count) song" : "\(playlist.songs.count) songs"
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
        
        navigationController?.pushViewController(playSongVC, animated: true)
    }
    
    // Deleting Song from Playlist, Does not Delete the Song from downloaded
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            playlist.songs.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
}
