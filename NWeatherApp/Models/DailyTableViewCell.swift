//
//  DailyTableViewCell.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 17.06.2022.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

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
    
    public func configure(with image: UIImage) {
        weatherImage.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "DailyTableViewCell", bundle: nil)
    }
}
