//
//  filterCell.swift
//  HERO
//
//  Created by Clifford Yin on 3/23/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit

/* Code that constitutes a filter selection cell in the filter view */
class filterCell: UITableViewCell {
    
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var imageName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(categorized: String) {
          cellImage.image = UIImage(named: categorized)
          let size = CGSize(width: 80.0, height: 80.0)
          cellImage.image? = (cellImage.image?.af_imageAspectScaled(toFit: size))!
          imageName.text = categorized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
    
}

