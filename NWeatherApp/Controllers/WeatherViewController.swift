//
//  ViewController.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 14.06.2022.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {

    //City label
    @IBOutlet private weak var cityLabel: UILabel!
    //Temperature label
    @IBOutlet private weak var temperatureLabel: UILabel!
    //Hourly weather view
    @IBOutlet private weak var hourlyView: UIView!
    //Hourly weather collection
    @IBOutlet private weak var hourlyCollection: UICollectionView!
    //WeatherViewController background image
    @IBOutlet private weak var backgroundImage: UIImageView!
    //Daily table view
    @IBOutlet private weak var dailyView: UITableView!
    //Search weathe textField
    @IBOutlet private weak var searchWeather: UITextField!
    
    //Recieved weather data
    private var recievedWeatherData: WeatherNameData? = nil
    
    private var weatherManager = WeatherManager()
    private var locationManager = CLLocationManager()
    
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
            
            let latitude = locationManager.location?.coordinate.latitude
            let longitude = locationManager.location?.coordinate.longitude
            
            weatherManager.fetchWeather(latitude: latitude ?? 0.0,
                                        longitude: longitude ?? 0.0)
        }
    }
    
    //Search weather data for your location
    @IBAction func weatherByCurrentLocation(_ sender: UIButton) {
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        
        if  latitude != 0.0,  longitude != 0.0 {
            weatherManager.fetchWeather(latitude: latitude ?? 0.0,
                                        longitude: longitude ?? 0.0)
        } else {
            let alertController = UIAlertController(
                                                    title: "You have banned the use of your location.",
                                                    message: "",
                                                    preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Continue",
                                               style: .default,
                                               handler: nil)
            alertController.addAction(continueAction)

            present(alertController, animated: true, completion: nil)
        }
    }
    

    //Configure view controller after getting decoded data
    func configure(with data: WeatherNameData) {
        self.recievedWeatherData = data
        
        self.cityLabel.text = data.timezone
        self.temperatureLabel.text = String(format: "%.1f", data.current.temp)
        
        //Reload data to change view values
        self.dailyView.reloadData()
        self.hourlyCollection.reloadData()
    }
    
    //Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToGoogleMaps") {
            let mapViewController = segue.destination as? MapViewController
            
            //Call a configure method ....
            mapViewController?.didUpdateWeather = { [weak self] weather in
                guard let weather = weather else { return }
                self?.configure(with: weather)
            }
        }
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
        return ((recievedWeatherData?.hourly.count ?? 0)/2)
    }
    
    //Create collectionView reusable cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HourlyCollectionViewCell",
            for: indexPath) as! HourlyCollectionViewCell
        
        let date = NSDate(timeIntervalSince1970: TimeInterval((recievedWeatherData?.hourly[indexPath.item].dt) ?? 0))
        print(date)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        var currentTime: String = ""
        
        if indexPath.item != 0 {
            currentTime = formatter.string(from: date as Date)
        } else {
            currentTime = "Current"
        }
        
        let temp = String(format: "%.1f", recievedWeatherData?.hourly[indexPath.item].temp ?? 0)
        let celsiusTemp = "\(temp)\(Constants.degreeCelsius)"
        print(currentTime)
        cell.configure(image: UIImage(named: "facebookLogo-40")!,
                       time: currentTime,
                       temperature: celsiusTemp)

        
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

        let str = recievedWeatherData?.daily[indexPath.row].dt.toString(dateFormatter: "EE")
        
        let minTemp = "Min: \(String(format: "%.1f", recievedWeatherData?.daily[indexPath.row].temp.min ?? 0))"
        let maxTemp = "Max: " + String(format: "%.1f", recievedWeatherData?.daily[indexPath.row].temp.max ?? 0)

        
        
        var weatherDay: String = ""
        
        if indexPath.row != 0 {
            weatherDay = str ?? ""
        } else {
            weatherDay = "Current"
        }

        cell.configure(image: UIImage(named: "googleLogo-40")!, day: weatherDay, max: maxTemp, min: minTemp)
        
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
            self.configure(with: data)
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

        //Call fetchWeather method to load weather data
        weatherManager.fetchWeather(latitude: locValue.longitude, longitude: locValue.latitude)
    }
}
