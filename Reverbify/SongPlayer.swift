//
//  SongPlayer.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 4/18/23.
//

class SongPlayer {
    var songList: [String]
    var shuffledIndices: [Int]
    var forwardHistory: [Song] = []
    var history: [Song] = []
    var startingIndex: Int = 0
    var index: Int = 0
    var randIndex: Int = 0
    var isRandom: Bool
    var isRepeat : Bool
    
    init(index: Int, songQueue: [String]) {
        self.startingIndex = index
        self.index = index
        self.songList = songQueue
        self.shuffledIndices = Array(0..<songList.count)
        isRandom = false
        isRepeat = false
        shuffleIndices()
    }
    
    func nextSong() -> Song {
        var song = nextSongNormal()
        if isRepeat {
            return SongReference.getSong(key: songList[index])
        } else if forwardHistory.count > 0 {
            return forwardHistory.removeLast()
        } else if isRandom {
            song = nextSongRandom()
        }
        history.append(song)
        return song
    }
    
    func prevSong() -> Song {
        if isRepeat {
            return SongReference.getSong(key: songList[index])
        }
        index -= 1
        var song = SongReference.getSong(key: songList[index])
        if isRandom {
            song = SongReference.getSong(key: songList[shuffledIndices[randIndex]])
        }
        
        forwardHistory.append(song)
        
        if history.count == 0 {
            return song
        }
        
        return history.removeLast()
    }
    
    func nextSongNormal() -> Song {
        let song = SongReference.getSong(key: songList[index])
        index += 1
        if (index >= songList.count) {
            index = 0
        }
        return song
    }
    
    func nextSongRandom() -> Song {
        let song = SongReference.getSong(key: songList[shuffledIndices[randIndex]])
        randIndex += 1
        if randIndex == shuffledIndices.count {
            shuffleIndices()
        }
        return song
    }
    
    func shuffleIndices() {
        for i in 0..<shuffledIndices.count {
            let j = Int.random(in: i..<shuffledIndices.count)
            shuffledIndices.swapAt(i, j)
        }
        index = startingIndex
    }
    
    
    func toggleRandom() {
        isRandom = !isRandom
    }
    
    func toggleRepeat() {
        isRepeat = !isRepeat
    }
    
}
