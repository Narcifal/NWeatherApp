import UIKit
import GoogleMaps

class MapViewController: UIViewController{
    
    //Google Maps view
    @IBOutlet private weak var mapView: GMSMapView!
    //Label with address
    @IBOutlet private weak var addressLabel: UILabel!
    
    private var longitude: CLLocationDegrees = 0.0
    private var latitude: CLLocationDegrees = 0.0
    
    private var weatherManager = WeatherManager()
    
    var didUpdateWeather: ((_ weather: WeatherNameData?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Google map view settings
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        //mapView.delegate = self
        
        //Address label background alpha
        addressLabel.backgroundColor = .lightGray.withAlphaComponent(0.8)
        
        //WeatherManager delegate
        weatherManager.delegate = self
    }
    
    
    //Search button clicked
    
    @IBAction func getWeatherButton(_ sender: Any) {
        if latitude != 0.0, longitude != 0.0 {
            
            //Load data by latitude and longitude of user marker
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
            
            //Load WeatherViewController
            navigationController?.popViewController(animated: true)
        } else {
            print("Error")
        }
    }
    
    
    //Get coordinates
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                self.addressLabel.text = "No address"
                return
            }
            
            self.addressLabel.text = lines.joined(separator: "\n")
            self.longitude = address.coordinate.longitude
            self.latitude = address.coordinate.latitude
        }
    }
    
}


// MARK: - GMSMapViewDelegate

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
}


//MARK: - WeatherManagerDelegate

extension MapViewController: WeatherManagerDelegate {
    
    //Protocol method, loaded when we decode the data
    func didUpdateWeather(_ weatherManager: WeatherManager, data: WeatherNameData) {
        
        DispatchQueue.main.async {
            self.didUpdateWeather?(data)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else {
            return
        }

        mapView.camera = GMSCameraPosition(
            target: location.coordinate,
            zoom: 18,
            bearing: 0,
            viewingAngle: 0)
    }
}
