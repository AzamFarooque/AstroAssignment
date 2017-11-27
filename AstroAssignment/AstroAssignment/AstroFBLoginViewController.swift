//
//  AstroFBLoginViewController.swift
//  AstroAssignment
//
//  Created by Farooque on 27/11/17.
//  Copyright © 2017 Farooque. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

class AstroFBLoginViewController: UIViewController {

    var dict : [String : AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        view.addSubview(loginButton)
        
       
        if let accessToken = FBSDKAccessToken.current(){
            getFBUserData()
       
           
        }
    }
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
               self.dict = result as! [String : AnyObject]
               let id = self.dict["id"] as! String
               let name = self.dict["name"] as! String
               UserDefaults.standard.set(id, forKey: "id")
               UserDefaults.standard.set(name, forKey: "name")
                }
            })
        }
    }

    @IBAction func didTapSkipButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
}
