//
//  ViewController.swift
//  WeatherApp
//
//  /***Get your own App ID at https://openweathermap.org/appid ****/

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, FavoritCityWeatherDelegate {

    //Forecast constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast"
    let APP_ID = "f856e155f5c5001294552aa4b040bd9d"
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
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
    
    @IBOutlet weak var dayOneIcon: UIImageView!
    @IBOutlet weak var dayTwoIcon: UIImageView!
    @IBOutlet weak var dayTreeIcon: UIImageView!
    @IBOutlet weak var dayFourIcon: UIImageView!
    @IBOutlet weak var dayFiveIcon: UIImageView!
    
    @IBOutlet weak var updateSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - Networking
    /***************************************************************/
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String: String], complition: @escaping (_ result: JSON) -> ()) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                let weatherJSON : JSON = JSON(response.result.value!)
                //print(weatherJSON) //To see main JASON
                complition(weatherJSON)
            }
            else {
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    //Write the updateWeatherData method here:
    var fCities : [FavoritCitiesDataModel] = []

    func updateWeatherData(json : JSON) {
        //Set main city and check the Error
        if let cityName = json["city"]["name"].string {
        
        //Get time
        let arrayTime = json["list"].arrayValue.map {$0["dt_txt"].stringValue}
        weatherDataModel.time = weatherDataModel.updateTimeArray(time: arrayTime)
            
        //Get temperature
        let arrayTemp = json["list"].arrayValue.map {$0["main"]["temp"].doubleValue}
        weatherDataModel.temp = weatherDataModel.updateTempArray(temp: arrayTemp)
        
        //Get condition for icons
        let arrayIcons = json["list"].arrayValue.map {$0["weather"][0]["id"].intValue}
        weatherDataModel.weatherIconName = weatherDataModel.singleCondition(condition: arrayIcons)
            
        //Get weather description
        let arrayDescription = json["list"].arrayValue.map {$0["weather"][0]["description"].stringValue}
        let descript = arrayDescription[0].capitalized(with: nil)
        
        //Get clouds %
        let arrayClouds = json["list"].arrayValue.map {$0["clouds"]["all"].intValue}
        
        //Get wind speed
        let arrayWind = json["list"].arrayValue.map {$0["wind"]["speed"].intValue}
        
        //Get pressure
        let arrayPressure = json["list"].arrayValue.map {$0["main"]["pressure"].doubleValue}
        let pressure = weatherDataModel.updatePressure(pressure: arrayPressure[0])
        
        //Get humidity
        let arrayHumidity = json["list"].arrayValue.map {$0["main"]["humidity"].intValue}
            
        fCities.append(FavoritCitiesDataModel(fCity: cityName, fTime: weatherDataModel.time, fTemp: weatherDataModel.temp, fIcon: weatherDataModel.weatherIconName, fDisc: descript, fClouds: arrayClouds[0], fWind: arrayWind[0], fPress: pressure, fHumid: arrayHumidity[0]))
        }
        else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData(weatherData : FavoritCitiesDataModel) {
        cityLabel.text = weatherData.fCity
        temperatureLabel.text = "\(weatherData.fTemp[0])°"
        weatherIcon.image = UIImage(named: weatherData.fIcon[0])
        discriptionLabel.text = weatherData.fDisc

        dayOneForecast.text = weatherData.fTime[1]
        dayTwoForecast.text = weatherData.fTime[2]
        dayThreeForecast.text = weatherData.fTime[3]
        dayFourForecast.text = weatherData.fTime[4]
        dayFiveForecast.text = weatherData.fTime[5]

        dayOneTemp.text = "\(weatherData.fTemp[1])°"
        dayTwoTemp.text = "\(weatherData.fTemp[2])°"
        dayThreeTemp.text = "\(weatherData.fTemp[3])°"
        dayFourTemp.text = "\(weatherData.fTemp[4])°"
        dayFiveTemp.text = "\(weatherData.fTemp[5])°"

        dayOneIcon.image = UIImage(named: weatherData.fIcon[1])
        dayTwoIcon.image = UIImage(named: weatherData.fIcon[2])
        dayTreeIcon.image = UIImage(named: weatherData.fIcon[3])
        dayFourIcon.image = UIImage(named: weatherData.fIcon[4])
        dayFiveIcon.image = UIImage(named: weatherData.fIcon[5])
        
        cloudsLabel.text = "\(weatherData.fClouds) %"
        windLabel.text = "\(weatherData.fWind) m/s"
        pressureLabel.text = "\(Int(weatherData.fPress)) mmHg"
        humidityLabel.text = "\(weatherData.fHumid) %"
        
        updateSpinner.stopAnimating()
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

            getWeatherData(url: WEATHER_URL, parameters: params) { (JSON) in
                self.updateWeatherData(json: JSON)
                self.favoriteCitiesTemp()
            }
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavailably"
    }
    
    //Update viewController to get existing user location (refresh data)
    @IBAction func updateLocation(_ sender: UIBarButtonItem) {
        fCities = []
        updateSpinner.startAnimating()
        self.viewDidLoad()
        self.viewWillAppear(true)
    }

    //City search popup for
    var city : String = ""
    
    @IBAction func searchLocation(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Enter city name for weather", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Get weather", style: .default) { (action) in
            
            self.city = textField.text!
            
            let params : [String : String] = ["q" : self.city, "appid" : self.APP_ID]
            self.getWeatherData(url: self.WEATHER_URL, parameters: params) { (JSON) in
                self.updateWeatherData(json: JSON)
                let searchCity = self.fCities[self.fCities.count - 1]
                self.updateUIWithWeatherData(weatherData: searchCity)
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter city name"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Add city to favorite
    @IBAction func addLocationToFavorite(_ sender: Any) {
        weatherDataModel.favoriteCity(city: city.lowercased())
    }
    
    //Get favoriet cities weather data
    func favoriteCitiesTemp() {
        //Update UI for local weather
        updateUIWithWeatherData(weatherData: fCities[0])
        let cities = weatherDataModel.favoriteLocation
        cities.forEach { city in
            userEnteredNewCityName(city: city)
        }
    }

    //MARK: - Change City Delegate methods
    /***************************************************************/
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredNewCityName(city: String) {
        print(city)
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params) { (JSON) in
            self.updateWeatherData(json: JSON)
        }
    }
    
    //Update UI with favorit city data
    func favoritCityWeatherUpdate (city : String) {
        fCities.forEach { favCity in
            let city2 : String = favCity.fCity
            if city2 == city {
                let filtered = fCities.filter{ $0.fCity.contains(city) }
                filtered.forEach {
                    print($0)
                    updateUIWithWeatherData(weatherData: $0)
                }
            }
        }
    }
    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toFavotitCities" {
            let destinationVC = segue.destination as! FavoriteCitiesTableViewController
            
            destinationVC.delegate = self
            destinationVC.favoritCities = fCities
        }
        
    }
    
}


