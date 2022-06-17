import Foundation

struct WeatherCoordinatesData: Codable {
    let coord: Coord
    let name: String
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}
