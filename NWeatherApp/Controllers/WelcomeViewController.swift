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

    @IBOutlet weak var facebookLoginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        randomBackgroundImage()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        
        LoginManager().logOut()
    }

    @IBAction func googleSignIn(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebookSignIn(_ sender: UIButton) {
        
        if let token = AccessToken.current, !token.isExpired {

                    let token = token.tokenString

                    let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)

                    request.start { connection, result, error in
                        print(result as Any)
                    }

                } else {
                    let manager = LoginManager()
                    manager.logIn()
                }
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

//MARK: Facebook delegate methods
extension WelcomeViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString

        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)

        request.start { connection, result, error in
            print(result as Any)
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        LoginManager().logOut()
    }
}

//MARK: Google delegate methods

extension WelcomeViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            print("User email: \(user?.profile.email ?? "no email")")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ((GIDSignIn.sharedInstance()?.handle(url)) != nil)
    }
}
