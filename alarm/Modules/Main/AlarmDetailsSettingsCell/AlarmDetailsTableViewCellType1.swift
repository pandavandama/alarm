//
//  AlarmDetailsTableViewCellType1.swift
//  alarm
//
//  Created by Константин Кифа on 26.07.2022.
//

import UIKit

class AlarmDetailsTableViewCellType1: UITableViewCell {
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var labelName: UILabel!
    static let id = "AlarmDetailsTableViewCellType1"
    static func nib() -> UINib{
        return UINib(nibName: id, bundle: nil)
    }
}
