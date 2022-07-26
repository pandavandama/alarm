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
        timeLabel.text = self.data.time
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        data.isEnabled = sender.isOn
        mainVC?.editAlarmByIndex(index: data.index!, alarm: data)
    }
    
}
