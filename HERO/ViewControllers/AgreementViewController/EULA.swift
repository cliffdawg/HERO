//
//  EULA.swift
//  HERO
//
//  Created by Clifford Yin on 5/25/17.
//  Copyright © 2017 Clifford Yin. All rights reserved.
//

import UIKit
import ChameleonFramework

/* EULA agreement that the user must confirm */
class EULA: UIViewController {
    
    var colorArray = ColorSchemeOf(colorSchemeType: ColorScheme.complementary, color: FlatYellow(), isFlatScheme: true)
    var darkOrange: UIColor!
    var goldOrange: UIColor!
    var yellowOrange: UIColor!
    var purple: UIColor!
    var darkPurple: UIColor!
    var tanColor = UIColor.init(red: 224/255, green: 211/255, blue: 153/255, alpha: 1.0)
    
    @IBOutlet weak var agree: UIButton!
    @IBOutlet weak var agreement: UITextView! // EULA agreement in this textView
    
    @IBAction func agree(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        self.agreement.setContentOffset(.zero, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.agree.tintColor = purple
        self.agreement.layer.cornerRadius = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
