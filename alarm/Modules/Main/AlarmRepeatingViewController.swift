//
//  AlarmRepeatingViewController.swift
//  alarm
//
//  Created by Константин Кифа on 27.07.2022.
//

import UIKit

class AlarmRepeatingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    var alarmEditVC: AlarmEditViewController?
    
    
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    var arrayCheckedInt: [Int] = []
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableViewHeight?.constant = tableView.contentSize.height-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        cell.textLabel?.text = alarmEditVC?.dayListFullNames[indexPath.row]
        cell.textLabel?.textColor = .white
        for i in arrayCheckedInt{
            if i == indexPath.row{
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        arrayCheckedInt = arrayCheckedInt.uniqued()
        var isChecked = false
        for i in arrayCheckedInt{
            if i == indexPath.row{
                isChecked = true
                break
            }else{
                isChecked = false
            }
        }
        if isChecked{
            cell!.accessoryType = .none
            arrayCheckedInt.removeAll(where: {
                $0 == indexPath.row
            })
        }else{
            cell!.accessoryType = .checkmark
            arrayCheckedInt.append(indexPath.row)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        arrayCheckedInt = arrayCheckedInt.sorted()
        
        var namedArray: [String] = []
        for i in arrayCheckedInt{
            namedArray.append(alarmEditVC!.dayListShortNames[i])
        }
        alarmEditVC?.dayListShortNamesOutput = namedArray
        alarmEditVC?.innerData?.repeating = arrayCheckedInt
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10.0
        
        tableView.tableHeaderView = UIView()
        
        arrayCheckedInt = alarmEditVC!.innerData!.repeating!
        arrayCheckedInt = arrayCheckedInt.uniqued()
    }
}
public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}
