//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Pavel Syunev on 24/06/2019.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class WeatherDataModel {

    //Model variables here
    var time : [String] = []
    var temp : [Int] = []
    var condition : [String] = []
    var weatherIconName : [String] = []
    
    //Favorite cities(locations)
    var favoriteLocation : [String] = []
    
    //This method check favorit cities for dublicates and abb unic city to favotite array
    func favoriteCity (city : String) {
        if favoriteLocation.contains(city) {
            print("This city already in the favorit list")
        } else {
            //favoriteLocation.append(city)
            let favoriteLocationLength = favoriteLocation.count
            print(favoriteLocationLength)
            
            favoriteLocation.insert(city, at: favoriteLocationLength)
            print(favoriteLocation)
        }
    }
    
    //Convert pressure from hPa -> mmHg
    func updatePressure (pressure: Double) -> Double {
        return pressure * 0.75
    }
    
    //This method update timeArray to get only Time info
    func updateTimeArray(time: [String]) -> [String] {
        return time.map { String($0.components(separatedBy: " ").last!.dropLast(3)) }
    }
    
    //This method update tempArray to get Temp in celsius
    func updateTempArray(temp: [Double]) -> [Int] {
        return temp.map { Int($0 - 273.15) }
    }
        
    //Condition forecast data
    func singleCondition(condition: [Int]) -> [String]{
        
        var newConditionArr : [String] = []
        
        condition.forEach { condition in
            switch (condition) {
                
            case 0...300 :
                newConditionArr.append("tstorm1")
                
            case 301...500 :
                newConditionArr.append("light_rain")
                
            case 501...600 :
                newConditionArr.append("shower3")
                
            case 601...700 :
                newConditionArr.append("snow4")
                
            case 701...771 :
                newConditionArr.append("fog")
                
            case 772...799 :
                newConditionArr.append("tstorm3")
                
            case 800 :
                newConditionArr.append("sunny")
                
            case 801...804 :
                newConditionArr.append("cloudy2")
                
            case 900...903, 905...1000  :
                newConditionArr.append("tstorm3")
                
            case 903 :
                newConditionArr.append("snow5")
                
            case 904 :
                newConditionArr.append("sunny")
                
            default :
                newConditionArr.append("dunno")
            }
        }
        
        return newConditionArr
    }

}
