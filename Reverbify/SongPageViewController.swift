//
//  SongPageViewController.swift
//  Reverbify
//
//  Created by Vu Bui on 3/6/23.
//

import UIKit

class SongPageViewController: UIViewController {
    
    
    @IBOutlet weak var songsLabel: UILabel!
    
    @IBOutlet weak var artistsLabel: UILabel!
    
    var songName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        songsLabel.text = "Song: \(songName)"
//        let songIndex = songsArray.firstIndex(of: songName)
//        artistsLabel.text = "\(artistsArray[songIndex!])"
    }
    

}
