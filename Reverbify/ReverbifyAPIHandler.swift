//
//  ReverbifyAPIHandler.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 3/17/23.
//

import UIKit

class ReverbifyAPIHandler {
    var userName: String
    var view : UIViewController
    let reverbEndpoint = "https://reverbify-api-service-klfqvexjrq-vp.a.run.app/reverb-song"
    let testEndpoint = "https://reverbify-api-service-klfqvexjrq-vp.a.run.app/health-check"
    let deleteSongReverb = "https://reverbify-api-service-klfqvexjrq-vp.a.run.app/delete-song"
    let getSignedUrl = "https://reverbify-api-service-klfqvexjrq-vp.a.run.app/signed-url"
    
    init(userName: String, view: UIViewController) {
        self.userName = userName
        self.view = view
    }
    
    func postReverbRequest(youtubeLink: String, pitch: String, bass: Bool, reverb: String) {
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
                
                // create segue
                
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
            var resp = "Internal Server Error. "
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
            var body = createJSONResponse(data: data)
            let errorValue = body["Error"] as? String
            DispatchQueue.main.async {
                alertController.dismiss(animated: true) {
                    self.createErrorPopup(msg: errorValue!)
                }
            }
            
            return [:]
        }
        
        // Happy path, response returns song processing information
        var body = createJSONResponse(data: data)
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
    
    func createErrorPopup(msg: String) {
        let controller = UIAlertController(
            title: "Error!",
            message: msg,
            preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .default))
        
        view.present(controller, animated: true)
    }
}
        
        
        
        
        
    
