//
//  ViewController.swift
//  alarm
//
//  Created by Константин Кифа on 25.07.2022.
//

import UIKit

class AlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var plusTabButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editTabButton: UIBarButtonItem!
    
    var dataList: [SpecificAlarm] = []
    var labelBigTitle: UILabel?
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(section)
        if section == 0{
            return 1
        }else{
            return dataList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.id, for: indexPath) as! AlarmTableViewCell
        
        if indexPath.section == 0{
            cell.isUserInteractionEnabled = false
            cell.bindView(data: SpecificAlarm(date: Date.now, isEnabled: false,repeating: 1,name: "Будильник(заглушка)",soundName: "1"))
            cell.selectionStyle = .none

        }else{
            cell.isUserInteractionEnabled = true
            print("render", dataList[indexPath.row])
            cell.bindView(data: dataList[indexPath.row])
            cell.mainVC = self
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .darkGray
                cell.selectedBackgroundView = backgroundView
        }
        
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
    
    func addAlarm(alarm: SpecificAlarm){
        UsersDefaultsModel().setAlarmClock(data: alarm)
        self.dataInit()
        self.tableView.reloadData()
    }
    
    func editAlarmByIndex(alarm: SpecificAlarm){
            UsersDefaultsModel().editSpecificAlarmClock(newElement: alarm)
            self.dataInit()
            self.tableView.reloadData()
        
    }
    
    
    
    func dataInit(){
        dataList = UsersDefaultsModel().getAlarmAllAlarmClock()
        print("START WITH ", dataList)


    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return false
        }
        return true
    }
    
    func deleteCellFromTable(indexPath: IndexPath){
        UsersDefaultsModel().removeFromAlarmList(index: indexPath.row)
        dataInit()
        tableView.reloadData()
    }
    
    func openAlarmDetails(indexPath: IndexPath){
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "AlarmEditPopup") as? AlarmEditViewController else { return }
        myVC.setData(data: dataList[indexPath.row])
        myVC.alarmListVC = self
        myVC.isNew = false
        let navController = UINavigationController(rootViewController: myVC)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    func openAlarmDetails(){
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "AlarmEditPopup") as? AlarmEditViewController else { return }
        myVC.alarmListVC = self
        myVC.setData(data: makeDefaultAlarm())
        myVC.isNew = true
        let navController = UINavigationController(rootViewController: myVC)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        openAlarmDetails(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete"){ [weak self] (action,view,handler) in
            self!.deleteCellFromTable(indexPath: indexPath)
            
        }
        delete.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [delete])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        dataInit()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = makeHeaderTable(title: "Будильник")
        tableView.register(AlarmTableViewCell.nib(), forCellReuseIdentifier: AlarmTableViewCell.id)
        
//        tableView.reloadData()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        labelBigTitle?.font = .boldSystemFont(ofSize: 30+(-scrollView.contentOffset.y/50))
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
    
    
    @IBAction func addAlarmButtonClick(_ sender: UIBarButtonItem) {
        addAlarm()
    }
    
    @IBAction func editAlarmButtonClick(_ sender: UIBarButtonItem) {
        editAlarm()
    }
    
    func makeDefaultAlarm() -> SpecificAlarm{
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        
        
        
        return SpecificAlarm(date: Date.now, isEnabled: false, repeating: 1, name: "Будильник", soundName: "sound name")
    }
    
    func addAlarm(){
        
        openAlarmDetails()
        print("Add alarm")
    }
    func editAlarm(){
        print("Edit alarm")
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
