//
//  GoogleMapViewController.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 16.06.2022.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController {

    @IBOutlet weak var googleMapView: GMSMapView!
    //@IBOutlet weak var txtSearch: UITextField!
    
//    @IBAction func locationTapped(_ sender: Any) {
//        gotoPlaces()
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // GOOGLE MAPS SDK: COMPASS
        googleMapView.settings.compassButton = true
        
        // GOOGLE MAPS SDK: USER'S LOCATION
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
    }
    
//    func gotoPlaces() {
//        txtSearch.resignFirstResponder()
//        let acController = GMSAutocompleteViewController()
//        acController.delegate = self
//        present(acController, animated: true, completion: nil)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GoogleMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
           print("locations = \(locValue.latitude) \(locValue.longitude)")
        //lblLocation.text = "latitude = \(locValue.latitude), longitude = \(locValue.longitude)"
    }
}

    
