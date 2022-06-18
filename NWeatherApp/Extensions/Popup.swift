//
//  Popup.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 19.06.2022.
//

import UIKit

struct Popup {
    
    //Popup to display if user logged in or logged out
    
    func successfullySignedOutPopUp(with app: String, didLogged: String) -> UIAlertController {
        let alertController = UIAlertController(
            title: "You have successfully Logged \(didLogged) to your \(app) account!",
            message: "",
            preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: nil)

        //Add action to alert controller
        alertController.addAction(continueAction)
        
        //Present alert controller
        return alertController
    }

    
    func weatherByCurrentLocationWasBlocked() {
        let alertController = UIAlertController(
            title: "You have banned the use of your location.",
            message: "",
            preferredStyle: .alert)
        let continueAction = UIAlertAction(
            title: "Continue",
            style: .default,
            handler: nil)
        //Add action to alert controller
        alertController.addAction(continueAction)

        //Present alert controller
        present(alertController, animated: true, completion: nil)
    }
    
}
