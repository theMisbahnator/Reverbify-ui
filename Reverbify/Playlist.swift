import UIKit
class Playlist {
    let defaultPlaylistImage = "music-solid"
    var title : String
//    var thumbnail: UIImage
    var thumbnailString: String
    var songs: [Song]
    var indexInDB: Int = 0
    var lastPlayed = 0.0
    init(title: String, thumbnail: String, songs: [Song]) {
        self.title = title
//        self.thumbnail = UIImage(named: defaultPlaylistImage)!
        self.songs = songs
        self.thumbnailString = thumbnail
//        getThumbnail(thumbnail: thumbnailString)
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
        if let songDictionaries = body["songs"] as? [[String: Any]] {
            var songs: [Song] = []
            print(songDictionaries)
            for songDictionary in songDictionaries {
//                print("GOT TO 30")
                let song = Song(body: songDictionary)
                songs.append(song)
                print(songs)
            }
//            print("GOT HERE 32")
            self.songs = songs
//            print(self.songs)
        } else {
            self.songs = []
        }
//        print("GOT HERE 37")
//        getThumbnail(thumbnail: thumbnailString)
//
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
        var songsBody:[[String:Any]] = []
        for song in self.songs {
            songsBody.append(song.convertToJSON())
        }
        return  [
            "title" : self.title,
            "thumbnail" : self.thumbnailString,
            "songs" : songsBody,
            "lastPlayed": self.lastPlayed
        ]
        
    }
    
}
