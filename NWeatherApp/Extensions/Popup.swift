//
//  Popup.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 19.06.2022.
//

import UIKit

struct Popup {
    
    func successfullySignedOutPopUp(with app: String) -> UIAlertController {
        let alertController = createAlertController()
        alertController.title = "You have successfully Logged Out into your \(app) account!"
        return alertController
    }

    
    func weatherByCurrentLocationWasBlocked() -> UIAlertController {
        let alertController = createAlertController()
        alertController.title = "You have banned the use of your location."
        return alertController
    }
    
    func googleMapsAddressIsNil() -> UIAlertController {
        let alertController = createAlertController()
        alertController.title = "You have not selected a specific location. \n point to the desired location on the map)"
        return alertController
    }
    
    
    func createAlertController() -> UIAlertController{
        let alertController = UIAlertController(
            title: "",
            message: "",
            preferredStyle: .alert)
        
        let continueAction = UIAlertAction(
            title: "Continue",
            style: .default,
            handler: nil)
        //Add action to alert controller
        alertController.addAction(continueAction)
        return alertController
    }
    
}
