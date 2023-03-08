//
//  AllSongsController.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 3/7/23.
//

import UIKit

var songsList : [Song] = []
class AllSongsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath as IndexPath)
        
        return cell
    }
    
    override func viewDidAppear(_ amimated: Bool) {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

}
