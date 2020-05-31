//
//  WeatherModel.swift
//  Klim8
//
//  Created by Visal Rajapakse on 5/31/20.
//  Copyright © 2020 Visal Rajapakse. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId : Int
    let cityName : String
    let temperature : Double
    
    //use of computed properties
    var tempString : String {
        return String(format: "%.1f", temperature )
    }
    
    var conditionName : String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    //constructor
    init(_ conditionId: Int, _ cityName : String, _ temperature : Double) {
        self.conditionId = conditionId
        self.cityName = cityName
        self.temperature = temperature
    }
}
