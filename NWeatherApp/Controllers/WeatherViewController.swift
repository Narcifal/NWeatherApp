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
            forCellWithReuseIdentifier: Constants.Cells.hourly)
        hourlyCollection.delegate = self
        hourlyCollection.dataSource = self
        hourlyView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        //Table view settings
        dailyView.register(
            DailyTableViewCell.nib(),
            forCellReuseIdentifier: Constants.Cells.daily)
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
            named: Constants.BackgroundImages.greenLeaves)
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
        //User location coordinates
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        
        //Check if coordinates is not empty
        if  latitude != 0.0,  longitude != 0.0 {
            weatherManager.fetchWeather(latitude: latitude ?? 0.0,
                                        longitude: longitude ?? 0.0)
        } else {
            let alertController = Popup().weatherByCurrentLocationWasBlocked()
            present(alertController, animated: true, completion: nil)
        }
    }
    

    //Configure view controller after getting decoded data
    func configure(with data: WeatherNameData) {
        self.recievedWeatherData = data
        
        self.cityLabel.text = data.timezone
        self.temperatureLabel.text = String(
            format: "%.1f",
            data.current.temp) + Constants.Temperature.degreeCelsius
        
        //Reload data to change view values
        self.dailyView.reloadData()
        self.hourlyCollection.reloadData()
    }
    
    
    //Prepare for segue (To MapViewController)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.Segues.goToGoogleMaps) {
            let mapViewController = segue.destination as? MapViewController
            
            //Call a configure method ....
            mapViewController?.didUpdateWeather = { [weak self] weather in
                guard let weather = weather else { return }
                self?.configure(with: weather)
            }
        }
    }
}


//MARK: - UICollectionViewDelegate

extension WeatherViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("UICollectionViewDelegate")
    }
    
}


//MARK: - UICollectionViewDataSource

extension WeatherViewController: UICollectionViewDataSource {
    
    //Amount of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (recievedWeatherData?.hourly.count ?? 0)/2
    }
    
    //Create collectionView reusable cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Create a dequeue reusable cell
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.Cells.hourly,
            for: indexPath) as! HourlyCollectionViewCell
        
        //Hourly path
        let hourly = recievedWeatherData?.hourly[indexPath.item]

        //String with formatted date (hours)
        var hourlyTime = hourly?.dt.toString() ?? ""

        //Check if current cell is the first element
        if indexPath.item == 0 {
            hourlyTime = "Current"
        }
        
        //Double formatted to String
        let hourlyTemp = (hourly?.temp.toFormattedString() ?? "")
        + Constants.Temperature.degreeCelsius
        
        //Set condition image
        let hourlyImage = UIImage(named: hourly?.weather[0].icon ?? "01d")?.resized(to: CGSize(width: 75, height: 75))

        //Cell settings
        cell.configure(image: hourlyImage,
                       time: hourlyTime,
                       temperature: hourlyTemp)

        return cell
    }
}


//MARK: - UITableViewDelegate

extension WeatherViewController: UITableViewDelegate {
    
    //Method to operate with cell action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}


//MARK: - UITableViewDataSource

extension WeatherViewController: UITableViewDataSource {
    
    //Amount of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recievedWeatherData?.daily.count ?? 0
    }
    
    //Create tableView reusable cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create a dequeue reusable cell
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.Cells.daily, for: indexPath) as! DailyTableViewCell

        //Daily path
        let daily = recievedWeatherData?.daily[indexPath.row]
        
        //String with formatted date (Day)
        var weatherDay = daily?.dt.toString(dateFormatter: "EE") ?? ""
        
        //Doubles formatted to String
        let minTemp = "Min:\n" + (daily?.temp.min.toFormattedString() ?? "")
        let maxTemp = "Max:\n" + (daily?.temp.max.toFormattedString() ?? "")

        //Check if current cell is the first element
        if indexPath.row == 0 {
            weatherDay = "Current"
        }

        //Set condition image
        let dailyImage = UIImage(named: daily?.weather[0].icon ?? "01d")
        
        //Cell settings
        cell.configure(image: dailyImage,
                       day: weatherDay,
                       max: maxTemp,
                       min: minTemp)
        
        //Cell transparent background color
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


//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    //Protocol method, loaded when we decode the data
    func didUpdateWeather(_ weatherManager: WeatherManager, data: WeatherNameData) {
        DispatchQueue.main.async {
            //....
            self.configure(with: data)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}


//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        //Call fetchWeather method to load weather data
        weatherManager.fetchWeather(latitude: locValue.longitude, longitude: locValue.latitude)
    }
}
