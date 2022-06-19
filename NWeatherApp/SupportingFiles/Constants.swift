//
//  Constants.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 14.06.2022.
//

import Foundation

struct Constants {
    
    struct Segues {
        static let goToWeather = "goToWeather"
        static let goToGoogleMaps = "goToGoogleMaps"
    }
    
    struct BackgroundImages {
        static let twilightMoon = "twilightMoonBackround"
        static let sunsetField = "sunsetFieldBackround"
        static let riverMountain = "riverMountainBackground"
        static let greenLeaves = "greenLeavesBackground"
        static let fallingStar = "fallingStarBackground"
        static let deepNight = "deepNightBackground"
    }
    
    struct APIKeys {
        static let googleMapsApi = "AIzaSyAGDORMYoad9KIzrDiA-DZ5Ffc-uVo11xg"
        static let googleSignInClientID = "661995097316-078fdgscnh5qhp0tlsn5slftqpv161v5.apps.googleusercontent.com"
    }
    
    struct Cells {
        static let hourly = "HourlyCollectionViewCell"
        static let daily = "DailyTableViewCell"
    }
    
    struct Temperature {
        static let degreeCelsius = "°C"
        static let degrees = "°"
    }
}
