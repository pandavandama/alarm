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

    var dayListFullNames: [String]?
    var dayListShortNames: [String]?
    var setRepeating: (([Int]?)->())?
    var repeating: [Int]?
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableViewHeight?.constant = tableView.contentSize.height-1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10.0
        tableView.tableHeaderView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dayListFullNames!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = dayListFullNames![indexPath.row]
        cell.textLabel?.textColor = .white
        for i in repeating!{
            if i == indexPath.row{
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        repeating = repeating!.uniqued()
        var isChecked = false
        for i in repeating!{
            if i == indexPath.row{
                isChecked = true
                break
            }else{
                isChecked = false
            }
        }
        if isChecked{
            cell!.accessoryType = .none
            repeating!.removeAll(where: {
                $0 == indexPath.row
            })
        }else{
            cell!.accessoryType = .checkmark
            repeating!.append(indexPath.row)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        repeating! = repeating!.sorted()
        setRepeating?(repeating!)
    }
}

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}
