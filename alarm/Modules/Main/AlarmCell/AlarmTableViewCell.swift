//
//  AlarmTableViewCell.swift
//  alarm
//
//  Created by Константин Кифа on 25.07.2022.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

    static let id = "AlarmTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: id, bundle: nil)
    }
    var data: SpecificAlarm!
    var mainVC: AlarmViewController?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var switchAlarm: UISwitch!
    @IBOutlet weak var labelAlarm: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func bindView(data: SpecificAlarm){
        self.data = data
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat =  "HH:mm"
        timeLabel.text = dateFormatter.string(from: self.data.date)
        labelAlarm.text = self.data.name
        switchAlarm.isOn = self.data.isEnabled
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        print("clicked")
        self.data.isEnabled = sender.isOn
        mainVC?.editAlarmByIndex(alarm: data)
    }
    
}
