//
//  WorldClockViewController.swift
//  alarm
//
//  Created by Константин Кифа on 26.07.2022.
//

import UIKit

class WorldClockViewController: UIViewController
, UITableViewDelegate, UITableViewDataSource
{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WorldClockModel.share.getLocations().count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorldClockTableViewCell.id, for: indexPath) as! WorldClockTableViewCell
        
        cell.bindView(data: WorldClockModel.share.getLocations()[indexPath.row])
        return cell
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Calendar.current.component(.hour, from: Date()))
        WorldClockModel.share.getLocations()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WorldClockTableViewCell.nib(), forCellReuseIdentifier: WorldClockTableViewCell.id)
        // Do any additional setup after loading the view.
//        test()
    }
    
    
    
    
    
//    func test(){
//        
//        dateTrigger = Calendar.current.date(byAdding: .second, value: 10, to: .now)!
//        
//        for t in taskManager.tasks{
//            taskManager.remove(task: t)
//        }
//        taskManager.addNewTask(taskName, makeReminder())
//    }
    
    
    
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


