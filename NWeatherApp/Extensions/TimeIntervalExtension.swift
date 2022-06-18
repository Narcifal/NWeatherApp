//
//  TimeIntervalExtension.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 18.06.2022.
//

import Foundation

extension TimeInterval {
    
    func toString(dateFormatter: String = "HH:mm") -> String {
        let date = NSDate(timeIntervalSince1970: self)
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        formatter.locale = Locale(identifier: "en_US")
        
        let currentTime = formatter.string(from: date as Date)
        
        return currentTime
    }
    
}
