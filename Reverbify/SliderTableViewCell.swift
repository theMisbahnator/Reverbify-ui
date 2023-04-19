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

    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var slider: UISwitch!
    
    var delegate: SliderCellDelegate?
    
    @IBAction func sliderValueChanged(_ sender: UISwitch) {
        print("GOT TO THIS:")
        print("GOT TO THIS: \(sender.isOn)")

        delegate?.sliderValueChanged(sender.isOn, forCell: self)
    }
    
//    @IBAction func sliderChanged(_ sender: Any) {
//
//
//    }
}

protocol SliderCellDelegate: AnyObject {
    func sliderValueChanged(_ value: Bool, forCell cell: SliderTableViewCell)
}
