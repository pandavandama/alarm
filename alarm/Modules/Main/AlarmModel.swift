//
//  AlarmModel.swift
//  alarm
//
//  Created by Константин Кифа on 25.07.2022.
//

import Foundation

struct SpecificAlarm: Codable{
    var time: String
    var isEnabled: Bool
    var repeating: Int?
    var name: String
    var soundName: String
    var index: Int?
//    var isNeedToRepeat: Bool?
    
    func timestamp()->TimeInterval?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        print(Int(dateFormatter.date(from: time)!.timeIntervalSince1970))
        
        return dateFormatter.date(from: time)?.timeIntervalSince1970
    }
}
