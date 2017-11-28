//
//  ViewController.swift
//  AstroAssignment
//
//  Created by Farooque on 23/11/17.
//  Copyright © 2017 Farooque. All rights reserved.
//

import UIKit
import CoreData
import FacebookLogin
import FBSDKLoginKit


class AstroChannelVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,AstroChannelListCellDelegate {
    var channelFavouritedList: [NSManagedObject] = []
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var gridButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var navController : UINavigationController!
    let channelList : AstroChannelListViewModel = AstroChannelListViewModel()
    var channelListArray :  [AstroChannelListModel] = []
    @IBOutlet weak var headerView: UIView!
    let gridFlowLayout = AstroGridFlowLayout()
    let listFlowLayout = AstroListFlowLayout()
    var isGridFlowLayoutUsed: Bool = false
    @IBOutlet weak var collectionView: UICollectionView!
    let reuseidentifer = "AstroChannelListCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetcData(sort: AstroConstant.sortByChannelID)
        headerView.addShadow()
        setupInitialLayout()
    }
    
    // Pragma MARK : ViewDidAppear
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "id") != nil{
            profileNameLabel.isHidden = false
            logoutButton.isHidden = false
            let name = UserDefaults.standard.value(forKey: "name")
            profileNameLabel.text = name! as? String
        }
        else{
            profileNameLabel.isHidden = true
            logoutButton.isHidden = true
        }
    }
    
    // Pragma MARK : Sort by Channel id or Channel name
    
    @IBAction func changeSegmentIndex(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            channelList.dataSource.removeAll()
            channelList.channelTittleArray.removeAll()
            fetcData(sort: AstroConstant.sortByChannelID)
        }
        if sender.selectedSegmentIndex == 1{
            channelList.dataSource.removeAll()
            fetcData(sort: AstroConstant.sortByChannelName)
        }
    }
    
    // Pragma MARK : Fetch Channel List
    
    func fetcData(sort : String){
        self.collectionView.showLoadingIndicator()
        channelList.fetchSearchResult(url :AstroConstant.channelListURL) { (success, error) in
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
                print("Eroor")
            }
        }
        
    }
    
    // Pragma MARK : setupInitialLayout
    
    func setupInitialLayout() {
        isGridFlowLayoutUsed = true
        collectionView.collectionViewLayout = gridFlowLayout
    }
    
    // Pragm MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channelListArray.count == 0 ? 0 :channelListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseidentifer, for: indexPath) as! AstroChannelListCollectionViewCell
        let section = self.channelListArray[indexPath.row] as AstroChannelListModel!
        cell.addShadow()
        cell.backgroundColor = UIColor.white
        cell.favouriteButton.tag = indexPath.row
        cell.update(model : section! , buttonTag : indexPath.row)
        cell.delegate = self
        cell.channelListArray = channelList.dataSource
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(2, 0, 0, 0)
    }
    
    // Pragm MARK: presentLoginController
    
    func presentLoginController(){
        let storyboard = UIStoryboard(storyboard: .Login)
        let subsectionVC : AstroFBLoginViewController = storyboard.instantiateViewController()
        navController = UINavigationController(rootViewController: subsectionVC)
        navController.isNavigationBarHidden = true
        self.present(navController, animated:true, completion: nil)
    }
    
    // Pragm MARK: GridLayout
    
    @IBAction func didTapGridLayout(_ sender: UIButton) {
        gridButton.setImage(UIImage(named: "selectedGrid"), for: UIControlState.normal)
        listButton.setImage(UIImage(named: "unselectedList"), for: UIControlState.normal)
        isGridFlowLayoutUsed = true
        collectionView.collectionViewLayout = gridFlowLayout
    }
    
    // Pragm MARK: ListLAyout
    
    @IBAction func didTapListLAyout(_ sender: UIButton) {
        gridButton.setImage(UIImage(named: "unselectedGrid"), for: UIControlState.normal)
        listButton.setImage(UIImage(named: "selectedList"), for: UIControlState.normal)
        isGridFlowLayoutUsed = false
        collectionView.collectionViewLayout = listFlowLayout
    }
    
    // Pragm MARK: LogoutButton Action
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        confirmLogout()
    }
    
    func confirmLogout(){
        let alertController: UIAlertController = UIAlertController(title: "Astro", message:"Are you sure you want to logout", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.logout()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func logout(){
        UserDefaults.standard.removeObject(forKey: "id")
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        logoutButton.isHidden = true
        profileNameLabel.isHidden = true
        deleteFavouritedChannelList()
        fetcData(sort: AstroConstant.sortByChannelID)
    }
    
    
    func deleteFavouritedChannelList(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Channel")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
