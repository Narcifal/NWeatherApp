//
//  WeatherCoordinatesData.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 15.06.2022.
//

import Foundation

struct WeatherCoordinatesData: Codable {
    let coord: Coord
    let name: String
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}
