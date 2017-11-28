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
        
        if (FBSDKAccessToken.current()) != nil{
            getFBUserData()
        }
        
    }
    // Pragma MARK : Facebook Login Button Action
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        if sender.titleLabel?.text == "Login"{
            let loginManager = LoginManager()
            loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
                switch loginResult {
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("User cancelled login.")
                case .success:
                    sender.setTitle("Logout", for: .normal)
                    self.getFBUserData()
                    
                }
            }
        }
        else{
            UserDefaults.standard.removeObject(forKey: "id")
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            sender.setTitle("Login", for: .normal)
        }
        
    }
    
    // Pragma Mark : Function is fetching the user data
    
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
    
    // Pragma MARK : Back Buttton Action
    
    @IBAction func didTapSkipButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
