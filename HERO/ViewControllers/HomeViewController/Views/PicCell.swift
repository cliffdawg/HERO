//
//  PicCell.swift
//  HERO
//
//  Created by Clifford Yin on 1/29/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI

/* This code displays a post as a collectionView cell in ViewController */
class PicCell: UICollectionViewCell {

    @IBOutlet weak var thumbImage: UIImageView!
    var picID = ""
    var nameText = ""
    var captionText = ""
    var clubText = ""
    @IBOutlet weak var tintView: UILabel!
    let storageRef = FIRStorage.storage().reference()
    
    func configureCell(name2: String, caption2: String, club2: String, imageReference2: String) {
        let reference = storageRef.child(imageReference2)
        self.backgroundColor = .white
        self.thumbImage.sd_setImage(with: reference)
        // Resize to fit best
        self.thumbImage.contentMode = .center
        let size = CGSize(width: 275.0, height: 275.0)
        thumbImage.image? = (thumbImage.image?.af_imageScaled(to: size))!
    
        self.nameText = name2
        self.captionText = caption2
        self.clubText = club2
        self.picID = imageReference2
        
    }

}


