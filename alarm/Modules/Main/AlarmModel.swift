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
    var repeating: Int
    var name: String
    var soundName: String
    var index: Int?
}
