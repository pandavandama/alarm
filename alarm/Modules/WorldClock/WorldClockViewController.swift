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
        test()
    }
    
    
    
    var showNotificationSettingsUI = false
    var reminderEnabled = true
    var selectedTrigger = ReminderType.calendar
    let timeDurations: [Int] = Array(1...59)
    var timeDurationIndex: Int = 0
    private var dateTrigger = Date.now
    private var shouldRepeat = true
    var taskName: String = "test"
    var taskManager = TaskManager.shared
    
    func test(){
        NotificationManager.shared.requestAuthorization { granted in
          // 2
          if granted {
          }
        }
//        var dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        print(Date.now)
//        print(dateFormatter.timeZone)
        print(dateTrigger)
        dateTrigger = Calendar.current.date(byAdding: .second, value: 10, to: .now)!
        
        print(makeReminder())
//        print(Calendar.Component.minute)
        
                for t in taskManager.tasks{
                    taskManager.remove(task: t)
                }
        taskManager.addNewTask(taskName, makeReminder())
        
//        for t in taskManager.tasks{
//            taskManager.remove(task: t)
//        }
        print("spisok",taskManager.tasks)
//        presentationMode.wrappedValue.dismiss()
    }
    
    func makeReminder() -> Reminder? {
      guard reminderEnabled else {
        return nil
      }
      var reminder = Reminder()
      reminder.reminderType = selectedTrigger
      switch selectedTrigger {
      case .time:
        reminder.timeInterval = TimeInterval(timeDurations[timeDurationIndex] * 60)
      case .calendar:
        reminder.date = dateTrigger
      }
      reminder.repeats = shouldRepeat
      return reminder
    }
    
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


