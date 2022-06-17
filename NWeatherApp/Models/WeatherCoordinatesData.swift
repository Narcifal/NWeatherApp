import Foundation

struct WeatherCoordinatesData: Codable {
    let coord: Coord
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}
