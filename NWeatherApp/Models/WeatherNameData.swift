import Foundation

struct WeatherNameData: Codable {
    let hourly: [Hourly]
    let daily: [Daily]
    let current: Current
}

struct Hourly: Codable {
    let temp: Double
    let dt: Int
    let weather: [Weather]
}

struct Current: Codable {
    let temp: Double
    let weather: [Weather]
}

struct Daily: Codable {
    let temp: Temp
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let description: String
}

struct Temp: Codable {
    let min: Double
    let max: Double
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}

