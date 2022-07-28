//
//  MelodyViewController.swift
//  alarm
//
//  Created by Константин Кифа on 28.07.2022.
//

import UIKit

class MelodyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    private let musicCount = 6
    var alarmEditVC: AlarmEditViewController?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    let musicList: [String] = ["a1","a2","a3","a4","a5","soundtrack"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewHeight?.constant = tableView.contentSize.height-1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10.0
        tableView.tableHeaderView = UIView()
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableViewHeight?.constant = tableView.contentSize.height-1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musicCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        cell.textLabel?.text = musicList[indexPath.row]
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func playMusic(bool: Bool){
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        alarmEditVC?.innerData?.soundName = musicList[indexPath.row]
        playMusic(bool: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        playMusic(bool: false)
    }
}
