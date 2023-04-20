//
//  SongPlayer.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 4/18/23.
//

class SongPlayer {
    var songList: [String]
    var shuffledIndices: [Int]
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
        print(isRepeat)
        print(index)
        if isRepeat {
            return SongReference.getSong(key: songList[index])
        }
        if isRandom {
            return nextSongRandom()
        }
        return nextSongNormal()
    }
    
    func prevSong() -> Song {
        if isRepeat {
            return SongReference.getSong(key: songList[index])
        }
        if isRandom {
            return prevSongRandom()
        }
        
        return prevSongNormal()
    }
    
    func nextSongNormal() -> Song {
        print(songList)
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
    
    func prevSongRandom() -> Song {
        let song = SongReference.getSong(key: songList[shuffledIndices[randIndex]])
        randIndex -= 1
        if randIndex < 0 {
            shuffleIndices()
        }
        return song
    }
    
    func prevSongNormal() -> Song {
        let song = SongReference.getSong(key: songList[index])
        index -= 1
        if (index < 0) {
            index = songList.count - 1
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
