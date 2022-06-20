//
//  WeatherManager.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 15.06.2022.
//

import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, data: WeatherNameData)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let coordURL = "https://api.openweathermap.org/data/2.5/weather?appid=5534e7ad1f66c1cab452285dbbfe4303&units=metric"
        let urlString = "\(coordURL)&q=\(cityName)"

        performCoordRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?&exclude=minutely&appid=5534e7ad1f66c1cab452285dbbfe4303&units=metric"
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"

        performWeatherRequest(with: urlString)
    }
    
    func performCoordRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let receivedCoord = self.parseJson(safeData, expecting: WeatherCoordinatesData.self) {
                        fetchWeather(latitude: receivedCoord.coord.lat, longitude: receivedCoord.coord.lon)
                    }
                }
            }
            task.resume()
        }
    }
    
    func performWeatherRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let receivedWeather = self.parseJson(safeData, expecting: WeatherNameData.self) {
                        self.delegate?.didUpdateWeather(self, data: receivedWeather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson<T: Codable>(_ data: Data, expecting: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodateData = try decoder.decode(expecting, from: data)
            return decodateData
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


