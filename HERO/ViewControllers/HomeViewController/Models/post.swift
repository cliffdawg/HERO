//
//  post.swift
//  HERO
//
//  Created by Clifford Yin on 2/26/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit

/* This code constitutes the structure of a user's post in the app */
class post{

    var name = ""
    var caption = ""
    var club = ""
    var imageReference = ""
    
    init(name1: String, caption1: String, club1: String, imageReference1: String){
        self.name = name1
        self.caption = caption1
        self.club = club1
        self.imageReference = imageReference1
    }

}

