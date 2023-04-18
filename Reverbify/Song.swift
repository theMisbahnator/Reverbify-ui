class Song: Equatable {
    static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.title == rhs.title && lhs.author == rhs.author && lhs.duration == rhs.duration && lhs.signedUrl == rhs.signedUrl && lhs.fileName == rhs.fileName
    }
    
    var title : String
    var author : String
    var duration : String
    var signedUrl : String
    var fileName : String
    var timeStamp : String
    var thumbnail: String
    var seconds : Float
    init(title: String, author: String, duration: String, signedUrl: String, fileName: String, timeStamp: String, thumbnail: String) {
        self.title = title
        self.author = author
        self.duration = duration
        self.signedUrl = signedUrl
        self.fileName = fileName
        self.timeStamp = timeStamp
        self.thumbnail = thumbnail
        
        // calculate seconds
        self.seconds = 0
        self.seconds = getSeconds(duration: duration)
    }
    
    init(body: [String: Any]) {
        self.title = body["title"] as! String
        self.author = body["author"] as! String
        self.duration = body["duration"] as! String
        self.signedUrl = body["signedUrl"] as! String
        self.thumbnail = body["thumbnail"] as! String
        self.timeStamp = body["timestamp"] as! String
        self.fileName = body["filename"] as! String
        // calculate seconds
        self.seconds = 0
        self.seconds = getSeconds(duration: duration)
    }
    
    func getSeconds(duration: String) -> Float {
        print(duration)
        var time = 0.0
        var scale = 1.0
        let components = duration.components(separatedBy: ":")
        for elem in components.reversed() {
            time += (Double(elem) ?? 0) * scale
            scale *= 60
        }
        
        return Float(time)
    }

    func toString() -> String {
        return "\n\(title)\n\(author)\n\(duration)\n\(fileName)\n\(timeStamp)\n\(thumbnail)\n\(signedUrl)"
    }
    
    func convertToJSON() -> [String: Any]{
        return  [
            "title" : self.title,
            "author" : self.author,
            "duration": self.duration,
            "signedUrl": self.signedUrl,
            "thumbnail": self.thumbnail ,
            "timestamp": self.timeStamp,
            "filename":  self.fileName,
        ]
        
    }
}
