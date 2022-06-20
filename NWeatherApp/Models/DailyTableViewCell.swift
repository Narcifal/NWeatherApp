//
//  DailyTableViewCell.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 17.06.2022.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Internal -
    internal func configure(image: UIImage?, day: String, max: String, min: String) {
        weatherImage.image = image
        dayLabel.text = day
        minTemp.text = min
        maxTemp.text = max
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "DailyTableViewCell", bundle: nil)
    }
}
