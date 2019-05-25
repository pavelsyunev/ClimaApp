//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Weather constants
    //let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "f856e155f5c5001294552aa4b040bd9d"
    
    //Forecast constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast"
    //let APP_ID = "f856e155f5c5001294552aa4b040bd9d"
    
    /***Get your own App ID at https://openweathermap.org/appid ****/
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    //@IBOutlet weak var forecastTemp: UITableView!
    @IBOutlet weak var dayOneForecast: UILabel!
    @IBOutlet weak var dayTwoForecast: UILabel!
    @IBOutlet weak var dayThreeForecast: UILabel!
    @IBOutlet weak var dayFourForecast: UILabel!
    @IBOutlet weak var dayFiveForecast: UILabel!
    
    @IBOutlet weak var dayOneTemp: UILabel!
    @IBOutlet weak var dayTwoTemp: UILabel!
    @IBOutlet weak var dayThreeTemp: UILabel!
    @IBOutlet weak var dayFourTemp: UILabel!
    @IBOutlet weak var dayFiveTemp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - Networking
    /***************************************************************/
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                //print("Success, got the weather data!")
                let weatherJSON : JSON = JSON(response.result.value!)
                //print("This is JSON data: ", weatherJSON)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    //Write the updateWeatherData method here:
    
    //    func updateWeatherData(json : JSON) {
    //        if let tempResult = json["main"]["temp"].double {
    //            weatherDataModel.temperature = Int(tempResult - 273.15)
    //            weatherDataModel.city = json["name"].stringValue
    //            weatherDataModel.condition = json["weather"][0]["id"].intValue
    //            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
    //            updateUIWithWeatherData()
    //        }
    //        else {
    //            cityLabel.text = "Weather Unavailable"
    //        }
    //    }
    
    
    func updateWeatherData(json : JSON) {
        
        //Get time
        let arrayTime = json["list"].arrayValue.map {$0["dt_txt"].stringValue}
        let singlTimeOne = arrayTime[1].components(separatedBy: " ")
        let singlTimeTwo = arrayTime[2].components(separatedBy: " ")
        let singlTimeThree = arrayTime[3].components(separatedBy: " ")
        let singlTimeFour = arrayTime[4].components(separatedBy: " ")
        let singlTimeFive = arrayTime[5].components(separatedBy: " ")
        
        dayOneForecast.text = singlTimeOne.last ?? ""
        dayTwoForecast.text = singlTimeTwo.last ?? ""
        dayThreeForecast.text = singlTimeThree.last ?? ""
        dayFourForecast.text = singlTimeFour.last ?? ""
        dayFiveForecast.text = singlTimeFive.last ?? ""
        
        //Get temperature forecast
        let arrayTemp = json["list"].arrayValue.map {$0["main"]["temp"].doubleValue}
        let singlTempOne = Int(arrayTemp[1] - 273.15)
        let singlTempTwo = Int(arrayTemp[2] - 273.15)
        let singlTempThree = Int(arrayTemp[3] - 273.15)
        let singlTempFour = Int(arrayTemp[4] - 273.15)
        let singlTempFive = Int(arrayTemp[5] - 273.15)
        
        dayOneTemp.text = "\(singlTempOne)℃"
        dayTwoTemp.text = "\(singlTempTwo)℃"
        dayThreeTemp.text = "\(singlTempThree)℃"
        dayFourTemp.text = "\(singlTempFour)℃"
        dayFiveTemp.text = "\(singlTempFive)℃"
        
        //Set main temp
        weatherDataModel.temperature = Int(arrayTemp[0] - 273.15)
        weatherDataModel.city = json["city"]["name"].stringValue
        weatherDataModel.condition = json["list"][0]["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)

        updateUIWithWeatherData()
        
//        let arrayTime = json["list"].arrayValue.map {$0["dt_txt"].stringValue}
//        print(arrayTime[1])
//        arrayTime[1...5].forEach { singlTime in
//            let singlTime2 = singlTime.components(separatedBy: " ")
//            //print(singlTime2.last ?? "")
//        }

        //Get temperature
//        let arrayTemp = json["list"].arrayValue.map({$0["main"]["temp"].intValue})
//        arrayTemp[1...5].forEach { singlTemp in
//            //print(singlTemp)
//        }
        
        //GEt today date and time
        //let now = Date()
        //let formatter = DateFormatter()
        //formatter.timeZone = TimeZone.current
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //formatter.dateFormat = "yyyy-MM-dd"
        //let dateString = formatter.string(from: now)
        //let singlDate = dateString.components(separatedBy: " ")
        //print(singlDate)
        //print(dateString)
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)℃"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
        //dayOneForecast.text = weatherDataModel.time
    }
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longetude = String(location.coordinate.longitude)
            let params : [String : String] = ["lat" : latitude, "lon" : longetude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //print(error)
        cityLabel.text = "Location Unavailably"
    }
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredNewCityName(city: String) {
        print(city)
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
        }
    }
    
}


