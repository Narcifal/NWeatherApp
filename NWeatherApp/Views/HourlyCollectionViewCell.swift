//
//  HourlyCollectionViewCell.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 17.06.2022.
//

import UIKit

final class HourlyCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var temperature: UILabel!
    
    //MARK: - Internal -
    func configure(image: UIImage?, time: String, temperature: String) {
        imageView.image = image
        self.time.text = time
        self.temperature.text = temperature
    }

    static func nib() -> UINib {
        return UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
    }
    
}
