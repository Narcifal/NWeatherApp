import UIKit
import GoogleMaps

class MapViewController: UIViewController{
  
    private let locationManager = CLLocationManager()

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var longitude: CLLocationDegrees = 0.0
    
    var latitude: CLLocationDegrees = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        self.navigationController!.navigationBar.tintColor = UIColor.link;
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    @IBAction func getWeatherButton(_ sender: Any) {
        if latitude != 0.0, longitude != 0.0 {
            navigationController?.popViewController(animated: true)
            WeatherManager().fetchWeather(latitude: latitude, longitude: longitude)
        } else {
            print("you suck")
        }
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
      
      let geocoder = GMSGeocoder()
        
      geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
        guard let address = response?.firstResult(), let lines = address.lines else {
          return
        }
          
        
        self.addressLabel.text = lines.joined(separator: "\n")
        self.longitude = address.coordinate.longitude
        self.latitude = address.coordinate.latitude
        
//        UIView.animate(withDuration: 0.25) {
//          self.view.layoutIfNeeded()
//        }
      }
    }

}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      reverseGeocodeCoordinate(position.target)
    }

}


// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
    guard status == .authorizedWhenInUse else {
      return
    }
    
    locationManager.startUpdatingLocation()
      
    //mapView.isMyLocationEnabled = true
    //mapView.settings.myLocationButton = true
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
      
    //mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
      
    locationManager.stopUpdatingLocation()
  }
}
