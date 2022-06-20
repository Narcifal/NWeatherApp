//
//  DailyTableViewCell.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 17.06.2022.
//

import UIKit

final class DailyTableViewCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var minTemp: UILabel!
    @IBOutlet private weak var maxTemp: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Internal -
    func configure(image: UIImage?, day: String, max: String, min: String) {
        weatherImage.image = image
        dayLabel.text = day
        minTemp.text = min
        maxTemp.text = max
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "DailyTableViewCell", bundle: nil)
    }
}
