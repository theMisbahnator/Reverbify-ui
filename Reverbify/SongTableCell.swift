//
//  SongTableCell.swift
//  Reverbify
//
//  Created by Misbah Imtiaz on 3/19/23.
//

import UIKit

class SongTableCell: UITableViewCell {
    
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    
    //    @IBOutlet weak var title: UILabel!
//    @IBOutlet weak var author: UILabel!
//    @IBOutlet weak var timestamp: UILabel!
//    @IBOutlet weak var duration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
