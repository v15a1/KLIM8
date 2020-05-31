//
//  WeatherData.swift
//  Klim8
//
//  Created by Visal Rajapakse on 5/31/20.
//  Copyright © 2020 Visal Rajapakse. All rights reserved.
//

import Foundation

//structs to access JSON data values
struct WeatherData : Codable {
    let name : String
    let main : Main
    let weather : [Weather]
    
}

struct Main : Codable {
    let temp : Double
}

struct Weather : Codable {
    let id : Int
}


