//
//  AlarmEditViewController.swift
//  alarm
//
//  Created by Константин Кифа on 26.07.2022.
//

import UIKit

class AlarmEditViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var dayListShortNames: [String] = ["Пн","Вт","Ср","Чт","Пт","Сб","Вс"]
    var dayListFullNames: [String] = ["Каждый понедельник","Каждый вторник","Каждую среду","Каждый четверг","Каждую пятницу","Каждую субботу","Каждое воскресенье"]
    var dayListShortNamesOutput: [String] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()

    }
    
    func shortNameDayRender() -> String{
        var stringDayListShortNames = "Никогда"
        
        guard let q = innerData else{
            return "Никогда"
        }
        
        innerData!.repeating! = innerData!.repeating!.sorted()
        
        if innerData!.repeating!.count == 1{
            stringDayListShortNames = dayListFullNames[innerData!.repeating![0]]
        }else
        if innerData?.repeating?.count != 0{
            stringDayListShortNames = ""
            for i in innerData!.repeating!{
                stringDayListShortNames += "\(dayListShortNames[i]) "
            }
        }
        print("help")
        print(innerData?.usaCalendarWeek())
        return stringDayListShortNames
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: AlarmDetailsTableViewCellType1.id, for: indexPath) as! AlarmDetailsTableViewCellType1
            cell.labelName.text = actionsNamesList[indexPath.row]
            
            
            
            
            
            switch indexPath.row{
            case 0: cell.labelValue.text = shortNameDayRender()
            case 1: cell.labelValue.text = innerData?.name
            case 2: cell.labelValue.text = innerData?.soundName
            default: print("default")
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: AlarmDetailsTableViewCellType2.id, for: indexPath) as! AlarmDetailsTableViewCellType2
            cell.AlarmSettingsVC = self
            cell.labelName.text = actionsNamesList[indexPath.row]
            return cell
        }
    }
    
    var innerData: SpecificAlarm?
    var alarmListVC: AlarmViewController?
    var actionsNamesList: [String] = ["Повтор","Название","Мелодия","Повторение сигнала"]
    var indexPath: IndexPath?
    var isNew: Bool?
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var pickerTime: UIDatePicker!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        innerData!.date = pickerTime.date
        self.view.endEditing(true)
        if isNew! {
            alarmListVC!.addAlarm(alarm: innerData!)
            
        }else{
            alarmListVC!.editAlarmByIndex( alarm: innerData!)
        }
        dismiss(animated: true)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        alarmListVC?.deleteCellFromTable(indexPath: self.indexPath!)
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableViewHeight?.constant = tableView.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func openMelodyPopup(){
        guard let nameVC = self.storyboard?.instantiateViewController(withIdentifier: "AlarmMusicView") as? MelodyViewController else { return }
        nameVC.alarmEditVC = self
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"
        self.navigationController?.navigationBar.tintColor = .systemOrange
        self.navigationController?.pushViewController(nameVC, animated: true)
    }
    
    func openNamePopup(){
        guard let nameVC = self.storyboard?.instantiateViewController(withIdentifier: "AlarmNameView") as? AlarmNameViewController else { return }
        
        nameVC.alarmEditVC = self
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"
        self.navigationController?.navigationBar.tintColor = .systemOrange
        self.navigationController?.pushViewController(nameVC, animated: true)
    }
    
    func openRepeatingPopup(){
        guard let nameVC = self.storyboard?.instantiateViewController(withIdentifier: "AlarmRepeatingView") as? AlarmRepeatingViewController else { return }
        nameVC.alarmEditVC = self
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"
        self.navigationController?.navigationBar.tintColor = .systemOrange
        self.navigationController?.pushViewController(nameVC, animated: true)
    }
    
    func actionByIndex(index: Int){
        switch index{
        case 0: openRepeatingPopup()
        case 1: openNamePopup()
        case 2: openMelodyPopup()
        default: print("default")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actionByIndex(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configure(){
        pickerTime.locale = Locale.init(identifier: "en_GB")
        pickerTime.setValue(UIColor.white, forKeyPath: "textColor")
        
        deleteButton.layer.cornerRadius = 10.0
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func loadData(){
        guard innerData?.date != nil else {
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AlarmDetailsTableViewCellType1.nib(), forCellReuseIdentifier: AlarmDetailsTableViewCellType1.id)
        tableView.register(AlarmDetailsTableViewCellType2.nib(), forCellReuseIdentifier: AlarmDetailsTableViewCellType2.id)
        
        tableView.layer.cornerRadius = 10.0
        
        if innerData != nil{
            loadData()
            
        }
        
        pickerTime.date = innerData!.date
        
        configure()
    }
    
    func setData(data: SpecificAlarm){
        innerData = data
    }
}
