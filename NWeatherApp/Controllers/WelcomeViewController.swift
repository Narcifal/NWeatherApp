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

    @IBOutlet var backgroundImage: UIImageView!

    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load random background image
        randomBackgroundImage()
        googleButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 0)
        googleButton.contentHorizontalAlignment = .center
        //LogOut from Facebook on load
        LoginManager().logOut()
        
        //LogOut from Google on load
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

    
    //MARK: SignIn with Google
    
    @IBAction func googleSignIn(_ sender: UIButton) {
        if(GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            //LogOut Google manager
            GIDSignIn.sharedInstance().signOut()
            
            //Display popup
            successfullySignedInPopUp(with: "Google", didLogged: "Out")
        }
        else
        {
            //LogIn Google manager
            GIDSignIn.sharedInstance().signIn()
        }
    }

    
    
    //MARK: SignIn with Facebook
    
    @IBAction func facebookSignIn(_ sender: UIButton) {
        facebookLogInOut()
    }
    
    func facebookLogInOut() {
        //Method to check if user logged in
        if let token = AccessToken.current, !token.isExpired {
            facebookLoginResult()
            
            //LogOut Facebook manager
            LoginManager().logOut()
            
            //Display popup
            successfullySignedInPopUp(with: "Facebook", didLogged: "Out")
        } else {
            //LogIn Facebook manager
            LoginManager().logIn()
        }
    }
    
    func facebookLoginResult() {
        let token = AccessToken.current?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)

        request.start { connection, result, error in
            print(result as Any)
            //print(token as Any)
            //print(AccessToken.current as Any)
        }
    }
    
    
    //MARK: Popup to display if user logged in or logged out
    
    func successfullySignedInPopUp(with app: String, didLogged: String) {
        let alertController = UIAlertController(title: "You have successfully Logged \(didLogged) to your \(app) account!", message: "", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: nil)

        alertController.addAction(continueAction)

        present(alertController, animated: true, completion: nil)
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
