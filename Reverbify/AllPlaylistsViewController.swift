//
//  AllPlaylistsViewController.swift
//  Reverbify
//
//  Created by Pawan K Somavarpu on 3/25/23.
//
import UIKit

class AllPlaylistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var loadCount = 0
    @IBOutlet var tableView: UITableView!
    var allPlaylists : [Playlist] = []
    var filteredPlaylist : [Playlist] = []
    private var tapGesture: UITapGestureRecognizer?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "SongTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SongTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.borderWidth = 0
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredPlaylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableCell", for: indexPath as IndexPath) as! SongTableCell
        let row = indexPath.row
        let currentPlaylist = self.filteredPlaylist[row]
        cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        cell.title.text = currentPlaylist.title
        allPlaylists[row].resetThumbnail()
        if let url = URL(string: currentPlaylist.thumbnailString) {
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
        
        cell.author.text = currentPlaylist.getCountMatch()
        cell.author.numberOfLines = 3
        
        print(currentPlaylist.toString())
        
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
       searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Present the next view controller
        let playlistVC = self.storyboard?.instantiateViewController(withIdentifier: "playlist") as! PlaylistViewController

        playlistVC.playlist = self.filteredPlaylist[indexPath.row]
        
        navigationController?.pushViewController(playlistVC, animated: true)
    }
    
    // Deleting Playlist from AllPlaylists
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let curPlay = self.filteredPlaylist[indexPath.row]
            self.filteredPlaylist.remove(at: indexPath.row)
            var index = 0
            for play in allPlaylists {
                if play == curPlay {
                    break
                }
                index += 1
                   
            }
            allPlaylists.remove(at: index)
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
        if let searchBarTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchBarTextField.text = ""
        }
        
        DatabaseClass.getAllPlaylists { listOfPlaylists in
            self.allPlaylists = listOfPlaylists
            self.filteredPlaylist = listOfPlaylists
            self.tableView.reloadData()
        }
        
        super.viewDidAppear(true);
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DatabaseClass.saveAllPlaylists(listOfPlaylists: self.allPlaylists)
        super.viewWillDisappear(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredPlaylist = allPlaylists.filter({ playlist in
            let titleMatch = playlist.title.lowercased().contains(searchText.lowercased())
            let countMatch = playlist.getCountMatch().lowercased().contains(searchText.lowercased())
                    return titleMatch || countMatch || searchText == ""
                })
        tableView.reloadData()
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
