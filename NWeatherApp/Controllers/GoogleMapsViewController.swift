//
//  GoogleMapsViewController.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 16.06.2022.
//

import UIKit
import MapKit

class GoogleMapsViewController: UIViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    

    let mapView = MKMapView()
    
    let searchVC = UISearchController(searchResultsController: SearchResultViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Maps"
        view.addSubview(mapView)
        searchVC.searchResultsUpdater = self
        searchVC.searchBar.backgroundColor = .systemMint
        navigationItem.searchController = searchVC
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
