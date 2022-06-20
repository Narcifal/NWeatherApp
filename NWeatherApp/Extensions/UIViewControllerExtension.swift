//
//  UIViewControllerExtension.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 19.06.2022.
//

import UIKit

extension UIViewController {

    func showAlert(with title: String) -> UIAlertController{
        let alertController = UIAlertController(
            title: title,
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
