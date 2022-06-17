//
//  hourlyCollectionViewCell.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 17.06.2022.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: UIImage) {
        imageView.image = image
    }

    static func nib() -> UINib {
        return UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
    }
    
}
