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
    var channelTittleArray : [String] = []
    var temp : AstroChannelListModel!
    
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
    
    // Pragma MARK : Sort By Channel Name
    func sortByAlbhabet(){
        for index in 0...dataSource.count-1{
            let section : AstroChannelListModel = self.dataSource[index]
            self.channelTittleArray += [section.channelTitle!]
        }
        channelTittleArray.sort { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        for index in 0...self.channelTittleArray.count-1{
            
            for i in 1...self.dataSource.count-1{
                let section : AstroChannelListModel = self.dataSource[i]
                if(self.channelTittleArray[index] == section.channelTitle){
                    self.temp = self.dataSource[index]
                    self.dataSource[index] = self.dataSource[i]
                    self.dataSource[i] = self.temp
                }
            }
        }
    }
    
    // Pragma MARK : Sort By Channel Number
    func sort(){
        for _ in 0...dataSource.count-1{
            for j in 1...dataSource.count - 1{
                let section = self.dataSource[j-1]
                let sectionInd = self.dataSource[j]
                if(section.channelStbNumber! > sectionInd.channelStbNumber!){
                    self.temp = self.dataSource[j-1]
                    self.dataSource[j-1] = self.dataSource[j]
                    self.dataSource[j] = self.temp
                }
            }
        }
    }
}
