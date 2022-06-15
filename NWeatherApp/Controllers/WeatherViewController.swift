//
//  ViewController.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 14.06.2022.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cityLabel.text = "London"
        temperatureLabel.text = "29\(Constants.degreeCelsius)"
        
        randomBackgroundImage()
    }

    func randomBackgroundImage() {
        let randomNumber = Int.random(in: 0..<6)
        
        switch(randomNumber) {
        case 0:
            backgroundImage.image = UIImage(named: Constants.BackgroundImage.deepNight)
        case 1:
            backgroundImage.image = UIImage(named: Constants.BackgroundImage.fallingStar)
        case 2:
            backgroundImage.image = UIImage(named: Constants.BackgroundImage.greenLeaves)
        case 3:
            backgroundImage.image = UIImage(named: Constants.BackgroundImage.riverMountain)
        case 4:
            backgroundImage.image = UIImage(named: Constants.BackgroundImage.sunsetField)
        case 5:
            backgroundImage.image = UIImage(named: Constants.BackgroundImage.twilightMoon)
        default:
            backgroundImage.image = UIImage(named: Constants.BackgroundImage.greenLeaves)
        }
        
        backgroundImage.alpha = 0.7
    }

}
