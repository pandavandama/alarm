//
//  TaskInitiator.swift
//  alarm
//
//  Created by Константин Кифа on 28.07.2022.
//

import Foundation

class TaskInitiator{
    var showNotificationSettingsUI = false
    var reminderEnabled = true
    var selectedTrigger = ReminderType.calendar
    let timeDurations: [Int] = Array(1...59)
    var timeDurationIndex: Int = 0
    private var dateTrigger: DateComponents?
    private var shouldRepeat = true
    var taskName: String = "test"
    var taskManager = TaskManager.shared
    var notificationManager = NotificationManager.shared
    var taskDescription = "description"
    var soundName = "a1.aiff"
    
    func addNewDateTask(title: String, description: String, soundName: String, date: DateComponents){
        taskName = title
        dateTrigger = date
        taskDescription = description
        self.soundName = soundName
        print("sushestvuet ",taskManager.tasks)
        //            dateTrigger = Calendar.current.date(byAdding: .second, value: 10, to: .now)!
        
        
        taskManager.addNewTask(taskName, makeReminder())
    }
    
    
    func removeAllTasks(){
        for t in taskManager.tasks{
            taskManager.remove(task: t)
        }
    }
    private func makeReminder() -> Reminder? {
        guard reminderEnabled else {
            return nil
        }
        var reminder = Reminder()
        reminder.soundName = "a1.caf"
        reminder.reminderType = selectedTrigger
        reminder.description = taskDescription
        switch selectedTrigger {
        case .time:
            reminder.timeInterval = TimeInterval(timeDurations[timeDurationIndex] * 60)
        case .calendar:
            reminder.date = dateTrigger
        }
        reminder.repeats = shouldRepeat
        return reminder
    }
    
    func auth(){
        NotificationManager.shared.requestAuthorization { granted in
            // 2
            if granted {
                print("Authenticated")
            }
        }
    }
}
