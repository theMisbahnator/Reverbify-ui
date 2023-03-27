//
//  PlaylistTableViewCell.swift
//  Reverbify
//
//  Created by Pawan K Somavarpu on 3/27/23.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet var numberSongs: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
