import Foundation
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
    
    func fetchWeather(latitude: Double, longitude: Double) {
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
                    if let receivedCoord = self.parseCoordJSON(safeData) {
                        fetchWeather(latitude: receivedCoord.coord.lat, longitude: receivedCoord.coord.lon)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseCoordJSON(_ coordData: Data) -> WeatherCoordinatesData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(
                WeatherCoordinatesData.self,
                from: coordData)
            
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    //---------------------------------------------------------------------
    
    func performWeatherRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let receivedWeather = self.parseWeatherDataJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, data: receivedWeather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseWeatherDataJSON(_ data: Data) -> WeatherNameData? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(
                WeatherNameData.self,
                from: data)

            return decodedData
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}


