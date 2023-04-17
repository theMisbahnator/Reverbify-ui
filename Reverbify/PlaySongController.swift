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
var isPlaying: Bool = false
var currentSong: String = ""
var currentTime: Double = 0.0
var maxTime: Double = 0.0
var queue: DispatchQueue!

class PlaySongController: UIViewController {
    
    @IBOutlet weak var author: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songAuthor: UILabel!
    @IBOutlet weak var songTimeStamp: UILabel!
    @IBOutlet weak var playSong: UIButton!
    @IBOutlet weak var songTime: UILabel!
    @IBOutlet weak var songSlider: UISlider!
    
    var localPlayer: AVPlayer?
    var localPlayerItem: AVPlayerItem?
    
    var playing = false
    var inView = true
    
    var song : Song? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songTitle.text = song?.title
        songAuthor.text = song?.author
        songTimeStamp.text = song?.timeStamp
        
        songTime.text = transformTime(time: Double(song?.seconds ?? 0.0))
        songSlider.minimumValue = 0
        songSlider.maximumValue = song?.seconds ?? 0
        var time = player?.currentTime()
        print("this is the time \(time?.seconds ?? 0)")
        
        songSlider.value = 0
        queue = DispatchQueue(label: "myQueue", qos:.userInteractive)
        
        var title = "play"
        if isPlaying && currentSong == song?.title {
            songSlider.value = Float(player?.currentTime().seconds ?? 0)
            makeTimeLabel()
            queue.async {
                self.countUp()
            }
            title = "pausesvg"

        } else if currentSong == song?.title {
            songSlider.value = Float(player?.currentTime().seconds ?? 0)
            makeTimeLabel()
        }
        
        playSong.setImage(UIImage(named: title), for: .normal)
        
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
        
        let url  = NSURL(string: song!.signedUrl)
        localPlayerItem = AVPlayerItem(url: url! as URL)
        localPlayer = AVPlayer(playerItem: localPlayerItem!)
    }
    
    
    @IBAction func onSliderChange(_ sender: Any) {
        print(songSlider.value)
        currentTime = Double(songSlider.value)
        let targetTime = CMTime(seconds: Double(songSlider.value), preferredTimescale: 1)
        player?.seek(to: targetTime)
        makeTimeLabel()
//        queue.async {
//            self.countUp()
//        }
    }
    
    func makeTimeLabel() {
        var time = player?.currentTime().seconds ?? 0
        self.songTime.text = transformTime(time: time) + " / " + transformTime(time: maxTime)
    }
    
    func transformTime(time: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .dropLeading
        
        if let currentString = formatter.string(from: time) {
            return currentString
        }
        return ""
    }
    
    
    @IBAction func onPlay(_ sender: Any) {
        var title = "pausesvg"
        if isPlaying {
            title = "play"
        }
        playSong.setImage(UIImage(named: title), for: .normal)
        if isPlaying {
            pauseSound()
        } else {
            playSound()
        }
    }
    
    func playSound() {
        if currentSong != songTitle.text {
            player = localPlayer
        }
        isPlaying = true
        maxTime = Double(song?.seconds ?? 0.0)
        currentSong = songTitle.text ?? ""
        player?.play()
        
        queue.async {
            self.countUp()
        }
        
    }
    
    func pauseSound() {
        player?.pause()
        isPlaying = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        inView = false
    }
    
    func countUp() {
        while isPlaying && currentTime < maxTime && inView {
            usleep(1000000)
            DispatchQueue.main.async {
                self.songSlider.value += 1
                self.makeTimeLabel()
            }
        }
        isPlaying = false
    }
}
