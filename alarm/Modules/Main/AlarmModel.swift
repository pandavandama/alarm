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
        var newArray = repeating
        if var repeating = repeating {
            newArray[0]
            
        }
    }
}
