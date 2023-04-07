class Playlist {
    var title : String
    var thumbnail: String
    var songs: Array<Song>
    init(title: String, thumbnail: String, songs: Array<Song>) {
        self.title = title
        self.thumbnail = thumbnail
        self.songs = songs
    }

    func toString() -> String {
        return "\n\(title)\n\(thumbnail)\n\(songs)"
    }
}
