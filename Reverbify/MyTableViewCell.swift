//
//  MyTableViewCell.swift
//  Reverbify
//
//  Created by Vu Bui on 3/26/23.
//

import UIKit

class MyTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    weak var parentViewController: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if myCollectionView.tag >= songLists.count {
            return playlistLists[myCollectionView.tag - songLists.count].playlistLst.count
        }
        return songLists[myCollectionView.tag].songlst.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "collectioncell", for: indexPath) as! MyCollectionViewCell
        if myCollectionView.tag >= songLists.count {
            let index = collectionView.tag - songLists.count
            let currentPlaylist = playlistLists[index].playlistLst[indexPath.row]
            if let url = URL(string: currentPlaylist.thumbnail) {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = data, let image = UIImage(data: data) else {
                        print("Error creating image from downloaded data")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        cell.myImage.image = image
                    }
                }
                task.resume()
            }
            cell.myLabel.text = currentPlaylist.title
            cell.layer.borderColor = UIColor.white.cgColor
            
        }
        else {
            // get image from internet
            let currentSong = songLists[myCollectionView.tag].songlst[indexPath.row]
            if let url = URL(string: currentSong.thumbnail) {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = data, let image = UIImage(data: data) else {
                        print("Error creating image from downloaded data")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        cell.myImage.image = image
                    }
                }
                task.resume()
            }
                    
            cell.myLabel.text = currentSong.title
            cell.layer.borderColor = UIColor.white.cgColor
        }
       return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if myCollectionView.tag >= songLists.count {
            let index = myCollectionView.tag - songLists.count
            let currentPlaylist = playlistLists[index].playlistLst[indexPath.row]
            
            self.parentViewController.performSegue(withIdentifier: "playPlaylist", sender: currentPlaylist)
        }
        else {
            let currentSong = songLists[myCollectionView.tag].songlst[indexPath.row]
            
            self.parentViewController.performSegue(withIdentifier: "playSong", sender: currentSong)
        }
       
        
    }
    
}
