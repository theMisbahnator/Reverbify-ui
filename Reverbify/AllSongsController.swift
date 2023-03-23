//
//  AllSongsController.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 3/18/23.
//

import UIKit

var allSongs : [Song] = []
class AllSongsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SongTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SongTableCell")
        
        // create dummy data
        allSongs.append(Song(title: "I don't wanna know", author: "Drake, 21 Savage, The Weeknd", duration: "6:23", signedUrl: "https://img.youtube.com/vi/HQn_Gu9qHwM/sddefault.jpg", fileName: "some file name", timeStamp: "6/23/23", thumbnail: "https://img.youtube.com/vi/HQn_Gu9qHwM/sddefault.jpg"))
        
        allSongs.append(Song(title: "The Wishing Tree", author: "The Kings Singers this is a really long title let see if this is gonna wrap", duration: "6:23", signedUrl: "https://img.youtube.com/vi/HQn_Gu9qHwM/sddefault.jpg", fileName: "some file name", timeStamp: "6/23/23", thumbnail: "https://img.youtube.com/vi/r9_qDBnOuas/sddefault.jpg"))
        
        allSongs.append(Song(title: "Home this is a really large title to see if this stuff is gonna wrap", author: "Resonance", duration: "6:23", signedUrl: "https://img.youtube.com/vi/HQn_Gu9qHwM/sddefault.jpg", fileName: "some file name", timeStamp: "6/23/23", thumbnail: "https://img.youtube.com/vi/V90pwWdXC2U/sddefault.jpg"))
        
        allSongs.append(Song(title: "spaceship - playboi carti (slowed + reverb)", author: "Playboi Kartie", duration: "6:23", signedUrl: "https://img.youtube.com/vi/HQn_Gu9qHwM/sddefault.jpg", fileName: "some file name", timeStamp: "6/23/23", thumbnail: "https://img.youtube.com/vi/908H3wKCRpQ/sddefault.jpg"))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableCell", for: indexPath as IndexPath) as! SongTableCell
        let row = indexPath.row
        
        cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        cell.title.text = allSongs[row].title
        cell.title.numberOfLines = 2
        
        if let url = URL(string: allSongs[row].thumbnail) {
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
        
        
        cell.author.text = allSongs[row].author
        cell.author.numberOfLines = 3
//        cell.timestamp.text = allSongs[row].timeStamp
//        cell.timestamp.numberOfLines = 3
//        cell.duration.text = allSongs[row].duration
//        cell.duration.numberOfLines = 3
        
        print(allSongs[row].toString())
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
}
