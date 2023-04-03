//
//  AccountTableViewCell.swift
//  Reverbify
//
//  Created by Ayush Patel on 4/2/23.
//

import UIKit
class AccountSettings {
    var settingName: String
    var settingDescrip: String
    var nextIdentifier: String
    init(settingName: String, settingDescrip: String, nextIdentifier: String) {
        self.settingName = settingName
        self.settingDescrip = settingDescrip
        self.nextIdentifier = nextIdentifier
    }
}
class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var settingName: UILabel!
    @IBOutlet weak var settingDescription: UILabel!
    
}
