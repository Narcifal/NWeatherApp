import Foundation

struct WeatherNameData: Codable {
    let hourly: [Hourly]
    let daily: [Daily]
    let current: Current
    let timezone: String
}

struct Hourly: Codable {
    let temp: Double
    let dt: TimeInterval
    let weather: [Weather]
}

struct Current: Codable {
    let temp: Double
    let weather: [Weather]
}

struct Daily: Codable {
    let dt: TimeInterval
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

