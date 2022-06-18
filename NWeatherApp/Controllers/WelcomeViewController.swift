//
//  WelcomeViewController.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 14.06.2022.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn


class WelcomeViewController: UIViewController {

    @IBOutlet private var backgroundImage: UIImageView!

    @IBOutlet private weak var googleButton: UIButton!
    @IBOutlet private weak var facebookLoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load random background image
        randomBackgroundImage()

        //LogOut from Facebook on load
        LoginManager().logOut()
        
        //LogOut from Google on load
        GIDSignIn.sharedInstance().signOut()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

    
    //SignIn with Google
    
    @IBAction func googleSignIn(_ sender: UIButton) {
        if(GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            //LogOut Google manager
            GIDSignIn.sharedInstance().signOut()
            
            //Display popup
            successfullySignedOutPopUp(with: "Google", didLogged: "Out")
        }
        else
        {
            //LogIn Google manager
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    
    //SignIn with Facebook
    
    @IBAction func facebookSignIn(_ sender: UIButton) {
        facebookLogInOut()
    }
    
    
    //Facebook user auth check
    
    func facebookLogInOut() {
        //Check if user logged in
        if let token = AccessToken.current, !token.isExpired {
            facebookLoginResult()
            
            //LogOut Facebook manager
            LoginManager().logOut()
            
            //Display popup
            successfullySignedOutPopUp(with: "Facebook", didLogged: "Out")
        } else {
            //LogIn Facebook manager
            LoginManager().logIn()
        }
    }
    
    
    //Get Facebook result data
    
    func facebookLoginResult() {
        let token = AccessToken.current?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)

        request.start { connection, result, error in
            print(result as Any)
        }
    }

    
    //Change background image to random
    
    func randomBackgroundImage() {
        let randomNumber = Int.random(in: 0..<6)
        
        switch(randomNumber) {
        case 0:
            backgroundImage.image = UIImage(named: Constants.BackgroundImages.deepNight)
        case 1:
            backgroundImage.image = UIImage(named: Constants.BackgroundImages.fallingStar)
        case 2:
            backgroundImage.image = UIImage(named: Constants.BackgroundImages.greenLeaves)
        case 3:
            backgroundImage.image = UIImage(named: Constants.BackgroundImages.riverMountain)
        case 4:
            backgroundImage.image = UIImage(named: Constants.BackgroundImages.sunsetField)
        case 5:
            backgroundImage.image = UIImage(named: Constants.BackgroundImages.twilightMoon)
        default:
            backgroundImage.image = UIImage(named: Constants.BackgroundImages.greenLeaves)
        }
        
        backgroundImage.alpha = 0.5
    }

}
