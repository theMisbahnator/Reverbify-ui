//
//  HopePageViewController.swift
//  Reverbify
//
//  Created by Vu Bui on 3/6/23.
//

import UIKit

public let songs = [
    "All of The Lights", "Flowers", "Die For You",
    "Kill Bill", "Calm Down", "As It Was",
    "Just Wanna Rock", "Love Again", "Here With Me"]

public let artists = [
    "Kayne West", "Miley Cyrus", "The Weeknd",
    "SZA", "Rema", "Harry Styles",
    "Lil Uzi Vert", "The Kid LAROI", "d4vd"]


class HomeController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let textCellIdentifier = "TextCell"
    let songPageIdentifier = "SongPageIdentifier"
        
    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = songs[row]
            
        cell.detailTextLabel?.text = artists[row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        print(songs[row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == songPageIdentifier,
           let destination = segue.destination as? SongPageViewController,
           let songIndex = tableView.indexPathForSelectedRow?.row {
            destination.songName = songs[songIndex]
        }
    }
    
}
