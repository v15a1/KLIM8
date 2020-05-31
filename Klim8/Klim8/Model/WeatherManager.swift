//
//  WeatherManager.swift
//  Klim8
//
//  Created by Visal Rajapakse on 5/31/20.
//  Copyright © 2020 Visal Rajapakse. All rights reserved.
//

import Foundation

struct WeatherManager {
    //url with the api key
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=9e58677a990c0354e56ac5040bc8bdd6"
    
    var delegate : WeatherManagerDelegate?
    
    //overloaded functions to get the weather with either city name or latitude or longitude
    func  fetchWeather(cityName : String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with :urlString)
    }
    
    func fetchWeather(_ latitude : Double, _ longitude : Double){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with :urlString)
    }
    
    //function to perform the asynchronous request
    func performRequest( with urlString : String) {
        print(urlString)
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, res, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    //function to parse the retrieved data
    func parseJSON(_ weatherData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let conditionId = decodedData.weather[0].id
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
            let weatherModel = WeatherModel(conditionId, cityName, temperature)
            return weatherModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}

//protocols to implement
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager, weather : WeatherModel)
    func didFailWithError(error: Error)
}
