//
//  UIView.swift
//  AstroAssignment
//
//  Created by Farooque on 23/11/17.
//  Copyright © 2017 Farooque. All rights reserved.
//

import UIKit

extension UIView{
    func showLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
        
        if let _ = self.viewWithTag(200) as? UIActivityIndicatorView {
            
        } else {
            activityIndicator.center = self.center
            activityIndicator.color = UIColor.red
            activityIndicator.hidesWhenStopped = true
            activityIndicator.tag = 200
            self.addSubview(activityIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        if let activityIndicator = self.viewWithTag(200) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    
    func addShadow(){
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    
}
