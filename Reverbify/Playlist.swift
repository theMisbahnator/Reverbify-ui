import UIKit
class Playlist {
    let defaultPlaylistImage = "music-solid"
    var title : String
//    var thumbnail: UIImage
    var thumbnailString: String
    var songs: [String]
    var indexInDB: Int = 0
    var lastPlayed = 0.0
    var nextSongNumber = 0
    init(title: String, thumbnail: String, songs: [String]) {
        self.title = title
//        self.thumbnail = UIImage(named: defaultPlaylistImage)!
        self.songs = songs
        self.thumbnailString = thumbnail
        
//        getThumbnail(thumbnail: thumbnailString)
    }
    
    func calculateCount() -> Int {
        var toRemove:[String] = []
        for key in self.songs {
            if SongReference.getSong(key: key).isEmpty() {
                toRemove.append(key)
            }
        }
        self.songs = self.songs.filter { bElement in
            !toRemove.contains { aElement in
                bElement.contains(aElement)
            }
        }
        return songs.count
    }
    
    
    init(body: [String:Any], index: Int) {
//        print("GOT TO 20 \(String(describing: body["thumbnail"]))")
        self.title = body["title"] as! String
//        self.thumbnail = UIImage(named: defaultPlaylistImage)!
        self.indexInDB = index
        self.thumbnailString = body["thumbnail"] as! String
        if let lastPlayedDate = body["lastPlayed"] as? Double {
            self.lastPlayed = lastPlayedDate
        } else {
            self.lastPlayed = 0.0
        }
//        print("GOT HERE 25")
        if let songDictionaries = body["songs"] as? [String] {
            self.songs = songDictionaries
        } else {
            self.songs = []
        }
//        print("GOT HERE 37")
//        getThumbnail(thumbnail: thumbnailString)
//
    }
    
    func resetThumbnail() {
        if calculateCount() >= 1 {
            self.thumbnailString = SongReference.getSong(key: self.songs[0]).thumbnail
        }
        else {
            self.thumbnailString = ""
        }
    }

//    func getThumbnail(thumbnail: String) -> Void {
//        if thumbnail == "" {
//            return
//        } else if let url = URL(string: thumbnail) {
//            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if let error = error {
//                    print("Error downloading image: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let data = data, let image = UIImage(data: data) else {
//                    print("Error creating image from downloaded data")
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    //print("GOT TO CORRECT COMPLETION")
//                    self.thumbnail = image
//                }
//            }
//            task.resume()
//        }
//    }
    func toString() -> String {
        return "\n\(title)\n\(thumbnailString)\n\(songs)"
    }
    
    func convertToJSON() -> [String: Any]{
        
//        var songsBody:[[String:Any]] = []
//        for song in self.songs {
//            songsBody.append(song.convertToJSON())
//        }
//        var nextSongNumber = 0
//        var songsBody: [String: Any] = [:]
//        for id in self.songs {
//            allSongs[id] =
//        }
//        for key in songsBody {
//            if key == "nextSongNumber" {
//                nextSongNumber = songsBody[key]["nextSongNumber"]
//            }
//        }
        
        return  [
            "title" : self.title,
            "thumbnail" : self.thumbnailString,
            "songs" : self.songs,
            "lastPlayed": self.lastPlayed,
        ]
        
    }
    
}
