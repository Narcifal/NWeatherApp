//
//  WelcomeViewController.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 14.06.2022.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class WelcomeViewController: UIViewController, LoginButtonDelegate {

    @IBOutlet var backgroundImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        randomBackgroundImage()
        
        let gSignIn = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 230, height: 48))
        gSignIn.center = view.center
        view.addSubview(gSignIn)
        
        let loginButton = FBLoginButton()
        loginButton.bottomAnchor = view.bottomAnchor
        loginButton.delegate = self
        loginButton.permissions = ["public_profile", "email"]
        view.addSubview(loginButton)
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString

        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)

        request.start { connection, result, error in
            print(result)
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        LoginManager().logOut()
    }

    
    //MARK: Change background image to random
    func randomBackgroundImage() {
            let randomNumber = Int.random(in: 0..<6)
            
            switch(randomNumber) {
            case 0:
                backgroundImage.image = UIImage(named: Constants.BackgroundImage.deepNight)
            case 1:
                backgroundImage.image = UIImage(named: Constants.BackgroundImage.fallingStar)
            case 2:
                backgroundImage.image = UIImage(named: Constants.BackgroundImage.greenLeaves)
            case 3:
                backgroundImage.image = UIImage(named: Constants.BackgroundImage.riverMountain)
            case 4:
                backgroundImage.image = UIImage(named: Constants.BackgroundImage.sunsetField)
            case 5:
                backgroundImage.image = UIImage(named: Constants.BackgroundImage.twilightMoon)
            default:
                backgroundImage.image = UIImage(named: Constants.BackgroundImage.greenLeaves)
            }
            
            backgroundImage.alpha = 0.5
        }

}
