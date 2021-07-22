//
//  URL+Extensions.swift
//  Weather App
//
//  Created by Jaouher Bejaoui  on 14/7/2021.
//

import Foundation


extension URL{
    static func urlForWeatherAPI(city : String)-> URL?{
        let API_KEY = "2dd8e9804d63034498c9762e3604da4c"

        return URL (string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(API_KEY)")
    }
}
