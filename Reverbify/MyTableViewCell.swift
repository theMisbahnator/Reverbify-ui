//
//  MyTableViewCell.swift
//  Reverbify
//
//  Created by Vu Bui on 3/26/23.
//

import UIKit

class MyTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
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
        return songLists[myCollectionView.tag].songImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "collectioncell", for: indexPath) as! MyCollectionViewCell
        cell.myImage.image = UIImage(named: songLists[myCollectionView.tag].songImage[indexPath.row])
        cell.myLabel.text = songLists[myCollectionView.tag].songName[indexPath.row]
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You have clicked on song \(songLists[myCollectionView.tag].songName[indexPath.row])")
    }
}
