//
//  AlarmDetailsSettingsTableViewCellType2.swift
//  alarm
//
//  Created by Константин Кифа on 26.07.2022.
//

import UIKit

class AlarmDetailsTableViewCellType2: UITableViewCell {

    static let id = "AlarmDetailsTableViewCellType2"
    
    static func nib() -> UINib{
        return UINib(nibName: id, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
