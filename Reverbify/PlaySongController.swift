//
//  PlaySongController.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 3/23/23.
//

import UIKit
import AVFoundation

var player: AVPlayer?
var playerItem: AVPlayerItem?
class PlaySongController: UIViewController {

    
    @IBOutlet weak var author: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songAuthor: UILabel!
    @IBOutlet weak var songDuration: UILabel!
    @IBOutlet weak var songTimeStamp: UILabel!
    @IBOutlet weak var playSong: UIButton!
    
    var playing = false
    var loaded = false
    
    var song : Song? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songTitle.text = song?.title
        songAuthor.text = song?.author
        songDuration.text = song?.duration
        songTimeStamp.text = song?.timeStamp
        
        if let url = URL(string: song!.thumbnail) {
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
                    self.author.image = image
                }
            }
            task.resume()
        }
        
    }
    
    
    @IBAction func onPlay(_ sender: Any) {
        var title = "Pause"
        if playing {
            title = "Play"
        }
        
        playSong.setTitle(title, for: .normal)
        
        if playing {
            pauseSound()
        } else {
            playSound()
        }
        
        playing  = !playing
    }
    
    func playSound() {
        if loaded {
            player?.play()
            return
        }
        let url  = NSURL(string: song!.signedUrl)
        playerItem = AVPlayerItem(url: url! as URL)
        player = AVPlayer(playerItem: playerItem!)
        loaded = true
        player?.play()
    }
    
    func pauseSound() {
        player?.pause()
    }
}
