//
//  WeatherResult.swift
//  Weather App
//
//  Created by Jaouher Bejaoui  on 14/7/2021.
//

import Foundation

struct Weather : Decodable{
    let temp: Double
    let humidity: Double
}

struct WeatherResult: Decodable{
    let main : Weather
}

extension WeatherResult{
    static var empty: WeatherResult{
        return WeatherResult(main: Weather(temp: 0.0, humidity: 0.0))
    }
}
