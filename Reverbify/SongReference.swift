//
//  SongReference.swift
//  Reverbify
//
//  Created by Ayush Patel on 4/19/23.
//

import Foundation
import OrderedCollections

class SongReference {
    static var allSongs: OrderedDictionary<String, Song> = [:]
    
    static func getSong(key: String) -> Song {
        guard let song = allSongs[key] else {
            return Song(title: "", author: "", duration: "", signedUrl: "", fileName: "", timeStamp: "", thumbnail: "")
        }
        return song
    }
    
}
