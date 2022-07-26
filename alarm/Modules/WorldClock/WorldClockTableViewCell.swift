//
//  WorldClockTableViewCell.swift
//  alarm
//
//  Created by Константин Кифа on 26.07.2022.
//

import UIKit

class WorldClockTableViewCell: UITableViewCell {

    static let id = "WorldClockTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: id, bundle: nil)
    }
    
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindView(data: LocationData){
        
        var difference = ""
        if data.difference>0{
            difference = "+\(data.difference)"
        }else{
            difference = "\(data.difference)"
        }
        
        differenceLabel.text = "\(data.day), \(difference) Ч"
        cityLabel.text = data.city
        timeLabel.text = data.time
    }
    
}
