//
//  AstroAPIManager.swift
//  AstroAssignment
//
//  Created by Farooque on 23/11/17.
//  Copyright © 2017 Farooque. All rights reserved.
//

import Foundation

typealias ServiceResponse = (AnyObject?, String?) -> Void

class AstroAPIManager : NSObject{
    static let sharedAstroAPIManager = AstroAPIManager()
    var authorizationToken : String?
    let baseURL = "http://ams-api.astro.com.my"
    
    func request(inUrl : String , onCompletion: @escaping ServiceResponse) {
        
        guard let url = URL(string : baseURL+inUrl) else{
            print("Error Unwrapping URL");return
        }
        
        print(url)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data , response , error) in
       
            guard let unwrappedData = data else { print("Eroor getting data");return}
           
            do{
                if let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as? NSDictionary{
                    
                   
                    
                    if let apps = responseJSON.value(forKeyPath: "channels") as? [NSDictionary] {
                       
                       
                        let modelArray = self.mapDataToModel(channelList: apps as NSArray)
                         DispatchQueue.main.async {
                            onCompletion(modelArray,nil)
                        }
                        }
                }
            }
            catch{
                onCompletion(nil,nil)
                print("Eroor getting API data : \(error.localizedDescription)")
         }
     }
        dataTask.resume()
   }
    
    private func mapDataToModel (channelList : NSArray)-> NSArray {
        let modelArray:NSMutableArray=NSMutableArray()
        for userData in channelList {
            let user:AstroChannelListModel=AstroChannelListModel(dictionary: (userData as! NSDictionary) as! [String : AnyObject])
            modelArray.add(user)
        }
        return modelArray
    }
}
