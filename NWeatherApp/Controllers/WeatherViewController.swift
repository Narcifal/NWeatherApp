//
//  ViewController.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 14.06.2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    //City label
    @IBOutlet weak var cityLabel: UILabel!
    //Temperature label
    @IBOutlet weak var temperatureLabel: UILabel!
    //Hourly weather view
    @IBOutlet weak var hourlyView: UIView!
    //Hourly weather collection
    @IBOutlet weak var hourlyCollection: UICollectionView!
    //WeatherViewController background image
    @IBOutlet weak var backgroundImage: UIImageView!
    //Daily table view
    @IBOutlet weak var dailyView: UITableView!
    //Search weathe textField
    @IBOutlet weak var searchWeather: UITextField!
    
    var userCoordLatitude: CLLocationDegrees = 0.0
    var userCoordLongitude: CLLocationDegrees = 0.0
    
    //Recieved weather data
    var recievedWeatherData: WeatherNameData? = nil
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Collection settings
        hourlyCollection.register(
            HourlyCollectionViewCell.nib(),
            forCellWithReuseIdentifier: "HourlyCollectionViewCell")
        hourlyCollection.delegate = self
        hourlyCollection.dataSource = self
        hourlyView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        //Table view settings
        dailyView.register(
            DailyTableViewCell.nib(),
            forCellReuseIdentifier: "DailyTableViewCell")
        dailyView.delegate = self
        dailyView.dataSource = self
        dailyView.backgroundColor = UIColor.white.withAlphaComponent(0.8)

        //Weather manager delegate
        weatherManager.delegate = self
        
        //Text field settings
        searchWeather.delegate = self
        searchWeather.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        searchWeather.layer.cornerRadius = 12.0
        searchWeather.clipsToBounds = true
        
        //View controller background image settings
        backgroundImage.image = UIImage(
            named: Constants.BackgroundImage.greenLeaves)
        backgroundImage.alpha = 0.7
        
        //Request user location
        getCurrentLocation()
        
        //randomBackgroundImage()

    }
    
    //Method to get user location
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
    
    //Search weather data for your location
    @IBAction func weatherByCurrentLocation(_ sender: UIButton) {
        if  userCoordLongitude != 0.0,  userCoordLatitude != 0.0 {
            weatherManager.fetchWeather(latitude: userCoordLatitude,
                                        longitude: userCoordLongitude)
        } else {
            let alertController = UIAlertController(
                                                    title:
                                                        "You have banned the use of your location.",
                                                    message: "",
                                                    preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Continue",
                                               style: .default,
                                               handler: nil)
            alertController.addAction(continueAction)

            present(alertController, animated: true, completion: nil)
            //getCurrentLocation()
        }
    }
    
    //Set view background color by weather id
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


//MARK: UICollectionViewDelegate

extension WeatherViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("UICollectionViewDelegate")
    }
    
}


//MARK: UICollectionViewDataSource

extension WeatherViewController: UICollectionViewDataSource {
    
    //Amount of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recievedWeatherData?.hourly.count ?? 0
    }
    
    //Create collectionView reusable cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HourlyCollectionViewCell",
            for: indexPath) as! HourlyCollectionViewCell
        
//        let date = NSDate(timeIntervalSince1970: TimeInterval((recievedWeatherData?.hourly[0].dt) ?? 0))
//        print("tableview2")
//
//        print(date)
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        let currentTime = formatter.string(from: date as Date)
//        print(currentTime)
//        let temp = String(format: "%.1f", recievedWeatherData?.hourly[0].temp ?? 0)
//        print(temp)
//        let celsiusTemp = "\(temp)\(Constants.degreeCelsius)"
//
//        cell.configure(image: UIImage(named: "facebookLogo-40")!,
//                       time: currentTime,
//                       temperature: celsiusTemp)

        return cell
    }
     
}

//MARK: UITableViewDelegate

extension WeatherViewController: UITableViewDelegate {
    
    //Method to operate with cell action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}


//MARK: UITableViewDataSource

extension WeatherViewController: UITableViewDataSource {
    
    //Amount of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recievedWeatherData?.daily.count ?? 0
    }
    
    //Create tableView reusable cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "DailyTableViewCell", for: indexPath) as! DailyTableViewCell
            
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        let currentTime = formatter.string(from: date as Date)
//        print(currentTime)
//        let min = String(format: "%.1f", recievedWeatherData?.daily[0].temp.min ?? 0)
//        let max = String(format: "%.1f", recievedWeatherData?.daily[0].temp.max ?? 0)
//
//        let maxTemp = "Max: \(max)"
//        let minTemp = "Min: \(min)"
//
//        let date = NSDate(timeIntervalSinceReferenceDate: (recievedWeatherData?.daily[0].dt ?? 0))
//        let weatherDay = DateFormatter().string(from: date as Date)
//
//        cell.configure(image: UIImage(named: "googleLogo-40")!, day: "Tue", max: maxTemp, min: minTemp)
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        return cell
    }
}


//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchWeather.endEditing(true)
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
        if let city = searchWeather.text {
            
            //Find weather by user-entered city name
            weatherManager.fetchWeather(cityName: city)
        }
        searchWeather.text = ""
    }
}


//MARK: WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    //Protocol method, loaded when we decode the data
    func didUpdateWeather(_ weatherManager: WeatherManager, data: WeatherNameData) {
        DispatchQueue.main.async {
            self.recievedWeatherData = data
            
            self.cityLabel.text = data.timezone
            self.temperatureLabel.text = String(format: "%.1f", data.current.temp)
            
            //Reload data to change view values
            self.dailyView.reloadData()
            self.hourlyCollection.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        userCoordLongitude = locValue.longitude
        userCoordLatitude = locValue.latitude
        //Call fetchWeather method to load weather data
        weatherManager.fetchWeather(latitude: locValue.latitude, longitude: locValue.longitude)
    }
}
