//
//  AstroChannelListModel.swift
//  AstroAssignment
//
//  Created by Farooque on 23/11/17.
//  Copyright © 2017 Farooque. All rights reserved.
//

import Foundation

class AstroChannelListModel: NSObject {
    
    var channelId : Int?
    var channelTitle : String?
    var channelStbNumber : Int?
    
    init(dictionary : [String : AnyObject]){
        self.channelId = dictionary["channelId"] as? Int
        self.channelTitle = dictionary["channelTitle"] as? String
        self.channelStbNumber = dictionary["channelStbNumber"] as? Int
        
    }
}
