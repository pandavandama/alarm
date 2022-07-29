//
//  AlarmTableViewCell.swift
//  alarm
//
//  Created by Константин Кифа on 25.07.2022.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var switchAlarm: UISwitch!
    @IBOutlet weak var labelAlarm: UILabel!
    static let id = "AlarmTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: id, bundle: nil)
    }
    var changeEnabling: ((Bool?)->())?
    @IBAction func switchAction(_ sender: UISwitch) {
        changeEnabling?(sender.isOn)
    }
}
