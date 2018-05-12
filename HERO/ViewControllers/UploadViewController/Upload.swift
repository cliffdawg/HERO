//
//  Upload.swift
//  HERO
//
//  Created by Clifford Yin on 2/1/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit
import AlamofireImage
import Firebase
import FirebaseDatabase
import FirebaseStorage
import ChameleonFramework

/* This code manages the uploading-post page of HERO */
class Upload: UIViewController, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, ChooseClubDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    // MARK: Properties
    
    let storageRef = FIRStorage.storage().reference()
    var image: UIImage = UIImage()
    var selecting = true
    var filter = "none"
    var ref = FIRDatabase.database().reference()
    var isEdited = false
    var colorArray = ColorSchemeOf(colorSchemeType: ColorScheme.complementary, color: FlatYellow(), isFlatScheme: true)
    var darkOrange: UIColor!
    var goldOrange: UIColor!
    var yellowOrange: UIColor!
    var purple: UIColor!
    var darkPurple: UIColor!
    var tanColor = UIColor.init(red: 224/255, green: 211/255, blue: 153/255, alpha: 1.0)
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        caption.delegate = self
        caption.text = "Caption..."
        caption.textColor = UIColor.lightGray
        caption.font = .boldSystemFont(ofSize: 17)
        
        // Implement Chameleon framework
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
        name.layer.borderColor = tanColor.cgColor
        name.layer.borderWidth = 2.0
        name.layer.cornerRadius = 0
        caption.layer.borderColor = tanColor.cgColor
        caption.layer.borderWidth = 2.0
        caption.layer.cornerRadius = 0
        self.upload.tintColor = purple
        self.removePic.tintColor = .red
        self.pickClub.tintColor = purple
        
        let colors2:[UIColor] = [
            darkPurple,
            UIColor.flatWhite()
        ]
        
        self.back.tintColor = purple
        self.uploadd.backgroundColor = GradientColor(gradientStyle: .radial, frame: uploadd.frame, colors: colors2)
        
        removePic.isUserInteractionEnabled = false
        removePic.setTitle("", for: .normal)
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alertController = UIAlertController(title: "No Internet Connection", message:
                "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white
        
        // Allows photo to be tapped
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imageView.addGestureRecognizer(tapGesture)
        
        upload.isUserInteractionEnabled = false
        upload.setTitle("", for: .normal)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Upload.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: IBOutlets/Actions
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var removePic: UIButton!
    @IBOutlet weak var select: UILabel!
    @IBOutlet weak var uploadd: UIImageView!
    
    // Select a different picture
    @IBAction func removePic(_ sender: Any) {
        imageView.image = nil
        imageView.alpha = 0.5
        image = UIImage()
        removePic.isUserInteractionEnabled = false
        removePic.setTitle("", for: .normal)
        upload.isUserInteractionEnabled = false
        upload.setTitle("", for: .normal)
        self.selecting = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imageView.addGestureRecognizer(tapGesture)
        select.text = "Select Photo"
    }
    
    @IBOutlet weak var upload: UIButton!
    
    // Uploads the post data/picture to Firebase
    @IBAction func upload(_ sender: Any) {
        let refd = ref.childByAutoId()
        let ided = UIDevice.current.identifierForVendor!.uuidString
        refd.setValue(["name": name.text, "club": clubLabel.text, "caption": caption.text])
        refd.child("device").setValue(["id": ided])
        let refdStore = refd.key
        let mountainsRef = storageRef.child(refdStore)
        let localFile = UIImagePNGRepresentation(image)
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/png"
        mountainsRef.put(localFile!, metadata: nil)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.font = .boldSystemFont(ofSize: 17)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Caption..."
            textView.textColor = UIColor.lightGray
            textView.font = .boldSystemFont(ofSize: 17)
        }
    }
    
    @IBOutlet weak var pickClub: UIButton!
    
    @IBOutlet weak var clubLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    // Allows the user to pick which category of community service to represent the post
    @IBAction func pickClub(_ sender: AnyObject) {
    
        let popoverViewController = self.storyboard?.instantiateViewController(withIdentifier: "clubChoices") as! clubChoices
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.preferredContentSize = CGSize(width:300, height:300)
        popoverViewController.delegate2 = self
        
        let popoverPresentationViewController = popoverViewController.popoverPresentationController
        popoverPresentationViewController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popoverPresentationViewController?.delegate = self
        popoverPresentationViewController?.sourceView = self.pickClub
        popoverPresentationViewController?.sourceRect = CGRect(x:0, y:0, width: pickClub.frame.width / 2, height: pickClub.frame.height)
        present(popoverViewController, animated: true, completion: nil)
    }
    
    var imagePickerController: UIImagePickerController?
    

    func keyboardWillShow(_ notification: NSNotification){
        self.isEdited = true
        let tapp: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Upload.dismissKeyboard))
        imageView.addGestureRecognizer(tapp)
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification){
        self.isEdited = false
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        if self.selecting == true{
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)

        } else
            if self.selecting == false{
                let expandGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageExpand(_:)))
                imageView.addGestureRecognizer(expandGesture)
        }
    }
    
    // Allow user to select a new picture
    func imageTapped(_ sender: UITapGestureRecognizer) {
        if (sender.view as? UIImageView) != nil {
            // Allow user to choose between photo library and camera
            let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .default) { (action) in
                self.showImagePickerController(sourceType: .photoLibrary)
            }
            alertController.addAction(photoLibraryAction)
            
            // Only show camera option if rear camera is available
            if (UIImagePickerController.isCameraDeviceAvailable(.rear)) {
                let cameraAction = UIAlertAction(title: "Photo from Camera", style: .default) { (action) in
                    self.showImagePickerController(sourceType: .camera)
                }
                alertController.addAction(cameraAction)
            }
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func imageExpand(_ sender: UITapGestureRecognizer) {
        if isEdited == false {
            let imageView = sender.view as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            newImageView.frame = self.view.frame
            newImageView.backgroundColor = .black
            newImageView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            
            UIView.animate(withDuration: 2.0,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.9),
                           initialSpringVelocity: CGFloat(6.0),
                           options: UIViewAnimationOptions.allowUserInteraction,
                           animations: {
                            newImageView.transform = CGAffineTransform.identity
            },
                           completion: { Void in()  }
            )

            
            newImageView.contentMode = .scaleAspectFill
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
                self.view.addSubview(newImageView)
            
        } else {
            
        }
    }

    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    // Implement a new photo being selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage2 = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let size = CGSize(width: 500.0, height: 500.0)
            let pickedImage = pickedImage2.af_imageAspectScaled(toFit: size)
            imageView.alpha = 1.0
            imageView.image = pickedImage
            image = pickedImage
            removePic.isUserInteractionEnabled = true
            removePic.setTitle("Remove Photo", for: .normal)
            select.text = ""
            upload.isUserInteractionEnabled = true
            upload.setTitle("Upload", for: .normal)
            self.selecting = false
            let expandGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageExpand(_:)))
            imageView.addGestureRecognizer(expandGesture)
        }
        
        dismiss(animated: true, completion: nil)
    }

    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        
        present(imagePickerController!, animated: true, completion: nil)
    }

    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle{
        return .none
    }

    func chooseClub(chosenClub: String) {
        self.clubLabel.text = chosenClub
    }
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "backFeed1" || segue.identifier == "backFeed2") {
                let dest = segue.destination as! ViewController
                dest.filterName = self.filter
            }
    }

}
