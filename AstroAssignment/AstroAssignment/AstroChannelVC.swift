//
//  ViewController.swift
//  AstroAssignment
//
//  Created by Farooque on 23/11/17.
//  Copyright © 2017 Farooque. All rights reserved.
//

import UIKit
import CoreData

class AstroChannelVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,AstroChannelListCellDelegate,UITabBarDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var navController : UINavigationController!
    let channelList : AstroChannelListViewModel = AstroChannelListViewModel()
    var channelListArray :  [AstroChannelListModel] = []
    var sortedArray : [AstroChannelListModel] = []
    var channelTittleArray : [String] = []
    
    @IBOutlet weak var headerView: UIView!
    let gridFlowLayout = EventGridFlowLayout()
    let listFlowLayout = EventListFlowLayout()
    var isGridFlowLayoutUsed: Bool = false
    var temp : AstroChannelListModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetcData(sort: "SortChannelID")
        headerView.addShadow()
        setupInitialLayout()
     
    }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    @IBAction func changeSegmentIndex(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
//            isGridFlowLayoutUsed = true
//            collectionView.collectionViewLayout = gridFlowLayout
            channelList.dataSource.removeAll()
            channelList.channelTittleArray.removeAll()
            fetcData(sort: "SortChannelID")
           
        }
        if sender.selectedSegmentIndex == 1{
//            isGridFlowLayoutUsed = false
//            collectionView.collectionViewLayout = listFlowLayout
            channelList.dataSource.removeAll()
            fetcData(sort: "SortChannelAlphabet")
        }
    }
    
    func fetcData(sort : String){
        self.collectionView.showLoadingIndicator()
      //  segmentControl.setEnabled(true, forSegmentAt: 0)
        channelList.fetchSearchResult(url :"/ams/v3/getChannelList") { (success, error) in
            if success {
             if sort == "SortChannelID"{
            self.channelList.sort()
                }
             else{
            self.channelList.sortByAlbhabet()
                }
            self.channelListArray = self.channelList.dataSource
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.hideLoadingIndicator()
                }
            } else if error != nil {
            }
        }

    }
    

    func setupInitialLayout() {
        isGridFlowLayoutUsed = true
        collectionView.collectionViewLayout = gridFlowLayout
    }

    // MARK: UICollectionViewDataSource
    
    
         func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return channelListArray.count == 0 ? 0 :channelListArray.count
        }
        
         func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AstroChannelListCollectionViewCell", for: indexPath) as! AstroChannelListCollectionViewCell
            
         let section = self.channelListArray[indexPath.row] as AstroChannelListModel!
            cell.addShadow()
            cell.backgroundColor = UIColor.white
            cell.favouriteButton.tag = indexPath.row
            cell.update(model : section! , buttonTag : indexPath.row)
            cell.delegate = self
            if cell.channelListArray.count == 0 {
            cell.channelListArray = channelList.dataSource
            }
            return cell
        }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(2, 0, 0, 0)
    }
    
    func presentLoginController(){
    let storyboard = UIStoryboard(storyboard: .Login)
    let subsectionVC : AstroFBLoginViewController = storyboard.instantiateViewController()
    navController = UINavigationController(rootViewController: subsectionVC) // Creating a
    navController.isNavigationBarHidden = true
    self.present(navController, animated:true, completion: nil)
    }
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}
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
    }
    activityIndicator.startAnimating()
}
    func hideLoadingIndicator() {
        if let activityIndicator = self.viewWithTag(200) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }

    
    func addShadow(){
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }

    
}

