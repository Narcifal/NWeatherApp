//
//  MapViewController.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 15.06.2022.
//

import GoogleMaps

final class MapViewController: UIViewController{

    //MARK: - IBOutlets -
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet private weak var addressLabel: UILabel!
    
    //MARK: - Variables -
    private var longitude: CLLocationDegrees = 0.0
    private var latitude: CLLocationDegrees = 0.0
    private var weatherManager = WeatherManager()
    var didUpdateWeather: ((_ weather: WeatherNameData?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Google map view delegate
        mapView.delegate = self
        
        addressLabelSettings()
        
        //WeatherManager delegate
        weatherManager.delegate = self
    }
    
    //MARK: - IBActions -
    //Search button clicked
    @IBAction private func getWeatherButton(_ sender: Any) {
        if latitude != 0.0, longitude != 0.0 {
            
            //Load data by latitude and longitude of user marker
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
            
            //Load WeatherViewController
            navigationController?.popViewController(animated: true)
        } else {
            //Display alert controller
            let alertController =
                AddingAlertController().googleMapsAddressIsNil()
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //Get coordinates
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        //Create a GMSGeocoder object to turn a latitude and longitude coordinate into a street address.
        let geocoder = GMSGeocoder()
        
        //Ask to reverse geocode the coordinate passed to the method.
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                self.addressLabel.text = "No address"
                return
            }
            
            //Sets the text of the addressLabel to the address returned by the geocoder.
            self.addressLabel.text = lines.joined(separator: "\n")
            
            //Remembering longitude and latitude coordinates
            self.longitude = address.coordinate.longitude
            self.latitude = address.coordinate.latitude
        }
    }
}

// MARK: - GMSMapViewDelegate

extension MapViewController: GMSMapViewDelegate {
    
    //Called each time the map stops moving and settles in a new position.
    //Make a call to reverse geocode the new position and update the addressLabel‘s text.
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
}

//MARK: - WeatherManagerDelegate

extension MapViewController: WeatherManagerDelegate {
    
    //Protocol method loaded when we decode the data
    func didUpdateWeather(_ weatherManager: WeatherManager, data: WeatherNameData) {
        
        DispatchQueue.main.async {
            self.didUpdateWeather?(data)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: MapViewController settings

private extension MapViewController{
    func addressLabelSettings() {
        addressLabel.backgroundColor = .lightGray.withAlphaComponent(0.8)
    }
}
