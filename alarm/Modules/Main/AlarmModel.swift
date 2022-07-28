//
//  AlarmModel.swift
//  alarm
//
//  Created by Константин Кифа on 25.07.2022.
//

import Foundation

struct SpecificAlarm: Codable{
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
