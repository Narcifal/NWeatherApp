//
//  UIImageExtension.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 19.06.2022.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
