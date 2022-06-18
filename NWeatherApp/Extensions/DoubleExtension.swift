//
//  DoubleExtension.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 19.06.2022.
//

import Foundation

extension Double {

    func doubleToFormattedString(dot: String = ".1") -> String {
        return String(format: "%\(dot)f", self)
    }
    
}
