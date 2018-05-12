//
//  block.swift
//  HERO
//
//  Created by Clifford Yin on 5/16/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit

/* Code that represents a blocking option in the block view */
class block: UITableViewCell {
    
    @IBOutlet weak var blockName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(blocked: String) {
        self.blockName.text = blocked
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
