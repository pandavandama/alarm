//
//  TaskInitiator.swift
//  alarm
//
//  Created by Константин Кифа on 28.07.2022.
//

import Foundation

class TaskInitiator{
    var reminderEnabled = true
    let timeDurations: [Int] = Array(1...59)
    var timeDurationIndex: Int = 0
    private var dateTrigger: DateComponents?
    private var shouldRepeat = true
    var taskName: String = "test"
    var taskManager = TaskManager.shared
    var notificationManager = NotificationManager.shared
    var taskDescription = "description"
    var soundName = "a1.aiff"
    var isNeedToRepeat = false
    
    func addNewDateTask(title: String, description: String, soundName: String, date: DateComponents, isNeedToRepeat: Bool){
        self.isNeedToRepeat = isNeedToRepeat
        taskName = title
        dateTrigger = date
        taskDescription = description
        self.soundName = soundName
        taskManager.addNewTask(taskName, makeReminder())
    }
    
    func removeAllTasks(){
        for t in taskManager.tasks{
            taskManager.remove(task: t)
        }
    }
    private func makeReminder() -> Alarm? {
        guard reminderEnabled else {
            return nil
        }
        var reminder = Alarm()
        reminder.soundName = soundName
        reminder.description = taskDescription
        reminder.dateComponents = dateTrigger
        reminder.isNeedToRepeat = isNeedToRepeat
        return reminder
    }
    
    func auth(){
        NotificationManager.shared.requestAuthorization { granted in
            if granted {
                print("Authenticated")
            }
        }
    }
}
