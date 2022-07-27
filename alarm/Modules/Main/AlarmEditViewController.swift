//
//  AlarmEditViewController.swift
//  alarm
//
//  Created by Константин Кифа on 26.07.2022.
//

import UIKit

class AlarmEditViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: AlarmDetailsTableViewCellType1.id, for: indexPath) as! AlarmDetailsTableViewCellType1
//            let bgColorView = UIView()
//            bgColorView.backgroundColor = .black
//            cell.selectedBackgroundView = bgColorView
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: AlarmDetailsTableViewCellType2.id, for: indexPath) as! AlarmDetailsTableViewCellType2
            return cell
        }
        
        
    }
    var alarmListVC: AlarmViewController?
    var indexPath: IndexPath?

    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var pickerTime: UIDatePicker!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        tableView.backgroundColor = .black
        
        tableView.register(AlarmDetailsTableViewCellType1.nib(), forCellReuseIdentifier: AlarmDetailsTableViewCellType1.id)
        tableView.register(AlarmDetailsTableViewCellType2.nib(), forCellReuseIdentifier: AlarmDetailsTableViewCellType2.id)
        
        tableView.layer.cornerRadius = 10.0

        
        
        pickerTime.locale = Locale.init(identifier: "en_GB")
        pickerTime.setValue(UIColor.white, forKeyPath: "textColor")
        
        deleteButton.layer.cornerRadius = 10.0
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes


        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
