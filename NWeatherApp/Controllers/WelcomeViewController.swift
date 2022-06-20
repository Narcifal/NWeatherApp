//
//  WelcomeViewController.swift
//  NWeatherApp
//
//  Created by Denys Niestierov on 14.06.2022.
//

import FBSDKLoginKit
import GoogleSignIn

final class WelcomeViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet private var backgroundImage: UIImageView!
    @IBOutlet private weak var googleButton: UIButton!
    @IBOutlet private weak var facebookLoginButton: UIButton!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set a random background image
        setRandomBackgroundImage()

        //LogOut from Facebook on load
        LoginManager().logOut()
        
        //LogOut from Google on load
        GIDSignIn.sharedInstance().signOut()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    //MARK: - IBActions -
    
    //SignIn with Google
    @IBAction private func googleSignIn(_ sender: UIButton) {
        if(GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            //LogOut Google manager
            GIDSignIn.sharedInstance().signOut()
            
            //Display alert controller
            let alertController =
                AddingAlertController().successfullySignedOutPopUp(with: "Google")
            present(alertController, animated: true, completion: nil)
        } else {
            //LogIn Google manager
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    //SignIn with Facebook
    @IBAction private func facebookSignIn(_ sender: UIButton) {
        //Check if user logged in
        if let token = AccessToken.current, !token.isExpired {
            facebookLoginResult()
            
            //LogOut Facebook manager
            LoginManager().logOut()
            
            //Display alert controller
            let alertController =
                AddingAlertController().successfullySignedOutPopUp(with: "Facebook")
            present(alertController, animated: true, completion: nil)
        } else {
            //LogIn Facebook manager
            LoginManager().logIn()
        }
    }
    
    //MARK: - Private -
    //Get Facebook result data
    private func facebookLoginResult() {
        let token = AccessToken.current?.tokenString
        let request = FBSDKLoginKit.GraphRequest(
            graphPath: "me",
            parameters: ["fields": "email, name"],
            tokenString: token,
            version: nil,
            httpMethod: .get)

        request.start { connection, result, error in
            print(result as Any)
        }
    }
    
    //Change background image to random
    private func setRandomBackgroundImage() {
        let images = [Constants.BackgroundImages.deepNight,
                      Constants.BackgroundImages.fallingStar,
                      Constants.BackgroundImages.greenLeaves,
                      Constants.BackgroundImages.riverMountain,
                      Constants.BackgroundImages.sunsetField,
                      Constants.BackgroundImages.twilightMoon]
        let randomImage = UIImage(named:
                                    images.randomElement() ?? Constants.BackgroundImages.greenLeaves)
        backgroundImage.image = randomImage
    }
}
