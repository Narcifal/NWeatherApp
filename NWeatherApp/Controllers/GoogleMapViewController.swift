//
//  GoogleMapViewController.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 16.06.2022.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    @IBOutlet weak var googleMapView: GMSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // GOOGLE MAPS SDK: COMPASS
        googleMapView.settings.compassButton = true
        
        // GOOGLE MAPS SDK: USER'S LOCATION
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
    }
}

extension GoogleMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
           print("locations = \(locValue.latitude) \(locValue.longitude)")
        //lblLocation.text = "latitude = \(locValue.latitude), longitude = \(locValue.longitude)"
    }
}

    
