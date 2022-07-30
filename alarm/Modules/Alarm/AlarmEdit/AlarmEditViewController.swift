//
//  AlarmEditViewController.swift
//  alarm
//
//  Created by Константин Кифа on 26.07.2022.
//

import UIKit

class AlarmEditViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let alarmService = AlarmService.shared
    
    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var pickerTime: UIDatePicker!
    @IBOutlet weak private var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak private var tableView: UITableView!
    
    @IBAction private func  backAction(_ sender: UIBarButtonItem) {
        dismissView()
    }
    
    @IBAction private func saveAction(_ sender: UIBarButtonItem) {
        saveAlarm()
    }
    
    @IBAction private func deleteAction(_ sender: UIButton) {
        deleteAlarm()
    }

    private var innerData: Alarm?
    var isNew: Bool?
    var editAlarm: ((Alarm?)->())?
    var addAlarm: ((Alarm?)->())?
    var deleteCellByIndex: ((Int?)->())?
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInit()
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
            cell.labelName.text = alarmService.actionsNamesList[indexPath.row]
            switch indexPath.row{
            case 0: cell.labelValue.text = alarmService.shortNameDayRender(repeating: innerData!.repeating!)
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
            cell.labelName.text = alarmService.actionsNamesList[indexPath.row]
            cell.switchElement.isOn = innerData!.isNeedToRepeat!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func reloadData(){
        tableView.reloadData()
        deleteButton.isEnabled = !isNew!
    }
    
    private func dismissView(){
        self.dismiss(animated: true)
    }
    
    private func tableViewInit(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlarmDetailsTableViewCellType1.nib(), forCellReuseIdentifier: AlarmDetailsTableViewCellType1.id)
        tableView.register(AlarmDetailsTableViewCellType2.nib(), forCellReuseIdentifier: AlarmDetailsTableViewCellType2.id)
        tableView.layer.cornerRadius = 10.0
    }
    
    private func saveAlarm(){
        innerData!.date = pickerTime.date
        isNew! ? addAlarm?(innerData) : editAlarm?(innerData)
        dismissView()
    }
    
    private func deleteAlarm(){
        deleteCellByIndex?(innerData?.index)
        dismissView()
    }
    
    private func initSoundPopup() -> UIViewController?{
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlarmMusicView") as? MelodyViewController else { return nil }
        vc.changeMusicName = { soundName in
            self.innerData?.soundName = soundName!
        }
        vc.selectedSoundName = innerData?.soundName
        return vc
    }
    
    private func initNamePopup() -> UIViewController?{
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlarmNameView") as? AlarmNameViewController else { return nil}
        vc.changeName = { name in
            self.innerData?.name = name!
            self.reloadData()
        }
        vc.name = innerData?.name
        return vc
    }
    
    private func initRepeatingPopup() -> UIViewController?{
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlarmRepeatingView") as? AlarmRepeatingViewController else { return nil}
        vc.dayListFullNames = alarmService.dayListFullNames
        vc.dayListShortNames = alarmService.dayListShortNames
        vc.repeating = innerData?.repeating?.uniqued()
        vc.setRepeating = { repeating in
            self.innerData?.repeating = repeating
        }
        return vc
    }
    
    private func navigationToVc(_ vc: UIViewController){
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"
        self.navigationController?.navigationBar.tintColor = .systemOrange
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func actionByIndex(index: Int){
        switch index{
        case 0: navigationToVc(initRepeatingPopup()!)
        case 1: navigationToVc(initNamePopup()!)
        case 2: navigationToVc(initSoundPopup()!)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actionByIndex(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func configure(){
        pickerTimeInit()
        navBarInit()
        deleteButton.layer.cornerRadius = 10.0
    }
    
    private func pickerTimeInit(){
        pickerTime.locale = Locale.init(identifier: "en_GB")
        pickerTime.setValue(UIColor.white, forKeyPath: "textColor")
        pickerTime.date = innerData!.date!
    }
    
    private func navBarInit(){
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func setData(data: Alarm){
        innerData = data
    }
}
