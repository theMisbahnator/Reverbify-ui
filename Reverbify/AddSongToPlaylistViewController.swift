//
//  AddSongToPlaylistViewController.swift
//  Reverbify
//
//  Created by Pawan K Somavarpu on 4/17/23.
//

import UIKit

class AddSongToPlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var loadCount = 0
    var selectedSongs : [String] = []
    
    var playlist : Playlist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SongTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SongTableCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DatabaseClass.getAllSongs { songs in
            SongReference.allSongs = songs
            self.tableView.reloadData()
        }
        
        super.viewWillAppear(true)
    }
    
    @IBAction func addSongsToPlaylist(_ sender: Any) {

        DatabaseClass.addSongstoPlaylist(selectedSongs: selectedSongs, playlistIndex: self.playlist.indexInDB)

        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SongReference.allSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableCell", for: indexPath as IndexPath) as! SongTableCell
        let row = indexPath.row
        
        var song = SongReference.allSongs.elements[row].value
        cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        cell.title.text = song.title
        cell.title.numberOfLines = 2
        
        if let url = URL(string: song.thumbnail) {
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
        
        
        cell.author.text = song.author
        cell.author.numberOfLines = 3
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.selectionStyle = .default
        selectedSongs.append(SongReference.allSongs.elements[indexPath.row].key)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        let index = selectedSongs.firstIndex(of: SongReference.allSongs.elements[indexPath.row].key)
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
