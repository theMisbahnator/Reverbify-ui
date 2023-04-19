//
//  Database.swift
//  Reverbify
//
//  Created by Ayush Patel on 4/19/23.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import UIKit

class DatabaseClass {
    static var database: DatabaseReference! = Database.database(url: "https://reverbify-b9e19-default-rtdb.firebaseio.com/").reference()
    
    static func getAllSongs(completion: @escaping ([Song]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            completion([])
            return
        }
        
        let songsRef = self.database.child("users").child(currentUserID).child("songs")
        var storage: [Song] = []
        // Now, you can read in the user's songs list
        songsRef.observeSingleEvent(of: .value, with: { snapshot in
            var songsList: [[String: Any]] = []
            if let existingSongs = snapshot.value as? [[String: Any]] {
                // If the user's songs list already exists, append the new song to it
                songsList = existingSongs
                print(songsList)
                for song in songsList {
                    let thisSong = Song(body: song)
                    storage.append(thisSong)
                }
            }
            completion(storage)
        }) { error in
            print(error.localizedDescription)
            completion([])
        }
    }

    
    static func saveAllSongs(songList: [Song], completion: (() -> Void)? = nil) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        
        let songsRef = self.database.child("users").child(currentUserID).child("songs")
        // Now, you can read in the user's songs list
        songsRef.observeSingleEvent(of: .value, with: { snapshot in
            var songsList: [[String: Any]] = []
            for song in songList {
                songsList.append(song.convertToJSON())
            }
            songsRef.setValue(songsList)
            completion?()
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    static func saveNewSong(body: [String:Any], completion: (() -> Void)? = nil) {
        // Then, you'll want to get a reference to the user's songs list
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        let songsRef = self.database.child("users").child(currentUserID).child("songs")

        // Now, you can read in the user's songs list
        songsRef.observeSingleEvent(of: .value, with: { snapshot in
            var songsList: [[String: Any]] = []
            if let existingSongs = snapshot.value as? [[String: Any]] {
                // If the user's songs list already exists, append the new song to it
                songsList = existingSongs
            }
            songsList.append(body)
            // Finally, update the user's songs list in Firebase
            songsRef.setValue(songsList)
            
            completion?()
        }) { error in
            completion?()
            print(error.localizedDescription)
        }
    }
    static func getAllPlaylists(completion: @escaping ([Playlist]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        
        let playlistsRef = self.database.child("users").child(currentUserID).child("playlists")
        var listOfPlaylists:[Playlist] = []
        // Now, you can read in the user's songs list
        playlistsRef.observeSingleEvent(of: .value, with: { snapshot in
            var playlistList: [[String: Any]] = []
            if let existingPlaylist = snapshot.value as? [[String: Any]] {
                // If the user's songs list already exists, append the new song to it
                playlistList = existingPlaylist
                var i = 0
                for playlist in playlistList {
                    listOfPlaylists.append(Playlist(body: playlist, index: i))
                    i = i + 1
                }

                completion(listOfPlaylists)
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    
    static func addSongstoPlaylist(selectedSongs: [Song], playlistIndex: Int, completion: (() -> Void)? = nil) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        
        let playlistsRef = self.database.child("users").child(currentUserID).child("playlists")
        // Now, you can read in the user's songs list
        playlistsRef.observeSingleEvent(of: .value, with: { snapshot in
            var playlistsList: [[String: Any]] = []
            if let existingPlaylist = snapshot.value as? [[String: Any]] {
                // If the user's songs list already exists, append the new song to it
                playlistsList = existingPlaylist
                let currPlaylist = playlistsList[playlistIndex]
                var currSongs = []
                if let songs = currPlaylist["songs"] as? Array<[String: Any]> {
                    currSongs = songs
                }
               
                for song in selectedSongs {
                    currSongs.append(song.convertToJSON())
                }
                
                playlistsList[playlistIndex]["songs"] = currSongs
                
            }
            playlistsRef.setValue(playlistsList)
            completion?()
            
        }) { error in
            completion?()
            print(error.localizedDescription)
        }
    }
    
    static func saveAllPlaylists(listOfPlaylists: [Playlist]) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        let playlistsRef = self.database.child("users").child(currentUserID).child("playlists")
        // Now, you can read in the user's songs list
        playlistsRef.observeSingleEvent(of: .value, with: { snapshot in
            var playlistList: [[String: Any]] = []
            for playlist in listOfPlaylists {
                playlistList.append(playlist.convertToJSON())
            }
            playlistsRef.setValue(playlistList)
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    static func addNewPlaylist(newPlaylist:[String: Any], completion: @escaping (() -> Void)) {
        // Then, you'll want to get a reference to the user's songs list
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        
        
        let playlistsRef = self.database.child("users").child(currentUserID).child("playlists")
        
        // Now, you can read in the user's songs list
        playlistsRef.observeSingleEvent(of: .value, with: { snapshot in
            var playlistList: [[String: Any]] = []
            if let existingPlaylist = snapshot.value as? [[String: Any]] {
                // If the user's songs list already exists, append the new song to it
                playlistList = existingPlaylist
            }
            playlistList.append(newPlaylist)

            // Finally, update the user's songs list in Firebase
            playlistsRef.setValue(playlistList)
            completion()
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    static func saveThisPlaylist(playlist: Playlist) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, you can handle that error here
            return
        }
        
        let playlistsRef = self.database.child("users").child(currentUserID).child("playlists")
        // Now, you can read in the user's songs list
        playlistsRef.observeSingleEvent(of: .value, with: { snapshot in
            var playlistList: [[String: Any]] = []
            if let existingPlaylist = snapshot.value as? [[String: Any]] {
                // If the user's songs list already exists, append the new song to it
                playlistList = existingPlaylist
            }
            playlistList[playlist.indexInDB] = playlist.convertToJSON()
            playlistsRef.setValue(playlistList)
            
        }) { error in
            print(error.localizedDescription)
        }
    }
    
}
