//
//  HourlyCollectionViewCell.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 17.06.2022.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Internal -
    internal func configure(image: UIImage?, time: String, temperature: String) {
        imageView.image = image
        self.time.text = time
        self.temperature.text = temperature
    }

    static func nib() -> UINib {
        return UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
    }
    
}
