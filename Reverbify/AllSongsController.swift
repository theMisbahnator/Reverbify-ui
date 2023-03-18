//
//  AllSongsController.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 3/18/23.
//

import UIKit

var allSongs : [Song] = []
class AllSongsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.numberOfLines = 15
        cell.textLabel?.text = allSongs[row].toString()
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
}
