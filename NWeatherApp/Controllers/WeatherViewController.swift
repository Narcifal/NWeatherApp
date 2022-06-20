//
//  WeatherViewController.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 14.06.2022.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherDescription: UILabel!
    @IBOutlet private weak var hourlyView: UIView!
    @IBOutlet private weak var hourlyCollection: UICollectionView!
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var dailyView: UITableView!
    @IBOutlet private weak var searchWeather: UITextField!
    
    //MARK: - Variables -
    private var recievedWeatherData: WeatherNameData? = nil
    private var weatherManager = WeatherManager()
    private var locationManager = CLLocationManager()
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupTableView()
        
        setupTextField()
        
        setupBackgroundImage()
        
        //Weather manager delegate
        weatherManager.delegate = self
        
        getCurrentLocation()
    }
    
    //MARK: - Internal -
    //Configure view controller after getting decoded data
    internal func configure(with data: WeatherNameData) {
        self.recievedWeatherData = data
        
        if data.timezone != "Etc/GMT"{
            self.cityLabel.text = data.timezone
        } else {
            self.cityLabel.text = "Unknown"
        }
        
        self.temperatureLabel.text = String(
            format: "%.1f",
            data.current.temp) + Constants.Temperature.degreeCelsius
        self.weatherDescription.text = data.current.weather[0].description.capitalizingFirstLetter()
        
        //Reload data to change view values
        self.dailyView.reloadData()
        self.hourlyCollection.reloadData()
    }
    
    //MARK: - Life Cycle -
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
    
    //Method to get user location
    private func getCurrentLocation() {
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
    
    //MARK: - IBActions -
    //Search weather data for your location
    @IBAction private func weatherByCurrentLocation(_ sender: UIButton) {
        //User location coordinates
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        
        //Check if coordinates is not empty
        if  latitude != 0.0,  longitude != 0.0 {
            weatherManager.fetchWeather(latitude: latitude ?? 0.0,
                                        longitude: longitude ?? 0.0)
        } else {
            present(
                showAlert(
                    with: "You have banned the use of your location."),
                animated: true,
                completion: nil)
        }
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
        let hourlyImage = UIImage(named:
                                    hourly?.weather[0].icon ?? "01d")?.resized(to: CGSize(width: 55, height: 55))

        //Cell settings
        cell.configure(image: hourlyImage,
                       time: hourlyTime,
                       temperature: hourlyTemp)

        return cell
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
        + Constants.Temperature.degrees
        
        let maxTemp =
            "Max:\n" + (daily?.temp.max.toFormattedString() ?? "")
        + Constants.Temperature.degrees

        //Check if current cell is the first element
        if indexPath.row == 0 {
            weatherDay = "Today"
        }

        //Set condition image
        let dailyImage = UIImage(named:
                                    daily?.weather[0].icon ?? "01d")?.resized(to: CGSize(width: 75, height: 75))
        
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
            //Configure view controller
            self.configure(with: data)
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.present(
                self!.showAlert(
                    with: "The location was not found. \n Try again."),
                animated: true,
                completion: nil)
        }
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

//MARK: MapViewController settings
private extension WeatherViewController {
    func setupCollectionView() {
        hourlyCollection.register(
            HourlyCollectionViewCell.nib(),
            forCellWithReuseIdentifier: Constants.Cells.hourly)
        hourlyCollection.dataSource = self
        hourlyView.backgroundColor = UIColor(
            named: "batTintColor")?.withAlphaComponent(0.7) ?? .white
    }

    func setupTableView() {
        dailyView.register(
            DailyTableViewCell.nib(),
            forCellReuseIdentifier: Constants.Cells.daily)
        dailyView.dataSource = self
        dailyView.backgroundColor = UIColor(
            named: "batTintColor")?.withAlphaComponent(0.7) ?? .white
    }
    
    func setupTextField() {
        searchWeather.delegate = self
        searchWeather.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        searchWeather.layer.cornerRadius = 12.0
        searchWeather.clipsToBounds = true
    }
    
    func setupBackgroundImage() {
        backgroundImage.image = UIImage(
            named: Constants.BackgroundImages.greenLeaves)
        backgroundImage.alpha = 0.7
    }
}
