//
//  ReverbifyAPIHandler.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 3/17/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Song {
    var title : String
    var author : String
    var duration : String
    var signedUrl : String
    var fileName : String
    var timeStamp : String
    var thumbnail: String
    init(title: String, author: String, duration: String, signedUrl: String, fileName: String, timeStamp: String, thumbnail: String) {
        self.title = title
        self.author = author
        self.duration = duration
        self.signedUrl = signedUrl
        self.fileName = fileName
        self.timeStamp = timeStamp
        self.thumbnail = thumbnail
    }
    
    init(body: [String: Any]) {
        
        self.title = body["title"] as! String
        self.author = body["author"] as! String
        self.duration = body["duration"] as! String
        self.signedUrl = body["signedUrl"] as! String
        self.thumbnail = body["thumbnail"] as! String
        self.timeStamp = body["timestamp"] as! String
        self.fileName = body["filename"] as! String
        
    }

    func toString() -> String {
        return "\n\(title)\n\(author)\n\(duration)\n\(fileName)\n\(timeStamp)\n\(thumbnail)\n\(signedUrl)"
    }
    func convertJSONtoSong() {
        
    }
}

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

class ReverbifyAPIHandler {
    var userName: String
    var view : UIViewController
    var controller : AddSongController
    var database: DatabaseReference!
    let reverbEndpoint = "https://reverbify-api-service-klfqvexjrq-vp.a.run.app/reverb-song"
    let testEndpoint = "https://reverbify-api-service-klfqvexjrq-vp.a.run.app/health-check"
    let deleteSongReverb = "https://reverbify-api-service-klfqvexjrq-vp.a.run.app/delete-song"
    let getSignedUrl = "https://reverbify-api-service-klfqvexjrq-vp.a.run.app/signed-url"
    
    init(userName: String, view: UIViewController, controller: AddSongController) {
        self.userName = userName
        self.view = view
        self.controller = controller
        self.database = Database.database(url: "https://reverbify-b9e19-default-rtdb.firebaseio.com/").reference()
    }
    
    func postReverbRequest(youtubeLink: String, pitch: String, bass: Bool, reverb: String, optionalName: String, optionalAuthor: String) {
        // post endpoint for song creation
        guard let url = URL(string: reverbEndpoint) else {
            return
        }
        
        // Define the request body data
        let jsonObject: [String: Any] = [
            "user": userName,
            "url": youtubeLink,
            "pitch": pitch,
            "bass": [
                "change": bass,
                "centerFreq": "60",
                "filterWidth": "50",
                "gain": "8"
            ],
            "reverb": reverb
        ]
        
        // Prevent user from navigating out when processing request
        let alertController = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
        view.present(alertController, animated: true, completion: nil)
        
        
        do {
            // serialize object into JSON
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            print("Creating request...")
            
            // Create the session
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { [self] data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                var body : [String: Any]
                // handle response
                body = self.handleReverbResponse(httpResponse:httpResponse, alertController:alertController, data:data)
                print(body)
                if optionalName != "" {
                    body["title"] = optionalName
                }
                if optionalAuthor != "" {
                    body["author"] = optionalAuthor
                }
                
                transitionAllSongs(body: body, alertController: alertController)
            }
            
            task.resume()
        } catch {
            DispatchQueue.main.async {
                // hide alert here
                alertController.dismiss(animated: true) {
                    self.createErrorPopup(msg: "Invalid Request Body")
                }
            }
        }
    }
    
    func handleReverbResponse (httpResponse: HTTPURLResponse, alertController: UIAlertController, data: Data?) -> [String: Any] {
        print("Response status code: \(httpResponse.statusCode)")
        if httpResponse.statusCode != 200 {
            let resp = "Internal Server Error. "
            if httpResponse.statusCode == 500 {
                // something went wrong with server, no message supplied
                DispatchQueue.main.async {
                    // hide alert here
                    alertController.dismiss(animated: true) {
                        self.createErrorPopup(msg: resp)
                    }
                }
                return [:]
            }
            
            // user request data error, parse and print response
            let body = createJSONResponse(data: data)
            let errorValue = body["Error"] as? String
            DispatchQueue.main.async {
                alertController.dismiss(animated: true) {
                    self.createErrorPopup(msg: errorValue!)
                }
            }
            
            return [:]
        }
        
        // Happy path, response returns song processing information
        let body = createJSONResponse(data: data)
        return body
    }
    
    func createJSONResponse(data: Data?) -> [String: Any] {
        // Ensure there is a response
        guard let responseData = data else {
            print("No response data.")
            return [:]
        }
        
        do {
            // Convert response data to a JSON object
            let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
            
            // Cast the JSON object as a dictionary
            guard let responseDict = jsonObject as? [String: Any] else {
                print("Invalid response format.")
                return [:]
            }
            
            return responseDict
        } catch {
            print("Error parsing response data: \(error.localizedDescription)")
            return [:]
        }
    }
    
    func transitionAllSongs(body : [String: Any], alertController: UIAlertController) {
        DispatchQueue.main.async {
            print(body)
            let title = body["title"] as? String
            let author = body["author"] as? String
            let duration = body["duration"] as? String
            let signedUrl = body["signedUrl"] as? String
            let thumbnail = body["thumbnail"] as? String
            let timestamp = body["timestamp"] as? String
            let fileName = body["filename"] as? String
            
            // create segue
            let tabBarVC = self.view.tabBarController
            
            let s = Song(title: title!, author: author!, duration: duration!, signedUrl: signedUrl!, fileName: fileName!, timeStamp: timestamp!, thumbnail: thumbnail!)
            
//            allSongs.append(s)
            
            // DO DATABASE
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
            }) { error in
                print(error.localizedDescription)
            }

            // close pop up and transition
            alertController.dismiss(animated: true) {
                self.controller.clearFields()
                let allSongsPage = self.view.tabBarController?.viewControllers?[1]
                tabBarVC?.selectedViewController = allSongsPage
            }
        }
    }
    
    func createErrorPopup(msg: String) {
        let controller = UIAlertController(
            title: "Error!",
            message: msg,
            preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .default))
        
        view.present(controller, animated: true)
    }
}
        
        
        
        
        
    
