//
//  club.swift
//  HERO
//
//  Created by Clifford Yin on 2/2/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit

/* Code that represents a community service type choice */
class club: UITableViewCell {

    @IBOutlet weak var clubName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(clubbed: String) {
        self.clubName.text = clubbed
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
