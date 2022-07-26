//
//  WorldClockModel.swift
//  alarm
//
//  Created by Константин Кифа on 26.07.2022.
//

import Foundation

struct LocationData: Decodable{
    let city: String
    let country: String
    var time: String?
    var day: String?
    let difference: Int
}

class WorldClockModel{
    static let share = WorldClockModel()
    
    
    private var locations: [LocationData] = []
    private let json: String = """
    
    [
    {
        "city": "Нью-Йорк",
        "country": "США",
        "difference": -7
    },
    {
        "city": "Акапулько",
        "country": "США",
        "difference": -8
    },
    {
        "city": "Сидней",
        "country": "Австралия",
        "difference": 7
    },
    {
        "city": "Кишинев",
        "country": "Молдова",
        "difference": 0
    },
    {
        "city": "Лондон",
        "country": "Англия",
        "difference": -2
    }
    
    ]
    """
    private func parseLocations(string: String) -> [LocationData]{
        return try! JSONDecoder().decode([LocationData].self, from: string.data(using: .utf8)!)
    }
    private func dataProcessing(){
        locations = parseLocations(string: json)
        
        for i in 0..<locations.count{
            var minute = Calendar.current.component(.minute, from: Date())
            var hour = Calendar.current.component(.hour, from: Date())
            
            hour += locations[i].difference
            locations[i].day = "Сегодня"

            if hour>23{
                hour = 0 + hour - 24
                locations[i].day = "Вчера"
            } else if hour<0{
                hour = 24 + hour
                locations[i].day = "Завтра"
            }
            
            locations[i].time = "\(hour):\(minute)"
            
            
        }
    }
    
    
    func getLocations()->[LocationData]{
        dataProcessing()
        return locations
    }
}
