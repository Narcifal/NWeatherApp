//
//  data.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 15.06.2022.
//

import Foundation

struct WeatherData: Codable {
    let weather: [Weather]
}

struct Weather: Codable {
    let email: String
    let id: Int
    let name: String
}
