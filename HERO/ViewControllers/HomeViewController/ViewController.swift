//
//  ViewController.swift
//  HERO
//
//  Created by Clifford Yin on 1/24/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI
import ChameleonFramework
import CoreData
import MessageUI

/* This code manages the main page of the HERO app. It pulls post data/images from Firebase database and storage and sets them up in a collectionView. Blocked posts are specific to each user, and are saved in core data. */
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, ChooseBlockDelegate, MFMailComposeViewControllerDelegate {

    // MARK: Properties
    
    var blocked = [NSManagedObject]()
    var colorArray = ColorSchemeOf(colorSchemeType: ColorScheme.complementary, color: FlatYellow(), isFlatScheme: true)
    var darkOrange: UIColor!
    var goldOrange: UIColor!
    var yellowOrange: UIColor!
    var purple: UIColor!
    var darkPurple: UIColor!
    var tanColor = UIColor.init(red: 224/255, green: 211/255, blue: 153/255, alpha: 1.0)
    var blockedDevices = [String]()
    
    var posts = [post](){ didSet {
        collection.reloadData()
            }
        }
    
    var blockProcess = false
    var reportProcess = false
    var ref: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    var filterName = "none"
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        // Tracking if it is first launch of the app; if it is, let user agree to EULA requirements
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            print("Not first launch.")
        } else {
            let EULAController = storyBoard.instantiateViewController(withIdentifier: "EULA") as! EULA
            self.present(EULAController, animated: true, completion: nil)
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alertController = UIAlertController(title: "No Internet Connection", message:
                "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        loadCore()
        // Implement Chameleon graphics
        self.darkOrange = colorArray[0]
        self.goldOrange = colorArray[1]
        self.yellowOrange = colorArray[2]
        self.purple = colorArray[3]
        self.darkPurple = colorArray[4]
        let colors:[UIColor] = [
            self.tanColor,
            UIColor.flatWhite()
        ]
        view.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: view.frame, colors: colors)
        self.uploadButton.tintColor = purple
        self.categories.tintColor = purple
        if let font = UIFont(name: "AvenirNext-Bold", size: 15) {
            uploadButton.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
            categories.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
            removeFilter.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
            
        }
        
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        collection.dataSource = self
        collection.delegate = self
        load()
        loadBlocked()
    }

    
    // MARK: IBOutlets/Actions
    
    @IBOutlet weak var removeFilter: UIBarButtonItem!
    @IBOutlet weak var categories: UIBarButtonItem!
    @IBOutlet weak var fixedSpace2: UIBarButtonItem!
    @IBOutlet weak var buttoned: UIButton!
    @IBOutlet weak var filterPic: UIImageView!
    @IBOutlet weak var collection: UICollectionView!
    
    
    // Removes a filter for the type of community service
    @IBAction func removeFilt(_ sender: Any) {
        self.filterName = "none"
        load()
        collection.reloadData()
    }
    
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    @IBOutlet weak var space: UIBarButtonItem!
    @IBOutlet weak var block: UIBarButtonItem!
    
    // When the user needs to block a post, block options are presented as a popup
    @IBAction func blocking(_ sender: Any) {
        if (self.blockProcess == false && self.reportProcess == false){
        let popoverViewController = self.storyboard?.instantiateViewController(withIdentifier: "blockChoices") as! blockChoices
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.preferredContentSize = CGSize(width:300, height:150)
        popoverViewController.delegate2 = self
        
        let popoverPresentationViewController = popoverViewController.popoverPresentationController
        popoverPresentationViewController?.permittedArrowDirections = UIPopoverArrowDirection.down
        popoverPresentationViewController?.delegate = self
        popoverPresentationViewController?.sourceView = self.buttoned
        popoverPresentationViewController?.sourceRect = CGRect(x:0, y:0, width: block.width/2, height: 30)
        
        present(popoverViewController, animated: true, completion: nil)
        } else if (self.blockProcess == true) { // Sequences that reflect user options regarding blocking posts and filtering
            
            self.removeFilter.isEnabled = true
            self.uploadButton.isEnabled = true
            self.categories.isEnabled = true
            if (self.filterName == "none"){
                self.removeFilter.title = ""
            } else {
                self.removeFilter.title = "Remove Filter"
            }
            self.uploadButton.title = "Upload"
            self.categories.title = "Categories"
            if (self.filterName == "none"){
                self.fixedSpace2.width = 40
            } else {
                self.fixedSpace2.width = 0
            }
            self.collection.reloadData()
            self.block.title = .none
            self.block.image = UIImage(named: "Block")
            self.blockProcess = false
        } else if (self.reportProcess == true) {
            self.removeFilter.isEnabled = true
            self.uploadButton.isEnabled = true
            self.categories.isEnabled = true
            if (self.filterName == "none"){
                self.removeFilter.title = ""
            } else {
                self.removeFilter.title = "Remove Filter"
            }
            self.uploadButton.title = "Upload"
            self.categories.title = "Categories"
            if (self.filterName == "none"){
                self.fixedSpace2.width = 40
            } else {
                self.fixedSpace2.width = 0
            }
            self.collection.reloadData()
            self.block.title = .none
            self.block.image = UIImage(named: "Block")
            self.reportProcess = false
        }
    }
    
    // If user needs to report post, there is an email option embedded here
    func sendEmail(id: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Reporting Post")
            mail.setToRecipients(["heroapp17@gmail.com"])
            mail.setMessageBody("I would like to report post" + " \"\(id)\" for: ", isHTML: true)
            present(mail, animated: true)
        } else {
            // Mail failed
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func chooseBlock(chosenBlock: String) {
        if (chosenBlock == "Block Post") { // User is trying to block post(s)
            self.categories.isEnabled = false
            self.collection.reloadData()
            self.removeFilter.isEnabled = false
            self.uploadButton.isEnabled = false
            self.categories.isEnabled = false
            self.removeFilter.title = ""
            self.uploadButton.title = ""
            self.categories.title = ""
            self.block.image = .none
            self.block.title = "Done"
            self.fixedSpace2.width = 165
            self.blockProcess = true
        }
        else if (chosenBlock == "Unblock All") { // User wants to unblock all posts, deletes "blocked"              entities from core data
            
            deleteAllData(entity: "Blocked")
        } else if (chosenBlock == "Report Post") { // User wishes to report a post
            self.collection.reloadData()
            self.removeFilter.isEnabled = false
            self.uploadButton.isEnabled = false
            self.categories.isEnabled = false
            self.removeFilter.title = ""
            self.uploadButton.title = ""
            self.categories.title = ""
            self.block.image = .none
            self.block.title = "Done"
            self.fixedSpace2.width = 165
            self.reportProcess = true

        }
    }

    // Sets up each cell as a post
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collection.dequeueReusableCell(withReuseIdentifier: "thumb", for: indexPath) as? PicCell {
            let currentPost = posts[indexPath.row]
            cell.configureCell(name2: currentPost.name, caption2: currentPost.caption, club2: currentPost.club, imageReference2: currentPost.imageReference)
            cell.layer.borderColor = goldOrange.cgColor
            cell.layer.borderWidth = 5.0
            cell.layer.cornerRadius = 5
    
            // Different tints based on user action
            let colored = UIColor.init(red: 230/255, green: 74/255, blue: 70/255, alpha: 0.5)
            if (self.blockProcess == true) {
                cell.tintView.backgroundColor = colored
            } else if (self.reportProcess == true) {
                let yellowTint = yellowOrange.withAlphaComponent(0.5)
                cell.tintView.backgroundColor = yellowTint
            } else {
                cell.tintView.backgroundColor = .clear
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    
    }
    
    // Various functions after selected based on current user action
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.blockProcess == false && self.reportProcess == false) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier :"postPage") as! postPage
            viewController.post = self.posts[indexPath.row]
            self.present(viewController, animated: true)
        } else if (self.blockProcess == true) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            let entity =  NSEntityDescription.entity(forEntityName: "Blocked", in: managedContext)
            let adding = NSManagedObject(entity: entity!, insertInto: managedContext)
            let objectid = self.posts[indexPath.row].imageReference
            adding.setValue(objectid, forKey: "id")
            
            do {
                try managedContext.save()
                self.blocked.append(adding)
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            load()
        } else if (self.reportProcess == true) {
    
            let objected = self.posts[indexPath.row].imageReference
            self.sendEmail(id: objected)
            self.removeFilter.isEnabled = true
            self.uploadButton.isEnabled = true
            self.categories.isEnabled = true
            if (self.filterName == "none"){
                self.removeFilter.title = ""
            } else {
                self.removeFilter.title = "Remove Filter"
            }
            self.uploadButton.title = "Upload"
            self.categories.title = "Categories"
            if (self.filterName == "none"){
                self.fixedSpace2.width = 50
            } else {
                self.fixedSpace2.width = 10
            }
            self.collection.reloadData()
            self.block.title = .none
            self.block.image = UIImage(named: "Block")
            self.reportProcess = false

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 // row count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 155, height: 155)
    }
    
    func loadCore(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Blocked")
        
        do {
            let data = try managedContext.fetch(fetchRequest)
            blocked = data as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    // Delete all of the stored core data
    func deleteAllData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
                try managedContext.save()
            }
        } catch let error as NSError {
        
        }
        load()
    }
    
    func loadBlocked(){
        ref.child("blocked").observe(.value) { (snapshot: FIRDataSnapshot!) in
            for item in snapshot.children {
                let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                let blok = childSnapshot.key
                self.blockedDevices.append(blok)
            }
            self.disable()
        }
    }
    
    // If this user has been blocked, he or she cannot access the app
    func disable(){
        let device = UIDevice.current.identifierForVendor!.uuidString
        if (self.blockedDevices.contains(device)){
            fatalError()
        }
    }
    
    // Loading all of the posts' data and images from Firebase
    func load(){
        loadCore()
        storageRef = FIRStorage.storage().reference()
        ref = FIRDatabase.database().reference()
        if (self.filterName == "none"){
            ref.observe(.value) { (snapshot: FIRDataSnapshot!) in
                var newPosts = [post]()
                for item in snapshot.children {
                    self.filterPic.image = UIImage(named: "HERO")
                    let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                    let id = childSnapshot.key
                    if (id != "blocked") {
                        let nameValue = childSnapshot.value as? NSDictionary
                        let name = nameValue?["name"] as! String
                        let captionValue = childSnapshot.value as? NSDictionary
                        let caption = captionValue?["caption"] as! String
                        let clubValue = childSnapshot.value as? NSDictionary
                        let club = clubValue?["club"] as! String
                        let posted = post(name1: name, caption1: caption, club1: club, imageReference1: id)
                        var blockedID = [String]()
                        
                        for block2 in self.blocked {
                            blockedID.append(block2.value(forKey: "id") as! String)
                        }
                        if !(blockedID.contains(id)) {
                            newPosts.append(posted)
                        }
                    }
                    
                }
                self.posts = newPosts
            }
        } else {
            ref.observe(.value) { (snapshot: FIRDataSnapshot!) in
                var newPosts = [post]()
                for item in snapshot.children {
                    
                    let childSnapshot = snapshot.childSnapshot(forPath: (item as AnyObject).key)
                    let id = childSnapshot.key
                    if (id != "blocked") {
                        let nameValue = childSnapshot.value as? NSDictionary
                        let name = nameValue?["name"] as! String
                        let captionValue = childSnapshot.value as? NSDictionary
                        let caption = captionValue?["caption"] as! String
                        let clubValue = childSnapshot.value as? NSDictionary
                        let club = clubValue?["club"] as! String
                        let posted = post(name1: name, caption1: caption, club1: club, imageReference1: id)
                        self.filterPic.image = UIImage(named: self.filterName)
                        var blockedID = [String]()
                        for block2 in self.blocked {
                            blockedID.append(block2.value(forKey: "id") as! String)
                        }
                        if (club == self.filterName && !(blockedID.contains(id))){
                            newPosts.append(posted)
        
                        }
                    }
                }
                self.posts = newPosts
            }
        }
        if (self.filterName == "none") {
            removeFilter.title = ""
            removeFilter.isEnabled = false
            self.space.width = 100
            self.fixedSpace2.width = 50
        } else {
            removeFilter.title = "Remove Filter"
            removeFilter.isEnabled = true
            removeFilter.tintColor = .red
            self.space.width = 40
            self.fixedSpace2.width = 10
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toUploading") {
            let dest = segue.destination as! Upload
            dest.filter = self.filterName
        }
    }
}

