//
//  UsersDefaultsModel.swift
//  alarm
//
//  Created by Константин Кифа on 26.07.2022.
//

import Foundation

class UsersDefaultsModel{
    
    static let shared = UsersDefaultsModel()
    var alarmService = AlarmService.shared
    var usersDefaults = UserDefaults.standard
    
    func setAlarmClock(data: Alarm){
        print(data)
        var json = ""
        if usersDefaults.string(forKey: "AlarmList") != nil{
            var alarmList = getAlarmAllAlarmClock()
            alarmList.append(data)
            alarmList[alarmList.count-1].index = alarmList.count-1
            
            alarmList = alarmList.sorted(by: { Int(alarmService.timestamp(date:$0.date!)!) > Int(alarmService.timestamp(date:$1.date!)!) })
            
            UsersDefaultsModel.shared.updateNotificationList(alarmList: alarmList)
            let jsonData = try! JSONEncoder().encode(alarmList)
            json = String(data: jsonData, encoding: .utf8)!
        }else{
            var alarmList: [Alarm] = []
            alarmList.append(data)
            alarmList[0].index = 0
            UsersDefaultsModel.shared.updateNotificationList(alarmList: alarmList)
            let jsonData = try! JSONEncoder().encode(alarmList)
            json = String(data: jsonData, encoding: .utf8)!
        }
        usersDefaults.set(json, forKey: "AlarmList")
        
    }
    
    func editSpecificAlarmClock(newElement: Alarm){
        var json = ""
        var alarmList = getAlarmAllAlarmClock()
        alarmList[newElement.index!] = newElement
        alarmList = alarmList.sorted(by: { Int(alarmService.timestamp(date:$0.date!)!) > Int(alarmService.timestamp(date:$1.date!)!) })
        for i in 0..<alarmList.count{
            alarmList[i].index = i
        }
        UsersDefaultsModel.shared.updateNotificationList(alarmList: alarmList)
        let jsonData = try! JSONEncoder().encode(alarmList)
        json = String(data: jsonData, encoding: .utf8)!
        self.usersDefaults.set(json, forKey: "AlarmList")
    }
    
    func getAlarmAllAlarmClock() -> [Alarm]{
        
        let string = usersDefaults.string(forKey: "AlarmList")
        
        guard string != nil else{
            return []
        }
        var alarmList = try? JSONDecoder().decode([Alarm].self, from: string!.data(using: .utf8)!)
        return alarmList!
        
    }
    func removeFromAlarmList(index: Int){
        var json = ""
        var alarmList = getAlarmAllAlarmClock()
        print(alarmList)
        alarmList.remove(at: index)
        let jsonData = try! JSONEncoder().encode(alarmList)
        json = String(data: jsonData, encoding: .utf8)!
        usersDefaults.set(json, forKey: "AlarmList")
        
    }
    func updateNotificationList(alarmList: [Alarm]){
        
        var taskInitiator = TaskInitiator()
        taskInitiator.auth()
        taskInitiator.removeAllTasks()
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

        let calendar = Calendar.current
        
        for alarm in alarmList{
            guard alarm.isEnabled! else{
                break
            }
            dateComponents.hour = calendar.component(.hour, from: alarm.date!)
            dateComponents.minute = calendar.component(.minute, from: alarm.date!)
            if alarm.repeating!.count>0{
                let repeatingUSA = alarmService.usaCalendarWeek(repeating: alarm.repeating!)
                for i in repeatingUSA{
                    dateComponents.weekday = i
                    taskInitiator.addNewDateTask(title: alarm.name!, description: "Пора вставать", soundName: "\(alarm.soundName).caf", date: dateComponents,isNeedToRepeat: alarm.isNeedToRepeat!)
                }
            }
            else{
                dateComponents.weekday = calendar.component(.weekday, from: Date.now)
                dateComponents.month = calendar.component(.month,from: Date.now)
                dateComponents.year = calendar.component(.year,from: Date.now)
                taskInitiator.addNewDateTask(title: alarm.name!, description: "Пора вставать", soundName: "\(alarm.soundName).caf", date: dateComponents,isNeedToRepeat: alarm.isNeedToRepeat!)
            }
        }
        
    }
}
