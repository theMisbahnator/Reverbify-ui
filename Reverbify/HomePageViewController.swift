
//
//  ViewController.swift
//  GridView
//
//  Created by Vu Bui on 3/7/23.
//

import UIKit

let songLists = [
                  SongData(sectionType: "Recently Played Playlist",
                         songImage: ["pic1"],
                         songName: ["Drake ft. 21 Savage - Jimmy Cooks (Official Audio)", "The Wishing Tree"]),
                  SongData(sectionType: "Recently Played Songs",
                          songImage: ["pic1", "pic3", "pic4"],
                          songName: ["Drake ft. 21 Savage - Jimmy Cooks (Official Audio)", "Juice WRLD - Lucid Dreams (Directed by Cole Bennett)", "Bane"]),
                  SongData(sectionType: "Recently Downloaded",
                           songImage: ["pic1", "pic4"],
                           songName: ["Drake ft. 21 Savage - Jimmy Cooks (Official Audio)", "Bane"])]

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        cell.myCollectionView.tag = indexPath.section
        cell.myCollectionView.reloadData()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return songLists.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return songLists[section].sectionType
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
}

