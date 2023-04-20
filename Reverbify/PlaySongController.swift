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
var songQueue = SongPlayer(index: 0, songQueue: [])
var isPlaying: Bool = true
var currentSong: String = ""
var currentPlayList: String = ""
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
    
    @IBOutlet weak var shuffleSongs: UIButton!
    @IBOutlet weak var repeatSong: UIButton!
    
    
    var localPlayer: AVPlayer?
    var localPlayerItem: AVPlayerItem?
    var localCurPlayList: String?
    var localSongQueue: SongPlayer?
    
    var inView = true
    
    var song : Song? = nil
    
    func setRepeatImage() {
        if songQueue.isRepeat {
            // Get the current image for the button
            guard let currentImage = repeatSong.image(for: .normal) else {
                return
            }
            // Create a new image with the arrows in red
            let redImage = currentImage.withTintColor(.red)
            
            // Set the new image as the button's image
            repeatSong.setImage(redImage, for: .normal)
            repeatSong.setImage(UIImage(named: "red-loop"), for: .normal)
        }
        else {
            repeatSong.setImage(UIImage(named: "loop"), for: .normal)
        }
    }
    
    func setShuffleImage() {
        if songQueue.isRandom {
            // Get the current image for the button
            guard let currentImage = shuffleSongs.image(for: .normal) else {
                return
            }
            // Create a new image with the arrows in red
            let redImage = currentImage.withTintColor(.red)
            
            // Set the new image as the button's image
            shuffleSongs.setImage(redImage, for: .normal)
            shuffleSongs.setImage(UIImage(named: "red-shuffle"), for: .normal)
        }
        else {
            shuffleSongs.setImage(UIImage(named: "random"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setShuffleImage()
        setRepeatImage()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        song = localSongQueue?.nextSong()
        songTitle.text = song?.title
        songAuthor.text = song?.author
        songTimeStamp.text = song?.timeStamp
        
        songTime.text = transformTime(time: Double(song?.seconds ?? 0.0))
        songSlider.minimumValue = 0
        songSlider.maximumValue = song?.seconds ?? 0
        
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
        
        if let signedUrl = self.song?.signedUrl {
            let url = NSURL(string: signedUrl)
            self.localPlayerItem = AVPlayerItem(url: url! as URL)
            self.localPlayer = AVPlayer(playerItem: self.localPlayerItem!)
        }
    }
    
    
    @IBAction func onSliderChange(_ sender: Any) {
        // the idea is that when no player is loaded, switching to a particular time doesnt work
        // since the song is loaded in the local player
        if currentSong != song?.title {
            if let signedUrl = self.song?.signedUrl {
                let url = NSURL(string: signedUrl)
                let playerItem = AVPlayerItem(url: url! as URL)
                player = AVPlayer(playerItem: playerItem)
            }
            currentSong = song!.title
            currentTime = Double(songSlider.value)
            let targetTime = CMTime(seconds: Double(songSlider.value), preferredTimescale: 1)
            player?.seek(to: targetTime)
            makeTimeLabel()
            songSlider.minimumValue = 0
            songSlider.maximumValue = song?.seconds ?? 0
        } else {
            currentTime = Double(songSlider.value)
            let targetTime = CMTime(seconds: Double(songSlider.value), preferredTimescale: 1)
            player?.seek(to: targetTime)
            makeTimeLabel()
        }
    }
    
    func makeTimeLabel() {
        let time = player?.currentTime().seconds ?? 0
        self.songTime.text = transformTime(time: time) + " / " + transformTime(time: Double(song?.seconds ?? 0.0))
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
    
    
    @IBAction func nextHit(_ sender: Any) {
        pauseSound()
        self.nextSong()
        print(currentSong)
        // load graphical details
        loadDetails()
        isPlaying = true
        playSound()
    }
    
    
    @IBAction func prevHit(_ sender: Any) {
        pauseSound()
        prevSong()
        // load graphical details
        loadDetails()
        isPlaying = true
        playSound()
    }
    
    func loadDetails() {
        // update signed url here
        let api = ReverbifyAPIHandler(userName: "", view: self)
        api.getSongRequest(fileName: song!.fileName, song: song!)

        if let signedUrl = self.song?.signedUrl {
            let url = NSURL(string: signedUrl)
            playerItem = AVPlayerItem(url: url! as URL)
            player = AVPlayer(playerItem: playerItem!)
        }
        
        songTitle.text = song?.title
        songAuthor.text = song?.author
        songTimeStamp.text = song?.timeStamp
        songTime.text = transformTime(time: Double(song?.seconds ?? 0.0))
        songSlider.minimumValue = 0
        songSlider.maximumValue = song?.seconds ?? 0
        
        songSlider.value = 0
        queue = DispatchQueue(label: "myQueue", qos:.userInteractive)
        songTime.text = transformTime(time: Double(song?.seconds ?? 0.0))
        
        playSong.setImage(UIImage(named: "pausesvg"), for: .normal)
        
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
    
    
    func nextSong() {
        if localCurPlayList! != currentPlayList {
            songQueue = localSongQueue!
        }
        song = songQueue.nextSong()
        currentSong = song!.title
    }
    
    func prevSong() {
        if localCurPlayList! != currentPlayList {
            songQueue = localSongQueue!
        }
        song = songQueue.prevSong()
        currentSong = song!.title
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
    }
    
    func countUp() {
        while isPlaying && (player?.currentTime().seconds ?? 0) < Double(song?.seconds ?? 0.0) {
            if (player?.currentTime().seconds ?? 0) != 0 {
                usleep(1000000)
                DispatchQueue.main.async {
                    self.songSlider.value += 1
                    self.makeTimeLabel()
                }
            }
            if let player = player {
                switch player.timeControlStatus {
                case .paused:
                    print("Player is paused")
                    isPlaying = false
                case .waitingToPlayAtSpecifiedRate:
                    print("Player is waiting to begin playback")
                case .playing:
                    isPlaying = true
                @unknown default:
                    fatalError("Unexpected time control status")
                }
            }
        }
        DispatchQueue.main.async {
            self.pauseSound()
            self.playSong.setImage(UIImage(named: "play"), for: .normal)
        }
    }
 
    
    @IBAction func toggleRepeat(_ sender: Any) {
        songQueue.toggleRepeat()
        setRepeatImage()
    }
    
    @IBAction func toggleShuffle(_ sender: Any) {
        songQueue.toggleRandom()
        setShuffleImage()
       
    }
    
    
}
