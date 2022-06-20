//
//  StringExtension.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 19.06.2022.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
