//
//  AlarmService.swift
//  alarm
//
//  Created by Константин Кифа on 30.07.2022.
//

import Foundation

class AlarmService{
    
    static let shared = AlarmService()
    
    let dayListShortNames: [String] = ["Пн","Вт","Ср","Чт","Пт","Сб","Вс"]
    let dayListFullNames: [String] = ["Каждый понедельник","Каждый вторник","Каждую среду","Каждый четверг","Каждую пятницу","Каждую субботу","Каждое воскресенье"]
    let actionsNamesList: [String] = ["Повтор","Название","Мелодия","Повторение сигнала"]

    func timestamp(date: Date)->TimeInterval?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        return date.timeIntervalSince1970
    }
    
    func usaCalendarWeek(repeating: [Int]?) -> [Int]{
        var newArray: [Int] = []
        if let repeating = repeating{
            for i in repeating{
                var edit = i + 2
                if edit == 8 {
                    edit = 1
                }
                newArray.append(edit)
            }
        }
        return newArray.sorted()
    }

    func shortNameDayRender(repeating: [Int]) -> String{
        var stringDayListShortNames = "Никогда"
        if repeating.count == 1{
            stringDayListShortNames = dayListFullNames[repeating[0]]
        }else
        if repeating.count != 0{
            stringDayListShortNames = ""
            for i in repeating{
                stringDayListShortNames += "\(dayListShortNames[i]) "
            }
        }
        return stringDayListShortNames
    }

    func updateAlarmInSystem(alarm: Alarm){
        
    }
    func getAlarmsFromSystem()->[Alarm]{
        
        return []
    }
}
