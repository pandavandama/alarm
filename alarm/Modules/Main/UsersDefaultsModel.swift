//
//  UsersDefaultsModel.swift
//  alarm
//
//  Created by Константин Кифа on 26.07.2022.
//

import Foundation

class UsersDefaultsModel{
    
    var usersDefaults = UserDefaults.standard
    
    func setAlarmClock(data: SpecificAlarm){
        
        var json = ""
        
        if let alarmList = usersDefaults.string(forKey: "AlarmList"){
            print("filled")
            var alarmList = getAlarmAllAlarmClock()
            alarmList.append(data)
            let jsonData = try! JSONEncoder().encode(alarmList)
            json = String(data: jsonData, encoding: .utf8)!
            print(alarmList)
        }else{
            print("empty")
            var alarmList: [SpecificAlarm] = []
            alarmList.append(data)
            let jsonData = try! JSONEncoder().encode(alarmList)
            json = String(data: jsonData, encoding: .utf8)!
            print("test 123",alarmList)
        }
        
        usersDefaults.set(json, forKey: "AlarmList")
        
    }
    
    func editSpecificAlarmClock(index: Int,newElement: SpecificAlarm){
        var json = ""
        
        var alarmList = getAlarmAllAlarmClock()
        alarmList[index] = newElement
        let jsonData = try! JSONEncoder().encode(alarmList)
        json = String(data: jsonData, encoding: .utf8)!
    }
    
    func getAlarmAllAlarmClock() -> [SpecificAlarm]{
        var string = usersDefaults.string(forKey: "AlarmList")
        print(string)
        var alarmList = try? JSONDecoder().decode([SpecificAlarm].self, from: string!.data(using: .utf8)!)
        
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
}
