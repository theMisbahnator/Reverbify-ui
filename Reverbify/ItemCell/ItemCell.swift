//
//  ItemCell.swift
//  Reverbify
//
//  Created by Vu Bui on 3/7/23.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(text:String) {
        self.textLabel.text = text
    }
}
