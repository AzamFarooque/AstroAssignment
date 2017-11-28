//
//  AstroChannelListCollectionViewCell.swift
//  AstroAssignment
//
//  Created by Farooque on 23/11/17.
//  Copyright © 2017 Farooque. All rights reserved.
//

import UIKit
import CoreData

protocol AstroChannelListCellDelegate : class {
    func presentLoginController()
}

class AstroChannelListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var channelTittle: UILabel!
    @IBOutlet weak var channelStbNumber: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    var channelListArray :  [AstroChannelListModel] = []
    var channelFavouritedList: [NSManagedObject] = []
    weak var delegate : AstroChannelListCellDelegate?

   // Pragma MARK : Update CollectionView Cell
    
    func update(model : AstroChannelListModel , buttonTag : Int){
        fetchFavouritedChannelList()
               
        channelTittle.text = model.channelTitle!
        if let number = model.channelStbNumber{
        channelStbNumber.text = "Channel No : \(number)"
        }
        if channelFavouritedList.count == 0{
        favouriteButton.setImage(UIImage(named: "unTracked"), for: UIControlState.normal)
        }
        
        
        if channelFavouritedList.count > 0 {
        for index in 0...channelFavouritedList.count-1 {
            let favouritedSection = channelFavouritedList[index]
            let channelTittle = favouritedSection.value(forKeyPath: "channelTittle") as? String
            let channelId = favouritedSection.value(forKeyPath: "channelId") as? Int
            
            if (channelTittle == model.channelTitle! && channelId == model.channelId!){
            favouriteButton.setImage(UIImage(named: "track"), for: UIControlState.normal)
                break
            }
            else{
        favouriteButton.setImage(UIImage(named: "unTracked"), for: UIControlState.normal)
              }
            }
        }
    }
    
   // Pragma MARK : Favourite Button Action
    
    @IBAction func didTapFavouriteButton(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: "id") != nil{
        if sender.currentImage!.isEqual(UIImage(named: "unTracked")){
                saveChannelList(model: channelListArray[sender.tag] , Index: sender.tag)
                sender.setImage(UIImage(named: "track"), for: UIControlState.normal)
            }
            else{
                removeChannelList(model: channelListArray[sender.tag])
                sender.setImage(UIImage(named: "unTracked"), for: UIControlState.normal)
            }
        }
        else{
        delegate?.presentLoginController()
        }
}
    // Pragma MARK : Save Channel List in Core Data
    
    func saveChannelList(model : AstroChannelListModel , Index : Int ){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "Channel",
                                       in: managedContext)!
        let channelInfo = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        channelInfo.setValue(model.channelStbNumber!, forKeyPath: "channelStbNumber")
        channelInfo.setValue(model.channelTitle!, forKeyPath: "channelTittle")
        channelInfo.setValue(model.channelId!, forKey: "channelId")
        channelInfo.setValue(Index, forKey: "index")
               do {
            try managedContext.save()
            channelFavouritedList.append(channelInfo)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    // Pragma MARK : Fetching Favourited Channel List
    
    func fetchFavouritedChannelList(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Channel")
        do {
            channelFavouritedList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // Pragma MARK : Remove Favourited Channel List
    
     func removeChannelList(model : AstroChannelListModel){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
    
        for index in 0...channelFavouritedList.count-1 {
            let favouritedSection = channelFavouritedList[index]
            let channelTittle = favouritedSection.value(forKeyPath: "channelTittle") as? String
            let channelId = favouritedSection.value(forKeyPath: "channelId") as? Int
        if (channelTittle == model.channelTitle! && channelId! == model.channelId) {
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            managedContext.delete(channelFavouritedList[index])
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                
              }
            }
          }
       }
    }
