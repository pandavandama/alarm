//
//  AlarmModel.swift
//  alarm
//
//  Created by Константин Кифа on 25.07.2022.
//

import Foundation

struct SpecificAlarm: Codable{
    
    func shortNameDayRender(date: SpecificAlarm?) -> String{
        var stringDayListShortNames = "Никогда"
        
        guard let q = date else{
            return "Никогда"
        }
        var innerData = date
        innerData!.repeating! = innerData!.repeating!.sorted()
        
        if innerData!.repeating!.count == 1{
            stringDayListShortNames = dayListFullNames[innerData!.repeating![0]]
        }else
        if innerData?.repeating?.count != 0{
            stringDayListShortNames = ""
            for i in innerData!.repeating!{
                stringDayListShortNames += "\(dayListShortNames[i]) "
            }
        }
        print("help")
        print(innerData?.usaCalendarWeek())
        return stringDayListShortNames
    }
    
    var dayListShortNames: [String] = ["Пн","Вт","Ср","Чт","Пт","Сб","Вс"]
    var dayListFullNames: [String] = ["Каждый понедельник","Каждый вторник","Каждую среду","Каждый четверг","Каждую пятницу","Каждую субботу","Каждое воскресенье"]
    
    var date: Date
    var isEnabled: Bool
    var repeating: [Int]?
    var name: String
    var soundName: String
    var index: Int?
//    var isNeedToRepeat: Bool?
    
    func timestamp()->TimeInterval?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        return date.timeIntervalSince1970
    }
    func usaCalendarWeek() -> [Int]{
        var newArray: [Int] = []
        if var repeating = repeating {
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
}
