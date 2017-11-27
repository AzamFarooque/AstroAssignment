//
//  ViewController.swift
//  AstroAssignment
//
//  Created by Farooque on 23/11/17.
//  Copyright © 2017 Farooque. All rights reserved.
//

import UIKit
import CoreData

class AstroChannelVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,AstroChannelListCellDelegate {
    
    var navController : UINavigationController!
    let channelList : AstroChannelListViewModel = AstroChannelListViewModel()
    var channelListArray :  [AstroChannelListModel] = []
    var sortedArray : [AstroChannelListModel] = []
    var channelTittleArray : [String] = []
    
    let gridFlowLayout = EventGridFlowLayout()
    let listFlowLayout = EventListFlowLayout()
    var isGridFlowLayoutUsed: Bool = false
    var temp : AstroChannelListModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        
        self.view.showLoadingIndicator()
        
     
        channelList.fetchSearchResult(url :"/ams/v3/getChannelList") { (success, error) in
            if success {
            self.sort()
           // self.sortByAlbhabet()
        //self.quickSort(array: self.channelList.dataSource, low: 0, high: self.channelList.dataSource.count - 1)
     
                //for index in 0...9{
            self.channelListArray = self.channelList.dataSource
               // }
                
            DispatchQueue.main.async {
            self.collectionView.reloadData()
           self.view.hideLoadingIndicator()
                }
               } else if error != nil {
            }
        }
    setupInitialLayout()
    
    }
    @IBAction func changeSegmentIndex(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            isGridFlowLayoutUsed = true
            collectionView.collectionViewLayout = gridFlowLayout
        }
        if sender.selectedSegmentIndex == 1{
            isGridFlowLayoutUsed = false
            collectionView.collectionViewLayout = listFlowLayout
        }

        
    }
//    func quickSort(array : [AstroChannelListModel] = [] , low : Int , high : Int){
//        if (low < high){
//            let pi : Int = partition(array: array , low: low, high: high)
//            quickSort(array: array, low: low, high: pi - 1);
//            quickSort(array: array, low: pi + 1, high: high);
//        }
//    }
//    
//    
//    func partition(array : [AstroChannelListModel] = [] , low : Int , high : Int) -> Int {
//        let pivot : AstroChannelListModel = array[high] 
//        var i : Int = (low - 1)
//        
//        for j in low...high-1{
//            
//           let section : AstroChannelListModel = array[j]
//           
//            if (section.channelStbNumber! <= pivot.channelStbNumber!)
//            {
//                i = i + 1
//               // swap(&arr[i], &arr[j]);
//                self.temp = self.channelList.dataSource[i]
//                self.channelList.dataSource[i] = self.channelList.dataSource[j]
//                self.channelList.dataSource[j] = self.temp
//
//            }
//        }
//       // swap(&arr[i + 1], &arr[high]);
//        self.temp = self.channelList.dataSource[i+1]
//        self.channelList.dataSource[i+1] = self.channelList.dataSource[high]
//        self.channelList.dataSource[high] = self.temp
//        return (i + 1)
//        
//    }
//    
    
    func sortByAlbhabet(){
        
        for index in 0...self.channelList.dataSource.count-1{
            let section : AstroChannelListModel = self.channelList.dataSource[index]
            
            self.channelTittleArray += [section.channelTitle!]
            
        }
        channelTittleArray.sort { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }

        
        for index in 0...self.channelTittleArray.count-1{
            
            for i in 1...self.channelList.dataSource.count-1{
                let section : AstroChannelListModel = self.channelList.dataSource[i]
                if(self.channelTittleArray[index] == section.channelTitle){
                    self.temp = self.channelList.dataSource[index]
                    self.channelList.dataSource[index] = self.channelList.dataSource[i]
                    self.channelList.dataSource[i] = self.temp
                    
                    
                }
                
                
            }
        }

        
    }
    
    
    func sort(){
        for _ in 0...self.channelList.dataSource.count-1{
            for j in 1...self.channelList.dataSource.count - 1{
                let section = self.channelList.dataSource[j-1]
                let sectionInd = self.channelList.dataSource[j]
                if(section.channelStbNumber! > sectionInd.channelStbNumber!){
                    self.temp = self.channelList.dataSource[j-1]
                    self.channelList.dataSource[j-1] = self.channelList.dataSource[j]
                    self.channelList.dataSource[j] = self.temp
                }
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
        
        return UIEdgeInsetsMake(-63, 0, 0, 0)
    }
    
    func presentLoginController(){
        
                let storyboard = UIStoryboard(storyboard: .Login)
                let subsectionVC : AstroFBLoginViewController = storyboard.instantiateViewController()
                navController = UINavigationController(rootViewController: subsectionVC) // Creating a
                navController.isNavigationBarHidden = true
                self.present(navController, animated:true, completion: nil)
        
        

    }

    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
//        
//        
//        if indexPath.row == channelListArray.count - 1{
//            
//            for index in channelListArray.count - 1...channelListArray.count + 9{
//            self.channelListArray += [self.channelList.dataSource[index]]
//            }
//            
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
//    }
//
//     internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        
//       
//    let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AstroFooterCollectionViewCell", for: indexPath as IndexPath) as! AstroFooterCollectionViewCell
//            
//            footerView.backgroundColor = UIColor.green;
//            return footerView
//         }
//    
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AstroFooterCollectionViewCell", for: indexPath as IndexPath)
//        headerView.backgroundColor = UIColor.red
//        return headerView
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: self.view.frame.size.width, height: 300)
//    }

    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}
extension UIView{
func showLoadingIndicator() {
    let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
    
    if let _ = self.viewWithTag(200) as? UIActivityIndicatorView {
        
    } else {
        activityIndicator.frame = CGRect(x:0,y:0, width : 40 , height :40)
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

    
    
}

