//
//  AlarmRepeatingViewController.swift
//  alarm
//
//  Created by Константин Кифа on 27.07.2022.
//

import UIKit

class AlarmRepeatingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var innerData: SpecificAlarm?
    var alarmEditVC: AlarmEditViewController?
    var checked = [Bool](repeating: false, count: 7)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableViewHeight?.constant = tableView.contentSize.height-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        cell.textLabel?.text = "privet"
        cell.accessoryType = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if checked[indexPath.row]{
            cell!.accessoryType = .none
            checked[indexPath.row] = false
        }else{
            cell!.accessoryType = .checkmark
            checked[indexPath.row] = true

        }
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10.0

        tableView.tableHeaderView = UIView()
        
//        let footerView = UIView()
//            footerView.translatesAutoresizingMaskIntoConstraints = false
//            footerView.heightAnchor.constraint(equalToConstant: 9).isActive = true
//
//            tableView.tableFooterView = footerView


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
