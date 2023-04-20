//
//  AllPlaylistsViewController.swift
//  Reverbify
//
//  Created by Pawan K Somavarpu on 3/25/23.
//
import UIKit

class AllPlaylistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var loadCount = 0
    @IBOutlet var tableView: UITableView!
    var allPlaylists : [Playlist] = []
    private var tapGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "SongTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SongTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlaylists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableCell", for: indexPath as IndexPath) as! SongTableCell
        let row = indexPath.row
        
        cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        cell.title.text = allPlaylists[row].title
        allPlaylists[row].resetThumbnail()
        if let url = URL(string: allPlaylists[row].thumbnailString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    cell.thumbnail.image = UIImage(named:"music-solid")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("Error creating image from downloaded data")
                    cell.thumbnail.image = UIImage(named:"music-solid")
                    return
                }
                
                DispatchQueue.main.async {
                    //print("GOT TO CORRECT COMPLETION")
                    cell.thumbnail.image = image
                }
            }
            task.resume()
        }
        else {
            cell.thumbnail.image = UIImage(named:"music-solid")
        }
        
        cell.author.text = "\(allPlaylists[row].calculateCount()) songs"
        cell.author.numberOfLines = 3
        
        print(allPlaylists[row].toString())
        
        return cell
    }
    
    private func addTapGesture() {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture!)
        }

    private func removeTapGesture() {
        if let tapGesture = tapGesture {
            view.removeGestureRecognizer(tapGesture)
            self.tapGesture = nil
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        addTapGesture()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        removeTapGesture()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    // Dismiss the keyboard when the user taps outside of the search bar
    @objc private func dismissKeyboard() {
        
        //TODO - create segue from playlist search bar here
       // searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Present the next view controller
        let playlistVC = self.storyboard?.instantiateViewController(withIdentifier: "playlist") as! PlaylistViewController

        playlistVC.playlist = allPlaylists[indexPath.row]
        
        navigationController?.pushViewController(playlistVC, animated: true)
    }
    
    // Deleting Playlist from AllPlaylists
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            allPlaylists.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidLoad()
//        
//    }
    
    override func viewDidAppear(_ animated: Bool) {

        DatabaseClass.getAllPlaylists { listOfPlaylists in
            self.allPlaylists = listOfPlaylists
            self.tableView.reloadData()
        }
        
        super.viewDidAppear(true);
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DatabaseClass.saveAllPlaylists(listOfPlaylists: self.allPlaylists)
        super.viewWillDisappear(true)
    }
    

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
