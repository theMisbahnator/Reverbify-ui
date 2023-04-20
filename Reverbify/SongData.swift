//
//  SongData.swift
//  Reverbify
//
//  Created by Vu Bui on 3/26/23.
//

import Foundation
import OrderedCollections
struct SongData {
    let sectionType:String
    var songlst: OrderedDictionary<String, Song>
}

struct PlaylistData {
    let sectionType:String
    var playlistLst:[Playlist]
}

