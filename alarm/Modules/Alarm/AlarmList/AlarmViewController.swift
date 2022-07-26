//
//  ViewController.swift
//  alarm
//
//  Created by Константин Кифа on 25.07.2022.
//

import UIKit

class AlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var alarmService = AlarmService.shared
    //Variables
    @IBOutlet weak var plusTabButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editTabButton: UIBarButtonItem!
    
    var dataList: [Alarm] = []
    var labelBigTitle: UILabel?
    
    //CycleVCMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        dataInit()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = makeHeaderTable(title: "Будильник")
        tableView.register(AlarmTableViewCell.nib(), forCellReuseIdentifier: AlarmTableViewCell.id)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.clear]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    //Actions
    @IBAction func addAlarmButtonClick(_ sender: UIBarButtonItem) {
        addAlarm()
    }
    
    @IBAction func editAlarmButtonClick(_ sender: UIBarButtonItem) {
        editAlarmMode()
    }
    
    //tableViewMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return dataList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.id, for: indexPath) as! AlarmTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        var data = dataList[indexPath.row]
        if indexPath.section == 0{
            cell.isUserInteractionEnabled = false
            let mockData = Alarm(date: Date.now, isEnabled: false,repeating: [],name: "Будильник(заглушка)",soundName: "1")
            cell.timeLabel.text = dateFormatter.string(from: mockData.date!)
            cell.labelAlarm.text = "\(mockData.name!), \(alarmService.shortNameDayRender(repeating: mockData.repeating!))"
            cell.switchAlarm.isOn = mockData.isEnabled!
            cell.selectionStyle = .none
        }else{
            cell.isUserInteractionEnabled = true
            cell.timeLabel.text = dateFormatter.string(from: data.date!)
            cell.labelAlarm.text = "\(data.name!), \(alarmService.shortNameDayRender(repeating: data.repeating!))"
            cell.switchAlarm.isOn = data.isEnabled!
            cell.changeEnabling = { bool in
                data.isEnabled = bool!
                self.editAlarm(alarm: data)
            }
            let backgroundView = UIView()
            backgroundView.backgroundColor = .darkGray
            cell.selectedBackgroundView = backgroundView
        }
        dataList[indexPath.row] = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        if section==0{
            title="Сон | пробуждение"
            let image = UIImage(systemName: "bed.double.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 2, weight: .bold, scale: .small))?.withTintColor(.white, renderingMode: .alwaysOriginal)
            label.addTextWithImage(text: title, image: image!, imageBehindText: false, keepPreviousText: false)
        }else{
            title="Другие"
            label.text = title
        }
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        headerView.addSubview(label)
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openAlarmDetails(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete"){ [weak self] (action,view,handler) in
            self!.deleteCellFromTable(index: indexPath.row)
        }
        delete.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [delete])
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return false
        }
        return true
    }
    
    //ScrollViewMethods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        labelBigTitle?.font = .boldSystemFont(ofSize: 30+(-scrollView.contentOffset.y/50))
        if scrollView.contentOffset.y > 40 && labelBigTitle?.textColor != .clear{
            labelBigTitle?.textColor = .clear
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }else if scrollView.contentOffset.y < 40 && labelBigTitle?.textColor == .clear{
            labelBigTitle?.textColor = .white
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.clear]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
    }
    
    //Other methods
    func addAlarm(alarm: Alarm){
        print(alarm)
        UsersDefaultsModel().setAlarmClock(data: alarm)
        self.dataInit()
        self.tableView.reloadData()
    }
    
    func editAlarm(alarm: Alarm){
        UsersDefaultsModel().editSpecificAlarmClock(newElement: alarm)
        print("KAVABANGA")
        self.dataInit()
        self.tableView.reloadData()
    }
    
    func dataInit(){
        dataList = UsersDefaultsModel().getAlarmAllAlarmClock()
    }
    
    func deleteCellFromTable(index: Int?){
        UsersDefaultsModel().removeFromAlarmList(index: index!)
        dataInit()
        tableView.reloadData()
    }
    
    func openAlarmDetails(indexPath: IndexPath){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlarmEditPopup") as? AlarmEditViewController else { return }
        vc.deleteCellByIndex = { index in
            self.deleteCellFromTable(index: index)
        }
        vc.editAlarm = { alarm in
            self.editAlarm(alarm: alarm!)
        }
        vc.setData(data: dataList[indexPath.row])
        vc.isNew = false
        let navController = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func openAlarmDetails(){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlarmEditPopup") as? AlarmEditViewController else { return }
        
        vc.addAlarm = { alarm in
            self.addAlarm(alarm: alarm!)
        }
        vc.setData(data: makeDefaultAlarm())
        vc.isNew = true
        let navController = UINavigationController(rootViewController: vc)
        vc.navigationItem.title = "Добавить"
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func makeHeaderTable(title: String) -> UIView{
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        header.backgroundColor = .clear
        labelBigTitle = UILabel(frame: header.bounds)
        labelBigTitle!.text = title
        labelBigTitle!.font = .boldSystemFont(ofSize: 30)
        labelBigTitle!.textColor = .white
        header.addSubview(labelBigTitle!)
        header.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: labelBigTitle!.frame.height)
        return header
    }
    
    func makeDefaultAlarm() -> Alarm{
        return Alarm(date: Date.now, isEnabled: true, repeating: [], name: "Будильник", soundName: "a1",isNeedToRepeat: false)
    }
    
    func addAlarm(){
        openAlarmDetails()
    }
    
    func editAlarmMode(){
        tableView.setEditing(!tableView.isEditing, animated: true)
        editTabButton.title = tableView.isEditing ? "Готово" : "Править"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}

extension UILabel {
    func addTextWithImage(text: String, image: UIImage, imageBehindText: Bool, keepPreviousText: Bool) {
        
        let lAttachment = NSTextAttachment()
        lAttachment.image = image
        
        // 1pt = 1.32px
        let lFontSize = round(self.font.pointSize * 0.70)
        let lRatio = image.size.width / image.size.height
        
        lAttachment.bounds = CGRect(x: 0, y: ((self.font.capHeight - lFontSize) / 2).rounded(), width: lRatio * lFontSize, height: lFontSize)
        
        let lAttachmentString = NSAttributedString(attachment: lAttachment)
        
        if imageBehindText {
            let lStrLabelText: NSMutableAttributedString
            
            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(string: text)
            }
            
            lStrLabelText.append(lAttachmentString)
            self.attributedText = lStrLabelText
        } else {
            let lStrLabelText: NSMutableAttributedString
            
            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(attributedString: lAttachmentString))
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(attributedString: lAttachmentString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            }
            
            self.attributedText = lStrLabelText
        }
    }
    
    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
