//
//  AlarmDetailsSettingsTableViewCellType2.swift
//  alarm
//
//  Created by Константин Кифа on 26.07.2022.
//

import UIKit

class AlarmDetailsTableViewCellType2: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var switchElement: UISwitch!
    @IBAction func switchChange(_ sender: UISwitch) {
        callback?(sender.isOn)
    }
    var callback: ((Bool)->())?
    static let id = "AlarmDetailsTableViewCellType2"
    static func nib() -> UINib{
        return UINib(nibName: id, bundle: nil)
    }
}
