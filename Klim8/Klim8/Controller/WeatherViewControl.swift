//
//  ViewController.swift
//  Klim8
//
//  Created by Visal Rajapakse on 5/24/20.
//  Copyright © 2020 Visal Rajapakse. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewControl: UIViewController {
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting delegates
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        weatherManager.delegate = self
        searchTextField.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    @IBAction func currentLocationPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
}

//MARK:- UITextFieldDelegate
extension WeatherViewControl : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if  textField.text != "" {
            return true
        }else{
            textField.placeholder = "Type a City"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text=""
    }
}

//MARK:-  WeatherManagerDelegate
extension WeatherViewControl : WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager, weather : WeatherModel){
        //DispatchQueue.main.async for asynchronous updating of the user interface
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.cityLabel.text? = weather.cityName.uppercased()
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK:- CLLocationManagerDelegate
//both delegate functions are necessary for getting the location
extension WeatherViewControl : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat, lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

