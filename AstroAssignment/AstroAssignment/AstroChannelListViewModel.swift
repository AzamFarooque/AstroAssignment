//
//  AstroChannelListViewModel.swift
//  AstroAssignment
//
//  Created by Farooque on 23/11/17.
//  Copyright © 2017 Farooque. All rights reserved.
//

import Foundation

typealias onCompletion = (Bool, String?) -> Void



class AstroChannelListViewModel {
  
var dataSource : [AstroChannelListModel] = []
//var data : [AnyObject]?
func fetchSearchResult(url : String,completionBlock : @escaping onCompletion){
    
    AstroAPIManager.sharedAstroAPIManager.request(inUrl: url) { (data, error) in
        if error == nil {
              if let channeList = data  {
                self.dataSource = channeList as! [AstroChannelListModel]
                completionBlock(true , nil)
            }
        } else {
            completionBlock(true , error)
        }
    }
}
}
