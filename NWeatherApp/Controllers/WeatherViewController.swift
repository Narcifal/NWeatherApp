//
//  ViewController.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 14.06.2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var hourlyView: UIView!
    
    @IBOutlet weak var hourlyCollection: UICollectionView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBAction func currentLocation(_ sender: UIButton) {
    }
    
    var myLonLocation: CLLocationDegrees = 0.0
    var myLatLocation: CLLocationDegrees = 0.0
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //randomBackgroundImage()

        hourlyCollection.register(HourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: "HourlyCollectionViewCell")
        
        hourlyCollection.delegate = self
        hourlyCollection.dataSource = self
        
        hourlyView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        tableView.register(DailyTableViewCell.nib(), forCellReuseIdentifier: "DailyTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0.8)

        weatherManager.delegate = self
        
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        searchBar.layer.cornerRadius = 12.0
        searchBar.clipsToBounds = true
        
        backgroundImage.image = UIImage(named: Constants.BackgroundImage.greenLeaves)
        backgroundImage.alpha = 0.7
        
        getCurrentLocation()
    }
    
    func getCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }

    
    @IBAction func weatherByCurrentLocation(_ sender: UIButton) {
        weatherManager.fetchWeather(latitude: myLonLocation, longitude: myLatLocation)
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



extension WeatherViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("UICollectionViewDelegate")
    }
    
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as! HourlyCollectionViewCell
        
        cell.configure(with: UIImage(named: "facebookLogo-40")!)
        
        return cell
    }
     
    
    
}



extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell") as! DailyTableViewCell
            
            cell.configure(with: UIImage(named: "googleLogo-40")!)
            cell.layer.backgroundColor = UIColor.clear.cgColor
        
            return cell
        }
}





//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter city name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchBar.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchBar.text = ""
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, data: WeatherNameData) {
        DispatchQueue.main.async {
            self.cityLabel.text = data.timezone
            self.temperatureLabel.text = String(format: "%.1f", data.current.temp)
            //self.conditionImageView.image = UIImage(systemName: setWeather().conditionName(conditionId: data.current.weather[0].id))
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        myLatLocation = locValue.latitude
        myLonLocation = locValue.longitude
        weatherManager.fetchWeather(latitude: locValue.latitude, longitude: locValue.longitude)
    }
}
