//
//  postPage.swift
//  HERO
//
//  Created by Clifford Yin on 3/1/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit
import FirebaseStorageUI
import Firebase
import ChameleonFramework

/* This page displays the post when pressed upon */
class postPage: UIViewController{
    
    let storageRef = FIRStorage.storage().reference()
    var post:post!
    var colorArray = ColorSchemeOf(colorSchemeType: ColorScheme.complementary, color: FlatYellow(), isFlatScheme: true)
    var darkOrange: UIColor!
    var goldOrange: UIColor!
    var yellowOrange: UIColor!
    var purple: UIColor!
    var darkPurple: UIColor!
    var tanColor = UIColor.init(red: 224/255, green: 211/255, blue: 153/255, alpha: 1.0)
    
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var scroll: UIView!
    @IBOutlet weak var frameView: UIImageView!
    @IBOutlet weak var captionBack: UILabel!
    @IBOutlet weak var nameBack: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var caption: UITextView!
    
    override func viewDidLayoutSubviews() {
        self.caption.setContentOffset(.zero, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let colors2:[UIColor] = [
            self.yellowOrange,
            UIColor.flatWhite()
        ]
        let colors3:[UIColor] = [
            self.goldOrange,
            UIColor.flatWhite()
        ]
        
        scroll.backgroundColor = GradientColor(gradientStyle: .leftToRight, frame: scroll.frame, colors: colors)
        self.back.tintColor = purple
        self.nameBack.backgroundColor = GradientColor(gradientStyle: .leftToRight, frame: scroll.frame, colors: colors2)
        self.captionBack.backgroundColor = GradientColor(gradientStyle: .leftToRight, frame: scroll.frame, colors: colors3)
        
        // Download, scale, and display the post picture
        let reference = storageRef.child(post.imageReference)
        imageView.sd_setImage(with: reference)
        let size = CGSize(width: 450.0, height: 405.0)
        imageView.image? = (imageView.image?.af_imageScaled(to: size))!
        
        name.text = post.name
        caption.text = post.caption

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
