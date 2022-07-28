//
//  UsersDefaultsModel.swift
//  alarm
//
//  Created by Константин Кифа on 26.07.2022.
//

import Foundation

class UsersDefaultsModel{
    
    static let shared = UsersDefaultsModel()
    
    var usersDefaults = UserDefaults.standard
    
    func setAlarmClock(data: SpecificAlarm){
        print("sha dobavit")
        var json = ""
        if usersDefaults.string(forKey: "AlarmList") != nil{
            
            var alarmList = getAlarmAllAlarmClock()
            alarmList.append(data)
            alarmList[alarmList.count-1].index = alarmList.count-1
            UsersDefaultsModel.shared.updateNotificationList(alarmList: alarmList)
            
            print("pochemunil ",alarmList)
            let jsonData = try! JSONEncoder().encode(alarmList)
            json = String(data: jsonData, encoding: .utf8)!
        }else{
            print("AAAAAAAAAAA")
            var alarmList: [SpecificAlarm] = []
            
            alarmList.append(data)
            alarmList[0].index = 0
            UsersDefaultsModel.shared.updateNotificationList(alarmList: alarmList)
            
            let jsonData = try! JSONEncoder().encode(alarmList)
            json = String(data: jsonData, encoding: .utf8)!
        }
        usersDefaults.set(json, forKey: "AlarmList")
        
    }
    
    func editSpecificAlarmClock(newElement: SpecificAlarm){
        var json = ""
        var alarmList = getAlarmAllAlarmClock()
        alarmList[newElement.index!] = newElement
        alarmList = alarmList.sorted(by: { Int($0.timestamp()!) > Int($1.timestamp()!) })
        for i in 0..<alarmList.count{
            alarmList[i].index = i
        }
        UsersDefaultsModel.shared.updateNotificationList(alarmList: alarmList)
        let jsonData = try! JSONEncoder().encode(alarmList)
        json = String(data: jsonData, encoding: .utf8)!
        self.usersDefaults.set(json, forKey: "AlarmList")
        
//        var taskInit = TaskInitiator()
        
        
        
    }
    
    func getAlarmAllAlarmClock() -> [SpecificAlarm]{
        
        let string = usersDefaults.string(forKey: "AlarmList")
        
        guard string != nil else{
            return []
        }
        
        var alarmList = try? JSONDecoder().decode([SpecificAlarm].self, from: string!.data(using: .utf8)!)
        print("jopa2,",alarmList)
        
        return alarmList!
        
    }
    func removeFromAlarmList(index: Int){
        var json = ""
        var alarmList = getAlarmAllAlarmClock()
        
        alarmList.remove(at: index)
        let jsonData = try! JSONEncoder().encode(alarmList)
        json = String(data: jsonData, encoding: .utf8)!
        print(alarmList)
        usersDefaults.set(json, forKey: "AlarmList")
        
    }
    func updateNotificationList(alarmList: [SpecificAlarm]){
        
        var taskInitiator = TaskInitiator()
        taskInitiator.auth()
        
        taskInitiator.removeAllTasks()
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        //        var dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat =  "HH:mm"
        //        let date = D()
        let calendar = Calendar.current
        //        let components = calendar.components(.Hour, fromDate: date)
        //        let hour = components.hour
        
        print("ALOBLEA")
        
        for alarm in alarmList{
            print(calendar.component(.hour, from: alarm.date))
            print("Ia hociu zjiti")
            
            guard alarm.isEnabled else{
                print("otmena")
                
                break
            }
            dateComponents.hour = calendar.component(.hour, from: alarm.date)
            dateComponents.minute = calendar.component(.minute, from: alarm.date)
            print("iii",alarm.repeating?.count)
            if alarm.repeating!.count>0{
                
                for i in alarm.usaCalendarWeek(){
                    
                    
                    dateComponents.weekday = i
                    
                    
                    taskInitiator.addNewDateTask(title: alarm.name, description: "Пора вставать", soundName: "\(alarm.soundName).aiff", date: dateComponents)
                }
                print(dateComponents)
            }
            else{
                print("iiii")
                dateComponents.weekday = calendar.component(.weekday, from: Date.now)
                dateComponents.month = calendar.component(.month,from: Date.now)
                dateComponents.year = calendar.component(.year,from: Date.now)

                taskInitiator.addNewDateTask(title: alarm.name, description: "Пора вставать", soundName: "\(alarm.soundName).aiff", date: dateComponents)
                print(dateComponents)
            }
            
            
            
        }
        
        
        
    }
}
