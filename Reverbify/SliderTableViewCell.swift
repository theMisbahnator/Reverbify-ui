//
//  SliderTableViewCell.swift
//  Reverbify
//
//  Created by Ayush Patel on 4/2/23.
//

import UIKit
class SliderSettings {
    var sliderOn:Bool
    var settingName:String
    
    init(sliderOn: Bool, settingName: String) {
        self.sliderOn = sliderOn
        self.settingName = settingName
    }
}
class SliderTableViewCell: UITableViewCell {

    @IBOutlet weak var slider: UISwitch!
    @IBOutlet weak var settingLabel: UILabel!
    
}
