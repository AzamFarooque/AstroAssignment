//
//  ViewController.swift
//  AstroAssignment
//
//  Created by Farooque on 23/11/17.
//  Copyright © 2017 Farooque. All rights reserved.
//

import UIKit

class AstroChannelVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    let channelList : AstroChannelListViewModel = AstroChannelListViewModel()
    
    let gridFlowLayout = EventGridFlowLayout()
    let listFlowLayout = EventListFlowLayout()
    var isGridFlowLayoutUsed: Bool = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelList.fetchSearchResult(url :"/ams/v3/getChannelList") { (success, error) in
            if success {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.reloadData()
               } else if error != nil {
            }
        }
    setupInitialLayout()
     }
    
    func setupInitialLayout() {
        isGridFlowLayoutUsed = true
        collectionView.collectionViewLayout = gridFlowLayout
    }

    // MARK: UICollectionViewDataSource
    
    
         func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return channelList.dataSource.count == 0 ? 0 :channelList.dataSource.count
        }
        
         func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AstroChannelListCollectionViewCell", for: indexPath) as! AstroChannelListCollectionViewCell
            
         let section = self.channelList.dataSource[indexPath.row] as AstroChannelListModel!
            cell.update(model : section!)
            cell.backgroundColor = UIColor.green
            return cell
        }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

