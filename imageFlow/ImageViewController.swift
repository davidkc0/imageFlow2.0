//
//  ImageViewController.swift
//  imageFlow
//
//  Created by David Ciaffoni on 7/18/16.
//  Copyright © 2016 David Ciaffoni. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Haneke
import DKImagePickerController

class ImageViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    

    var refreshControl: UIRefreshControl!
    var collectionViewLayout: CustomImageFlowLayout!
    var imageArray : [UIImage] = []


    @IBOutlet weak var cellView: UICollectionView!
    
    @IBAction func addImageButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    
// ADD IMAGE.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        PKHUD.sharedHUD.contentView = PKHUDRotatingImageView(image: PKHUDAssets.progressCircularImage, title: "", subtitle: "")
        PKHUD.sharedHUD.show()
        let imageData = UIImageJPEGRepresentation(image, 1.0)!
        let imageFile = PFFile(name: "image.jpg", data: imageData)!
        let image = PFObject(className: "Image")
        image["imageFile"] = imageFile
        image["user"] = PFUser.currentUser()
        image.saveInBackgroundWithBlock { (success, error) in
            
            if success {
//                PKHUD.sharedHUD.hide()
                let alert = UIAlertView(title: "Upload successful!", message: "" , delegate: self, cancelButtonTitle: "OK")
                alert.show() }
            else {
                let alert = UIAlertView(title: "Upload Error", message: "Please try again." , delegate: self, cancelButtonTitle: "OK")
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        if PFUser.currentUser() == nil {
            let viewController: LogInViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        } else {
            viewDidLoad()
        }
    }

    
//    func setupCollectionView() {
//        collectionViewLayout = CustomImageFlowLayout()
//        cellView.collectionViewLayout = collectionViewLayout
//        cellView.backgroundColor = .whiteColor()
//        self.loadArray()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionViewLayout = CustomImageFlowLayout()
        cellView.collectionViewLayout = collectionViewLayout
        cellView.backgroundColor = .whiteColor()
        if PFUser.currentUser() == nil {} else {
            imageArray.removeAll()
            PKHUD.sharedHUD.contentView = PKHUDRotatingImageView(image: PKHUDAssets.progressCircularImage, title: "", subtitle: "")
            PKHUD.sharedHUD.show()
            self.loadArray()
        }
    }
    
    // LOAD IMAGE
    func loadArray(){
        let userImages = PFQuery(className: "Image")
        userImages.whereKey("user", equalTo: PFUser.currentUser()!)
        
        let query = PFQuery.orQueryWithSubqueries([userImages])
        
        query.includeKey("user")
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            
            
            if let result = result {
                for object in result{
                    
                    let imageFromParse = object["imageFile"] as! PFFile
                    imageFromParse.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                        if let data = data {
                            let image = UIImage(data: data, scale: 0.05)!
                            // 3
                            print("image: \(image)")
                            self.imageArray.append(image)
                            print("doublecheck: " + String(self.imageArray))
                        }
                        
                        self.cellView?.reloadData()
                       
                        }
                    
                    }
                
                }
            PKHUD.sharedHUD.hide()
            }
            
        }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = self.imageArray[indexPath.row]
        if indexPath.row == self.imageArray.count-1 {
            PKHUD.sharedHUD.hide()
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 75, height: 75)
        
    }
    
// PASS IMAGE TO DETAIL VIEW.
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetailView" {
            let destController = segue.destinationViewController as! DetailViewController
            
            let selectedCellIndex = cellView.indexPathsForSelectedItems()
            let realIndex = selectedCellIndex![0]
            
            
            let passedImage = imageArray[realIndex.row]
            print(passedImage)
            print(selectedCellIndex)
            print(realIndex)
            destController.passedImageInDetailView = passedImage
        }
    }

    @IBAction func unwindToImageViewScreen(segue:UIStoryboardSegue) {
    }
    
}
