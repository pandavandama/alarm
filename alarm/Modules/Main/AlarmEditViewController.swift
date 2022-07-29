//
//  AlarmEditViewController.swift
//  alarm
//
//  Created by Константин Кифа on 26.07.2022.
//

import UIKit

class AlarmEditViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var pickerTime: UIDatePicker!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        saveAlarm()
    }
    @IBAction func deleteAction(_ sender: UIButton) {
        deleteAlarm()
    }
    
    private var innerData: SpecificAlarm?
    var actionsNamesList: [String] = ["Повтор","Название","Мелодия","Повторение сигнала"]
    var isNew: Bool?
    var editAlarm: ((SpecificAlarm?)->())?
    var addAlarm: ((SpecificAlarm?)->())?
    var deleteCellByIndex: ((Int?)->())?
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        deleteButton.isEnabled = !isNew!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AlarmDetailsTableViewCellType1.nib(), forCellReuseIdentifier: AlarmDetailsTableViewCellType1.id)
        tableView.register(AlarmDetailsTableViewCellType2.nib(), forCellReuseIdentifier: AlarmDetailsTableViewCellType2.id)
        
        tableView.layer.cornerRadius = 10.0
        
        pickerTime.date = innerData!.date
        configure()
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableViewHeight?.constant = tableView.contentSize.height
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: AlarmDetailsTableViewCellType1.id, for: indexPath) as! AlarmDetailsTableViewCellType1
            cell.labelName.text = actionsNamesList[indexPath.row]
            switch indexPath.row{
            case 0: cell.labelValue.text = innerData?.shortNameDayRender()
            case 1: cell.labelValue.text = innerData?.name
            case 2: cell.labelValue.text = innerData?.soundName
            default: break
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: AlarmDetailsTableViewCellType2.id, for: indexPath) as! AlarmDetailsTableViewCellType2
            cell.callback = { newValue in
                self.innerData?.isNeedToRepeat = newValue
            }
            cell.labelName.text = actionsNamesList[indexPath.row]
            cell.switchElement.isOn = innerData!.isNeedToRepeat!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    func saveAlarm(){
        innerData!.date = pickerTime.date
        isNew! ? addAlarm?(innerData) : editAlarm?(innerData)
        dismiss(animated: true)
    }
    func deleteAlarm(){
        deleteCellByIndex?(innerData?.index)
        self.dismiss(animated: true)
    }
    func openMelodyPopup(){
        guard let nameVC = self.storyboard?.instantiateViewController(withIdentifier: "AlarmMusicView") as? MelodyViewController else { return }
        nameVC.changeMusicName = { soundName in
            self.innerData?.soundName = soundName!
        }
        nameVC.selectedSoundName = innerData?.soundName
        navigationToVc(VC: nameVC)
    }
    
    func openNamePopup(){
        guard let nameVC = self.storyboard?.instantiateViewController(withIdentifier: "AlarmNameView") as? AlarmNameViewController else { return }
        nameVC.changeName = { name in
            self.innerData?.name = name!
            self.tableView.reloadData()
        }
        nameVC.name = innerData?.name
        navigationToVc(VC: nameVC)
    }
    
    func openRepeatingPopup(){
        guard let nameVC = self.storyboard?.instantiateViewController(withIdentifier: "AlarmRepeatingView") as? AlarmRepeatingViewController else { return }
        nameVC.dayListFullNames = innerData?.dayListFullNames
        nameVC.dayListShortNames = innerData?.dayListShortNames
        nameVC.repeating = innerData?.repeating?.uniqued()
        nameVC.setRepeating = { repeating in
            self.innerData?.repeating = repeating
        }
        navigationToVc(VC: nameVC)
    }
    
    func navigationToVc(VC: UIViewController){
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"
        self.navigationController?.navigationBar.tintColor = .systemOrange
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func actionByIndex(index: Int){
        switch index{
        case 0: openRepeatingPopup()
        case 1: openNamePopup()
        case 2: openMelodyPopup()
        default: break
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

    func setData(data: SpecificAlarm){
        innerData = data
    }
}
